#import "../template.typ": code-listing, compiler-message, lead-in

#let source-lines(path, start, end) = {
  read(path).split("\n").slice(start, end).join("\n")
}

= Changing a system that compiles <changing-a-system-that-compiles>

Chapter 12 read a system and left its problems standing. Any authenticated
customer could read any order. A declined payment left stock reserved. Every
payment failure reached the customer as the same unavailable service. The
chapter's point was that the source made those problems findable, not that it
made them impossible.

Finding a problem is the easy half. The prologue's service did not decay
because nobody could read it. It decayed through a series of reasonable
changes, each reviewed and tested, until the diagram on the whiteboard no
longer described the program. If Bynk's argument holds anywhere, it has to
hold there: in the next change, made by someone who did not write the last
one.

#quote(block: true)[
  An architecture is tested less by the program that first compiles than by
  the change that follows it.
]

This chapter makes four changes to the Chapter 12 system, ships one of them the
way independent teams ship, and then changes the shape of the event Chapter 8
introduced. Each change is a separate compiled
project, and each diff below is generated from two of them. The question for
every change is the same: what did the compiler require, what did it merely
allow, and where did the decision end up?

#lead-in[
The requirements are ordinary ones:
]

1. A customer may read only their own order.
2. A failed payment must release the stock it held.
3. The payment provider starts flagging suspected fraud as a distinct decline.
4. Fraud assessment becomes a context of its own, consulted before charging.
5. The payments team deploys its change without waiting for orders.
6. Receipts need a currency, and later someone wants amounts sent as text.

== A rule the compiler could not ask for <ix-13-a-rule-the-compiler-could-not-ask-for>

The first change closes Chapter 12's authorisation question. The order agent
already records an owner when an order begins. The read route never compared
it with the caller.

#code-listing(
  [The read now takes the caller's identity and returns nothing to anyone else],
  read("../snippets/chapter-13/diffs/step-1-orders.diff"),
  lang: "diff",
)

The agent's unconditional `view` is gone. In its place, `viewFor` takes a
`CustomerId` and returns an `OrderView` only when it matches the stored owner.
The route binds its caller as `customer`, passes the verified identity to the
agent, and answers `NotFound` when the agent declines. Through this route, a
stranger learns nothing, not even that the order exists. That is a product
decision the diff states plainly. A team that preferred `Forbidden` would write
that instead.

The same decision is not yet made everywhere. Submitting an order whose
identifier is already taken still answers `409 Conflict`, so the creation
route tells any authenticated customer that an order exists. Nothing in this
change touched that route, and nothing in the language connects the two. A
rule stated once is enforced where it was stated.

Nothing in Bynk demanded this change. The Chapter 12 program compiled, and it
would have gone on compiling indefinitely. An actor establishes who is calling;
it does not know which orders belong to whom. Chapter 7 drew that line, and it
holds here: object-level authorisation is a rule the team has to state.

What the language changes is where the rule lives once stated. The comparison
sits in the agent that owns the order, next to the field it reads. The
unconditional read no longer exists, so a later route cannot reach for it
without adding a handler that a reviewer would see restored. The rule is not
proved, but it is placed, and it has removed the easy way around itself.

== Compensation becomes a contract <ix-13-compensation-becomes-a-contract>

The second change answers Chapter 12's harder finding. When payment failed,
the order became `Rejected` and the stock stayed reserved. Inventory had no
operation to undo a hold.

#lead-in[
It gains one:
]

#code-listing(
  [Inventory adds the inverse of a hold, as a handler and a service],
  read("../snippets/chapter-13/diffs/step-2-inventory.diff"),
  lang: "diff",
)

`release` adds the quantity back to `available` and takes it from `reserved`.
The stock invariant from Chapter 12 still applies, so releasing more than was
held would fail at the commit rather than drive `reserved` below zero. The new
`release` service puts the operation on inventory's public surface.

#lead-in[
The order side changes in three places:
]

#code-listing(
  [Orders releases stock on payment failure, and says a rejected order holds none],
  read("../snippets/chapter-13/diffs/step-2-orders.diff"),
  lang: "diff",
)

