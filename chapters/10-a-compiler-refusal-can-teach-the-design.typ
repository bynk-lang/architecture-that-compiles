#import "../template.typ": code-listing, compiler-message, lead-in

#let source-lines(path, start, end) = {
  read(path).split("\n").slice(start, end).join("\n")
}

= A compiler refusal can teach the design <a-compiler-refusal-can-teach-the-design>

A compiler refusal is an interruption. The author had an intention, expressed
enough of it to ask the machine a question, and received no program in return.
However elegant the type system, the immediate experience is negative: the
work cannot continue in its present form.

That interruption creates an unusual opportunity. The attempted program and the
language's model of a valid program have met at one precise contradiction. The
compiler knows the source location, the rule, and at least some of the facts
that made the rule fail. A useful diagnostic can turn those facts into design
feedback while the author still has the relevant decision in mind.#footnote[
  Elm's “Compiler Errors for Humans” made the case for error messages as user
  experience. A survey of the research is Becker et al., “Compiler Error
  Messages Considered Unhelpful”.
]

A poor diagnostic wastes the same opportunity. It reports a missing symbol, an
incompatible internal type, or a generic failure in generated machinery. The
program remains rejected, but the author must reconstruct the language's reason
before deciding what to change.

#quote(block: true)[
  A refusal teaches only when it makes the invisible rule visible.
]

This matters in any language. It matters more when a language claims authority
over architecture. If Bynk rejects a program because contexts form an invalid
dependency graph, saying merely that a name could not be resolved is not an
implementation blemish around the real feature. The explanation is how the
author encounters the feature.

== A type error is not yet an explanation <ix-10-a-type-error-is-not-yet-an-explanation>

Many compiler messages answer a local question well. A record lacks a field. A
function received three arguments instead of two. A string was supplied where
an integer was required. The source location and the expected and actual shapes
often contain everything needed to repair the mistake.

Architectural contradictions are less local. The token underlined at a call
site may be perfectly spelled and the service may exist. The problem is a
relationship absent from a context header. A `consumes` clause may be valid in
isolation while completing a cycle elsewhere in the project. A capability call
may have the right argument and result types while exceeding the authority
declared by its handler.

For such failures, a useful diagnostic needs more than a symptom. It should
identify the rule that failed, name the architectural participants, point to the
place where the contradiction became concrete, and distinguish a mechanical
repair from a design choice.

#figure(
  block(width: 100%)[
    #set text(size: 8.5pt, hyphenate: false)
    #set par(justify: false, leading: 0.58em, first-line-indent: 0pt)
    #table(
      columns: (0.82fr, 1.2fr, 1.55fr),
      inset: (x: 0.5em, y: 0.5em),
      stroke: (x, y) => if y == 0 { (bottom: 0.8pt + rgb("#4b44d6")) } else { none },
      table.header(
        text(weight: "semibold")[Element],
        text(weight: "semibold")[Question answered],
        text(weight: "semibold")[Failure without it],
      ),
      [Location], [Where did the contradiction surface?], [The author must search],
      [Stable code], [Which language rule was violated?], [Tools and documentation guess from prose],
      [Message], [What facts disagree?], [The rule remains abstract],
      [Labels and notes], [Which other evidence matters?], [A non-local cause looks local],
      [Suggestion], [Is any edit mechanically safe?], [Repair and redesign are confused],
    )
  ],
  caption: [A useful diagnostic is an explanation with several audiences, not a decorated error string.],
)

Not every refusal needs every element. A misspelled field does not require an
essay. The standard is proportional: the further the rule reaches beyond the
underlined expression, the more of that reach the diagnostic should recover.

== Name the rule, not only the symptom <ix-10-name-the-rule-not-only-the-symptom>

#lead-in[
Chapter 1 used one refusal to introduce contexts. Return to it, this time to
look at how it is built. Suppose a returns context calls the inventory service
directly:
]

#code-listing(
  [The service exists, but the calling context declares no permission to reach it],
  read("../snippets/chapter-10/undeclared-edge/src/commerce/returns.bynk"),
  lang: "bynk",
)

