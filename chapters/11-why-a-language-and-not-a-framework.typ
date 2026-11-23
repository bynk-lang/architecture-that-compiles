#import "../template.typ": lead-in

= Why a language, and not a framework <why-a-language-and-not-a-framework>

Almost every chapter so far has made the same concession. A team that wants
distinct identifiers can brand its strings. A team that wants failure in its
contracts can adopt a result library. Dependency injection makes effects
visible, a repository can own every write, a reducer can own every transition,
a route group can own authentication, an adapter can own a protocol, and a mock
library can be held to interfaces. Each guarantee in Parts I to III can be
approximated in TypeScript, and the book has said so at each step.

The prologue named the objection those concessions add up to, and promised to
face it. If Bynk compiles to TypeScript and reuses its runtime, and if every
individual guarantee can be reproduced in TypeScript with enough discipline,
why introduce a new language at all rather than a strict framework: a package
of branded types, a schema library, an effect library, generated wiring, and a
lint configuration that forbids the rest?

#quote(block: true)[
  A framework asks a team to stay disciplined. A language moves the discipline
  beneath the point where a team can be tempted out of it.
]

== The framework is a good answer <ix-11-the-framework-is-a-good-answer>

It is the right question, because that framework can be very good. A team that
adopts one buys most of what Parts I and II describe without a second compiler,
a smaller labour market, or a new toolchain to own. For many systems that is the
better trade, and this book does not pretend otherwise.

The difference is not what each guarantee expresses in isolation. It is what
holds the guarantees together.

== What holds the TypeScript version together <ix-11-why-a-language-and-not-a-framework>

#lead-in[
Chapters 2 to 9 each ended their comparison by naming it, and chapter 1's
table named the first. Together the answers form a ledger:
]

#figure(
  block(width: 100%)[
    #set text(size: 8.2pt, hyphenate: false)
    #set par(justify: false, leading: 0.56em, first-line-indent: 0pt)
    #table(
      columns: (0.85fr, 1.35fr, 1.3fr),
      inset: (x: 0.45em, y: 0.48em),
      stroke: (x, y) => if y == 0 { (bottom: 0.8pt + rgb("#4b44d6")) } else { none },
      table.header(
        text(weight: "semibold")[Concern],
        text(weight: "semibold")[The TypeScript version holds while…],
        text(weight: "semibold")[Bynk holds it in…],
      ),
      [Boundaries (ch. 1)], [an import rule stays configured and enabled], [a context's `consumes` clauses],
      [Identity (ch. 2)], [nobody writes `as OrderId`], [an opaque type, minted only by its commons],
      [Failure (ch. 3)], [nobody throws beside the `Result`, and every `switch` remembers its `never` check], [closed sums and exhaustive `match`],
      [Effects (ch. 4)], [nobody imports the global client the injected one replaced], [a handler's `given` clause],
      [State (ch. 5)], [every write goes through the repository], [an agent's handlers, the only route to its fields],
      [Transitions (ch. 6)], [every change goes through the reducer], [invariants and transitions checked at commit],
      [Callers (ch. 7)], [every route is registered inside the protected group], [a required `by` clause on every HTTP handler],
      [Protocols (ch. 8)], [each adapter keeps to its own contract], [a handler form and return type per protocol],
      [Tests (ch. 9)], [mocks are kept to seams production really has], [stubs that only name declared capabilities],
    )
  ],
  caption: [The same nine guarantees, and the different things that keep them true.],
)

The left-hand column is not a list of weaknesses. Each is a reasonable rule,
and a good team keeps most of them most of the time. What the column shows is
that each is kept by something outside the language: a cast left unwritten, an
exhaustiveness check remembered, a singleton not imported, a write kept inside
the repository, a route kept inside the protected group.

A framework's rules live beside the language's own, and the language does not
know they exist. A branded type is a suggestion a cast can bypass. An import
rule is a linter's opinion a disabled comment can silence. An effect convention
holds until an imported singleton is more convenient. Each rule is enforced by
a different tool, configured separately, and any one can be relaxed in a single
file without the others noticing. The architecture is present, but nothing
requires the pieces to stay aligned, and the pressure to misalign them arrives
one reasonable exception at a time---precisely the erosion the prologue
described.

A language makes the same facts the definition of a valid program. `consumes`,
`given`, an agent key, and a `by` clause are not checks layered over the
program; they are the program. Nor is there a setting that relaxes them: a Bynk
project's manifest configures its paths, its formatting, and its editor, and
nothing else.

== Bynk's own escape hatches <ix-11-bynks-own-escape-hatches>

That is not the same as having no escape hatches, and an honest comparison has
to include Bynk's own. An opaque value can be minted with `.unsafe`, bypassing
its checked constructor. An adapter runs arbitrary TypeScript behind a
capability. A wildcard `_`, or a plain `else` after a `let` pattern, stops a
match from distinguishing variants that do not exist yet. Each is as searchable
as an `as` cast or an `eslint-disable` comment; a text search finds both kinds.

The difference is where an escape hatch can appear, and who owns it.
`.unsafe` compiles only inside the commons that defines the opaque type;
anywhere else the compiler refuses it, and a refined type has no `.unsafe` at
all. An adapter is a declared unit that names its TypeScript binding file, and a
context reaches it only through a `consumes` clause, so that TypeScript sits
behind a boundary the context header lists. A wildcard affects one match and
nothing outside it. An `as OrderId`, by contrast, compiles in any file that can
see the type, and a disabled lint rule opens an import boundary wherever the
comment is placed. TypeScript's escape hatches are available everywhere and
owned by whoever types them. Bynk's are fixed to the owner of the thing being
bypassed.

== What the answer settles <ix-11-what-the-answer-settles>

That is the whole of the difference, and it is both smaller than a newcomer
expects and larger than it sounds. Everything a framework can say, it says in
a place the language cannot see. Everything Bynk says, it says in the place
that decides which programs exist.

Whether that is worth a compiler and a platform commitment is a genuine
question, not a settled one. It turns on how expensive misalignment actually is
in a given system, and how reliably a particular team holds a convention under
deadline. The honest short answer is that the framework is the right choice
more often than a language advocate would like to concede, and the language
earns its place precisely when the cost of a convention quietly failing is high
enough to justify removing the option to fail.

The rest of Part IV tests that claim from four directions. Chapter 12 asks what
a new language costs before it has checked anything: the compiler, the
runtime, and the platform it inherits. Chapter 13 reads a whole system to see
how much of its architecture the source recovers. Chapter 14 changes that
system, including one change made both ways, in Bynk and in TypeScript, to see
where each language keeps the decision. Chapter 15 adds up everything the
stronger constraints cost.