The payment-failure branch now calls `Inventory.release` before rejecting the
order. `reject` clears the reservation flag. And the agent gains a third
invariant: a rejected order holds no stock.

Notice what did not change. The context header is identical. Orders already
consumed inventory, so calling one more of its services needs no new
declaration. That is correct, and it is worth seeing: the diff adds behaviour
to an existing edge, not a new edge. A reviewer can tell those apart by
whether the header moved.

#lead-in[
The invariant is the more interesting line. Chapter 12 observed that "the
model never claimed that rejected orders release stock." Now it does. The
claim also reaches backwards. Run the Chapter 12 version of `reject`, which
set the status but left the flag, against the new invariant, and the commit is
refused:
]

#compiler-message[
InvariantViolation: Order.rejected_holds_no_stock
]

As Chapter 6 admitted, this is a runtime check, not a compile error. It fires
when the commit runs, in a test or in production. But it turns a rule that
existed only in the authors' intentions into one that every future handler
must satisfy. A later maintainer who adds a new rejection path and forgets the
flag will meet this message rather than a slow leak of reserved stock.

The compensation is still not a transaction. If `Inventory.release` faults,
the handler stops before `reject`, and the order stays `Placed` with its
reservation. That state satisfies every invariant and is still stuck. Chapter 5's
boundary has not moved: each owner commits alone. What the change has bought
is a stated rule and an attempted repair, not atomicity across two agents.

== A failure the wildcard absorbed <ix-13-a-failure-the-wildcard-absorbed>

#lead-in[
The third change starts in payments. The provider begins reporting suspected
fraud as its own outcome, and payments adds it to the error vocabulary it
exports:
]

#code-listing(
  [Payments adds a variant to the failures it presents],
  read("../snippets/chapter-13/diffs/step-3-payments.diff"),
  lang: "diff",
)

With orders left exactly as Chapter 12 wrote it, the project compiles.

That is not a compiler oversight. Orders matched the payment result with
`Err(_)`, so every failure, present and future, took the same branch. A
customer whose payment is flagged for fraud is now told that payment failed
with `503 Service Unavailable`: the response that invites a retry. Chapter 3
described the trade a wildcard makes. It buys a uniform policy and gives up
the compiler's help with future variants. Here is that bill arriving. The
wildcard was a decision made once, and it silently priced in every change to
the error type that followed.

#lead-in[
The team decides to name the failures. Its first attempt names the two it
knew about, and the compiler names the third:
]

#compiler-message[
[bynk.types.non_exhaustive_match] Error:
non-exhaustive `match` — variant `Fraudulent`
of `PaymentError` is not covered

Note: add a match arm for this variant, or use a wildcard `_` arm
]

#lead-in[
The note offers both ways out, the wildcard included. The compiler does not
insist on distinction; it insists on a choice. The team makes one:
]

#code-listing(
  [Each payment failure now has its own public meaning],
  read("../snippets/chapter-13/diffs/step-3-orders.diff"),
  lang: "diff",
)

The compensation runs once for every failure, then the match decides what
each one means to the customer. A decline is `422 Unprocessable Entity`. A
fraud flag is `403 Forbidden`. An unavailable provider remains `503`. Whether
those are the right statuses is a product and security question. That the
question has three answers, and that a fourth variant will raise it again, is
now a property of the program.

The lesson cuts against easy advocacy. Exhaustiveness is a strong guarantee,
but only where a program has not opted out of it. The Chapter 12 system had
opted out, in one line that looked like ordinary tidiness. A language can
make the opt-out visible. It cannot make a team notice that it has opted out
until the moment it matters.

== A new edge has to be declared <ix-13-a-new-edge-has-to-be-declared>

#lead-in[
The fourth change is architectural in the oldest sense. After a season of
fraud declines, the business wants orders assessed before any charge is
attempted, and fraud assessment becomes a context with its own owners:
]

#code-listing(
  [Fraud assessment is a context with one service and its own vocabulary],
  read("../snippets/chapter-13/step-4-fraud-context/src/commerce/fraud.bynk"),
  lang: "bynk",
)