The call is recognisable. Its arguments are valid. Inventory really does expose
`release`. Treating this as an unknown function would describe the compiler's
failed lookup rather than the program's failed architecture.

#lead-in[
Bynk instead reports:
]

#compiler-message[
[bynk.resolve.unconsumed_context] Error:
`commerce.inventory.release` looks like a cross-context service call,
but `commerce.inventory` is not in this context's `consumes` clauses
]

The code names a static rule rather than a particular English sentence. The
message then supplies the facts relevant to this occurrence: the full service
call, the target context, and the missing declaration. The author does not have
to infer whether inventory was undiscovered, misspelled, private, or merely
unreachable.

That distinction is the lesson. A call across a context boundary is not enabled
by the existence of a public function. It is enabled by a declared relationship
between contexts.

The stable code also gives tools something firmer than message text. The same
refusal can be rendered as a source-rich report for a person, a compact line
for continuous integration, or an editor action that adds the missing
`consumes` clause, and each rendering can link back to the rule it enforces.

== A fix is not a design decision <ix-10-a-fix-is-not-a-design-decision>

Adding the missing clause is a plausible next edit. It is not necessarily the
right design.

#lead-in[
Imagine that inventory already consumes returns to ask whether an item is
eligible. The suggested edit makes the opposite edge explicit:
]

#code-listing(
  [Each header is locally clear; together they form a cycle],
  source-lines(
    "../snippets/chapter-10/cycle/src/commerce/inventory.bynk",
    0,
    3,
  ) + "\n\n" + source-lines(
    "../snippets/chapter-10/cycle/src/commerce/returns.bynk",
    0,
    3,
  ),
  lang: "bynk",
)

#lead-in[
The project now reaches a different refusal:
]

#compiler-message[
[bynk.context.consumes_cycle] Error:
`consumes` cycle detected:
commerce.returns → commerce.inventory → commerce.returns

Note: units must form an acyclic `consumes` graph; remove one of the
`consumes` clauses or restructure
]

The first diagnostic was not wrong. It exposed the undeclared edge required by
the attempted call. The quick fix was not fraudulent either: it performed the
local edit its title promised. Applying it revealed a second, project-wide fact
that could not be decided at the original call site.

Now the compiler should stop. It can show the cycle and explain that the graph
must be acyclic. It cannot know whether return eligibility belongs to returns,
inventory should own the whole operation, a third context should coordinate the
two, or the interaction should become an asynchronous protocol. Choosing one
would require business and organisational knowledge absent from the source.

#lead-in[
In the compiler-checked version used here, eligibility remains with returns.
Inventory releases stock without calling back, so the dependency has one
direction:
]

#code-listing(
  [The repaired graph follows a decision about ownership, not an automatic rewrite],
  read("../snippets/chapter-10/declared/src/commerce/returns.bynk"),
  lang: "bynk",
)

A local refusal exposes a hidden dependency; the graph reveals a larger
contradiction. The repair may be architectural. Tooling accelerates discovery
without pretending to make the decision.

== Advice and refusal are different commitments <ix-10-advice-and-refusal-are-different-commitments>

#lead-in[
A teaching compiler also needs to distinguish invalid programs from untidy
ones. Suppose a handler declares an audit capability but never calls it:
]

#code-listing(
  [The declared requirement is unused, but the handler remains well formed],
  source-lines(
    "../snippets/chapter-10/warning/src/commerce/returns.bynk",
    10,
    15,
  ),
  lang: "bynk",
)

#lead-in[
The compiler reports:
]

#compiler-message[
[bynk.given.unused_capability] Warning:
capability `Audit` is declared in `given` but never used in the body

Note 1: alternatively, use the capability in the body

Note 2: help: remove `Audit` from the `given` clause
]

Compilation still succeeds. The extra requirement may be stale, copied from
another handler, or retained during an unfinished edit. It makes the declared
effect surface less precise, but it does not grant the body an effect that the
declaration omitted. Bynk treats that difference as advice rather than
well-formedness.