#lead-in[
The quickest edit calls the new service from the order handler by its full
name. Bynk refuses it:
]

#compiler-message[
[bynk.resolve.unconsumed_context] Error:
`commerce.fraud.assess` looks like a cross-context service call,
but `commerce.fraud` is not in this context's `consumes` clauses
]

This is Chapter 1's refusal again, with new names. It reads differently in a
system with a history. In Chapter 1 the dependency was the first one; here it
is the third, added long after the first two by a team that may not have drawn
the original boundaries. The rule has not weakened with age. The new edge costs exactly
what the first one cost: a declaration.

#code-listing(
  [The architectural content of the change is one line in the context header],
  read("../snippets/chapter-13/diffs/step-4-header.diff"),
  lang: "diff",
)

That line carries more than review value. On the Workers target the project
now builds four Workers, and the orders Worker gains a `COMMERCE_FRAUD`
Service Binding beside its bindings to inventory and payments. The test
runner, which infers a `system` test's participants from the `consumes`
graph, now builds fraud alongside the other three. Nobody edited a deployment
manifest or a test fixture list; both follow from the header.

#lead-in[
The handler that uses the new edge has paid for every change in this chapter:
]

#code-listing(
  [Every decision in this chapter is visible in the handler, and so is their weight],
  source-lines(
    "../snippets/chapter-13/step-4-fraud-context/src/commerce/orders.bynk",
    81,
    139,
  ),
  lang: "bynk",
  breakable: true,
)

Read from the top, it is the order process the business described: begin,
assess, reserve, charge, and compensate on failure, with every refusal mapped
to a response. It is also eleven levels of indentation deep. Each `match` is a
decision point that an earlier chapter argued for, and together they form a
pyramid that a reader has to climb. Explicitness has volume, and some of it
lands here. Chapter 14 counts that cost alongside the others.

== The same change without a declaration <ix-13-the-same-change-without-a-declaration>

#lead-in[
Chapter 11 argued that a framework's rules hold for as long as the team's
discipline does, while a language removes the option of breaking them. That
claim deserves a comparison with something real, so here is step 4 made to
the conventional TypeScript order function from Chapter 1:
]

#code-listing(
  [The TypeScript change also shows its new dependency, as an import],
  read("../snippets/chapter-13/diffs/conventional.diff"),
  lang: "diff",
)

To be fair to it: this diff is perfectly visible. A careful reviewer sees the
new import and the new call, and can ask whether orders should depend on
fraud. Both versions pass `tsc --strict`.

The difference is not what this diff shows. It is what the language would have
accepted instead.

The import `../fraud/assess.js` looks exactly like an import of a helper. The
compiler does not know that one path is a utility and the other is another
team's service. If the call had reached fraud through an injected client, a
container lookup, or a helper inside the payment module, the diff to
`placeOrder` might show no new import at all, and every version would compile.
In Bynk, the call into another context was refused until the header declared
the edge, whether it was written by full name or through an alias. The version
without the declaration was not a quieter diff. It was not a program.

An import-boundary lint rule can close much of that gap, and in a disciplined
TypeScript codebase it should. That is the framework route Chapter 11
described. It works for as long as the rule is configured, maintained, and not
switched off for one file under deadline. The comparison does not show that
TypeScript cannot keep this architecture. It shows where each language keeps
it.

== Shipping one context at a time <ix-13-shipping-one-context-at-a-time>

Every change so far was checked against a whole project. Production is not a
whole project. Contexts become separate Workers precisely so that teams can
deploy them separately, and a deploy happens to a Worker, not to a source tree.

#lead-in[
Go back to step 3. Payments added `Fraudulent` to the failures it exports, and
the orders source, with its wildcard, compiled unchanged. Suppose the payments
team deploys at that point, alone:
]

```bash
bynk deploy --context commerce.payments
```

The deploy plan has one line, `redeploy commerce-payments`, and no warning.
The live orders Worker was built before the change, and it now calls a
payments Worker whose contract it has never seen.