Here a mechanical suggestion is appropriate. Removing an unused entry from a
list is a bounded source edit, and the compiler can account for commas,
whitespace, and the case where `given` becomes empty. The action does not need
to invent an architectural relationship.

#lead-in[
Severity is therefore part of the language's honesty:
]

#figure(
  block(width: 100%)[
    #set text(size: 8.5pt, hyphenate: false)
    #set par(justify: false, leading: 0.58em, first-line-indent: 0pt)
    #table(
      columns: (0.8fr, 1.55fr, 1.3fr),
      inset: (x: 0.5em, y: 0.5em),
      stroke: (x, y) => if y == 0 { (bottom: 0.8pt + rgb("#4b44d6")) } else { none },
      table.header(
        text(weight: "semibold")[Form],
        text(weight: "semibold")[What is known],
        text(weight: "semibold")[Consequence],
      ),
      [Error], [The source contradicts a static language rule], [Reject the program],
      [Warning], [The source is valid but carries a recognised risk or smell], [Compile and report],
      [Runtime result], [The answer depends on a value or the outside world], [Represent and handle it],
    )
  ],
  caption: [A compiler should reject only where its knowledge justifies refusal.],
)

Turning every opinion into an error would make the language rigid in the wrong
way. Turning every invariant into a warning would return authority to
convention. The boundary between the two is itself a language-design decision.

== The compiler must know when it does not know <ix-10-the-compiler-must-know-when-it-does-not-know>

The third row is as important as the first two. Chapter 2 drew the same line
for refined values: a literal outside its range is refused at compile time,
while a value that arrives at runtime must pass through `.of` and its `Result`.
Rejecting all dynamic construction would teach nothing, and silently trusting
it would teach the wrong thing. The lesson is the edge of the compiler's
knowledge.

That restraint matters more when a diagnostic discusses architecture. The
compiler knows that a handler uses a capability it did not declare, and that
contexts form a cycle. It does not know whether the capability belongs there,
or which context should own the operation. A precise refusal should increase
the author's understanding without borrowing authority it has not earned.

== Diagnostics are part of the language <ix-10-diagnostics-are-part-of-the-language>

It is tempting to treat diagnostics as polish applied after the type checker is
complete. For a constraint-oriented language, that separation is misleading.
The static rule defines which programs are admitted; the diagnostic is the
usable account of why one was not.

That makes diagnostics worth testing like any other part of the language: a
deliberately invalid program paired with the code it must produce, as this
book's own rejected examples are.

None of this makes error messages a proof that the language design is sound. A
stable code can identify a misguided rule very reliably. A lucid explanation
can teach a constraint the user ultimately rejects. Diagnostics improve the
conversation between a language and its authors; they do not settle whether the
language deserves the final word.

TypeScript's compiler and language service often produce excellent local
explanations, and its tooling supports lint rules, refactorings, and custom
architectural checks. Bynk's advantage is narrower. Because `context`,
`consumes`, `given`, `agent`, and the entry protocols are language constructs,
its diagnostics can name those concepts directly. A TypeScript tool can reach
similar conclusions only after a team has supplied an architectural model for
it to enforce.

A refusal can therefore teach the design, but only the design the language can
actually see.

That completes Part III. Tests can preserve the declared architecture without
claiming proof; a running system names its own refusals and leaves the rest to
the platform; diagnostics can explain a contradiction without choosing the
design. All three, though, have quietly assumed the harder thing---that a team would
take on this language, its compiler, its editor integration, its build path, and
its runtime story at all.

Part IV tests the argument against that assumption. It opens with the
question the prologue promised to face: why a language at all, rather than a
framework. It then looks at the bargain that makes adoption thinkable---a new
language for the architectural model, running on a runtime nobody has to
invent---reads a whole system to see how much architecture the source can
really recover, changes that system to see what survives the next edit, and
closes by accounting for everything the stronger constraints cost.