#lead-in[
Bynk anticipated this. When it compiles orders, it stamps each call to
`charge` with a fingerprint of the contract orders was compiled against. When
it compiles payments, it stamps the Worker with a fingerprint of the contract
it provides. Adding a variant to an exported error changes the fingerprint.
The new payments Worker compares the two before it reads the request, and
refuses:
]

```text
409 {"kind":"ContractMismatch","service":"charge",
     "expected":"808bfde7a21640c2","actual":"888e75757af17f9e"}
```

That refusal is the right default. The alternative is a caller decoding a
response against a shape that is no longer true, and the natural failure of
that is not an error but a wrong answer. Notice, though, that the check
detects a change; it does not judge compatibility. This old orders Worker
would have absorbed the new variant through `Err(_)` without complaint. The
fingerprint refuses every call anyway, because Bynk does not run two versions
of a contract side by side. A contract change is a coordinated deploy.#footnote[
  Service contracts that evolve independently are usually managed with consumer-
  driven contracts (Ian Robinson). Bynk's fingerprint detects skew instead of
  negotiating it.
]

The refusal also arrives somewhere the step 2 code did not plan for. On the
caller's side, a `ContractMismatch` is thrown, not returned as an `Err`. In the
orders handler it surfaces at the charge call, after inventory has committed
the hold and the order has been marked reserved. The compensation branch never
runs, because the handler never receives a payment result to branch on. Each
failed request leaves one more order placed, reserved, and holding stock.
Chapter 12 warned about exactly this: a failure below the declared `Result`
skips the rejection path. Here is a way to produce one.

#lead-in[
The other direction is guarded earlier. Deploying an orders build compiled
against the old payments contract, after the new one is live, is refused at
the command line:
]

#compiler-message[
bynk: `commerce-orders` was compiled against a contract its live dependencies
no longer provide (bynk.deploy.contract_skew): \
commerce.payments.charge — compiled against 888e75757af17f9e,
live is 808bfde7a21640c2 \
Deploying this would ship a caller its callee rejects (409 ContractMismatch)
on every call. \
Deploy the whole project (`bynk deploy`) so both sides move together.
]

The deploy check reads the ledger of what is live, and it guards a context
against its own dependencies. It does not guard a context against the callers
that depend on it. So the asymmetry is exact: ship a caller ahead of its
contract and the command line stops you; ship a callee ahead of its callers and
production stops them.

The remedy the message names is to deploy the whole project, which pushes
dependencies first. Even that is an ordering, not an atomic switch: for the
moments between the payments upload and the orders upload, the old orders
Worker still meets the new payments. What the hashes guarantee is that skew of
any duration is loud and named, never a silent misreading of the wire.

== An event outlives the shape it was sent in <ix-13-an-event-outlives-the-shape-it-was-sent-in>

A service contract is checked at the moment two Workers call each other. An
event's shape has a longer life. Publishers and subscribers deploy separately,
so for a while a subscriber built from one version of the source receives
messages built from another. Bynk does not leave that to luck. It keeps a
record of every shape an event has had.

#lead-in[
Return to Chapter 8's `OrderPaid`. Receipts now need to show a currency:
]

#code-listing(
  [The event gains a field with a default, and the emitter supplies it],
  read("../snippets/chapter-13/diffs/step-6-orders.diff"),
  lang: "diff",
)

The new field carries a default, and the emitter still has to supply it. The
default is not for the publisher, which always knows the currency. It is for a
subscriber that receives a message minted before the field existed. A
subscriber built from this source decodes such a message with `currency` set to
`"GBP"`. A message missing a field that has no default is still refused as a
structural mismatch.

#lead-in[
The build records the change:
]

#code-listing(
  [The schema registry records the evolution, and its diff is what review sees],
  read("../snippets/chapter-13/diffs/step-6-lock.diff"),
  lang: "diff",
)

`bynk.schema.lock` is written by the build and committed with the source.
Every added field has a default, so the build classifies the change as additive
and raises the event's schema version from 1 to 2 on its own. Nobody chose the
number. The version travels in each emission's envelope as
`env.schemaVersion`, and a subscriber that needs to treat old and new messages
differently can dispatch on it.

#lead-in[
Now the change that is not additive. Someone decides that amounts should
travel as text, and retypes `cents` from `Int` to `String`, updating the
emitter to match. `bynkc check` accepts the project: inside one source tree,
every emitter and subscriber agrees on the new type. The build refuses it:
]

#compiler-message[
[bynk.event.non_additive_schema_change] `OrderPaid` changed in a way the
schema registry cannot evolve additively — field(s) retyped: cents

note: an additive change adds only fields that carry a default; give a
breaking change a new event type name instead
]

Nothing in the current source is inconsistent, which is why `check` cannot
object. The disagreement is with history: subscribers already deployed, and
messages already in flight, that expect `cents` to be a number. The registry is
how the program remembers its own past shapes. Its prescription is to give a
breaking change a new name, an `OrderSettled` that subscribers adopt
deliberately, rather than reuse an old name for a new meaning.

Two limits come with it. First, the registry is consulted when the project is
built, not when it is checked. A pipeline that runs only `bynkc check` would
merge the retype and meet the refusal at the next build, perhaps at deploy.
Second, the lock is a file in the repository, and its authority is only as
good as its history. Delete it and the next build starts the record again, with
every event at its current shape as version 1.

== What the changes asked for

#lead-in[
Six changes, laid side by side:
]

#figure(
  block(width: 100%)[
    #set text(size: 8.2pt, hyphenate: false)
    #set par(justify: false, leading: 0.56em, first-line-indent: 0pt)
    #table(
      columns: (0.85fr, 0.95fr, 1.2fr, 1.3fr),
      inset: (x: 0.45em, y: 0.48em),
      stroke: (x, y) => if y == 0 { (bottom: 0.8pt + rgb("#4b44d6")) } else { none },
      table.header(
        text(weight: "semibold")[Change],
        text(weight: "semibold")[Compiler required it?],
        text(weight: "semibold")[Where it landed],
        text(weight: "semibold")[Decided by people],
      ),
      [Order ownership], [No], [The agent that owns the order], [Who may read; what a stranger is told],
      [Compensation], [No; enforced at commit once stated], [An inventory handler and an order invariant], [That rejection releases stock],
      [Fraud decline], [Only once the wildcard was gone], [An exhaustive match at the HTTP boundary], [The public meaning of each failure],
      [Fraud context], [Yes], [One line in the context header], [Where fraud assessment lives],
      [Payments shipped alone], [No; refused at runtime, and at deploy only from the caller's side], [Contract fingerprints in both Workers], [Which contexts deploy together, and in what order],
      [Event reshaped], [A retype, yes, at build time; an added default, no], [The committed schema registry], [Whether a breaking change becomes a new event],
    )
  ],
  caption: [The compiler forced one source change outright and the build refused one more. The deployment caught skew loudly, but stopped only one direction of it before production.],
)

That table is the honest result. Of the four source changes, the compiler
required only one. It began enforcing a second only after the team wrote the
rule down, and it enforced a third only after the team gave up a shortcut it
had taken earlier. The fifth change was a deployment, and there the toolchain
turned a silent hazard into a loud one without preventing it. The sixth
reshaped an event, and there the build rather than the checker held the line:
it versioned the additive change by itself and refused the breaking one until
it took a new name. Most of the work was judgement, and the language did not
supply it.

What the language did in the source changes was keep the decision from becoming
convention again. The ownership check removed the read that bypassed it. The
compensation rule became an invariant that future handlers must satisfy. The
failure mapping became exhaustive, so the next variant will ask its own
question. The fraud dependency became a declaration that deployment and tests
now follow. The event's history became a committed record that the next build is
checked against. None of these decisions is permanent; each can be changed. None
can be undone quietly.

That is the claim this book has been making, tested where it matters most:
not that the program will be right, but that the next change to it will have
to say what it is changing.

The changes were not free. The handler grew deeper as decisions
accumulated. Adding a variant in payments meant editing a match in orders.
The fraud requirement touched a new context, a header, and a handler where the
TypeScript version touched one function. The next chapter takes those costs
seriously.
