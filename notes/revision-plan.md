# Revision plan

This plan follows the editorial review of October 2026, made against Bynk
0.313.0. The small fixes from that review are already done (PR 10). This plan
covers the larger issues. It changes no prose by itself; each workstream below
becomes one or more PRs.

## Progress (October 2026)

| Workstream | State | PRs |
|---|---|---|
| Small fixes from the review | Done | #10 |
| A: changing a system (new chapter 13, steps 1–6) | Done | #12, #13 (recovered by #16), #17 |
| B: thesis first, comparisons as a ledger | Done | #20 |
| C1: events in chapter 8 | Done | #14 |
| C2: evolution across deployments | Done, as chapter 13 steps 5 and 6 | #16, #17 |
| C3: operations | Done, as a section in chapter 9 | #21 |
| C4: adoption and exit | Done, in chapter 14 | #22 |
| C5: prior work | Done, except three books held back | #24, #25, #26 |
| Whole-book pass | Done | this PR |

Done along the way:
- **Gates.** A gate builds every snippet and type-checks the output (#15), with `build-fail` expectations (#17).
- **Snippet fixes.** Chapters 3–6 and 8 are restructured to Bynk's layout rule so they build (#18, #23).
- **Bynk issues.** Defects found while checking the book were filed upstream: accuser/bynk#1817, #1818, #1820–#1823, #1825–#1827.

Size: 40,701 words by `wc` over the preface and chapters (33,257 at the
review), about 36,600 of them prose once listings and footnotes are excluded.
That is below the brief's 45,000, which the plan expected, and the brief says
to let the argument set the length.

Still open:
- The three held-back books (Evans, Hohpe & Woolf, Kleppmann): add each once
  confirmed (`notes/prior-work.md`).
- The index is still the provisional proof. Its locators are chapter-level,
  and its lines set tightly enough that descenders touch.
- The pin moved to 0.314.23 after the revision (issue #35), which fixed the
  two baselined snippet builds (accuser/bynk#1821, #1823) and the unlogged
  faults chapter 9 described (#1825, #1826); its operations figure was
  rewritten to match.

## What the review found

1. **The thesis is about change, but the evidence is static.** The prologue
   tells how architecture erodes as a service changes, and the epilogue retells
   that story. No chapter shows a Bynk program going through a change: the
   edits the compiler forces, and what a reviewer then sees.
2. **The decisive argument arrives late and is not backed up.** "Why a
   language, and not a framework?" (chapter 11) answers the objection the
   prologue raises. Before that, eight "Could … do this? Yes" sections concede
   ground one chapter at a time. The answer itself is asserted, not
   demonstrated, and it says "no configuration to loosen" without dealing with
   Bynk's own escape hatches (`.unsafe`, adapters, a wildcard `_` arm).
3. **Topics are missing.** Events; how a system evolves across deployments
   (event schemas, contract skew); operations; an adoption path; prior work.
4. **The book is short of its target.** It has about 31,000 words of prose
   against the brief's 45,000–60,000.

Items 1 and 2 are about the argument. Items 3 and 4 are about coverage. The
plan does the argument first, because the new material should support a
sharper thesis rather than pad a weaker one.

## Working rules for every PR

These follow the README's checking discipline:

- Every new listing presented as a complete program is a snippet project under
  `snippets/`. It is compile-gated, with refusals added to
  `snippets/EXPECTATIONS.tsv`, and format-gated.
- Every quoted diagnostic is copied **word for word** from the pinned
  release's `bynkc check` output (`[code] Error:` header, plus the notes the
  chapter quotes). The gates compare codes only, so this is checked by hand.
- Every new or shifted `source-lines` range is re-derived, and its listing is
  read in the built PDF.
- Every claim about Bynk behaviour is reproduced against the pinned binary
  before it goes into prose. Steps marked **verify** below have not yet been
  checked.
- If a workstream needs a feature newer than the pin, it bumps the pin in its
  own PR first. That means `snippets.yml` and `metadata.typ` together; CI
  checks they agree.

## Workstream A: show the architecture surviving change

*Addresses finding 1, and supplies the evidence finding 2 needs. This is the
highest-value change.*

**Change.** Add a new chapter after "Reading a whole system", provisionally
**"Changing a system that compiles"**. It takes the chapter 12 system through
a sequence of realistic requirements. For each one it shows the compiler's
response and the diff a reviewer sees. Chapter 12 found three problems and
left them standing; this chapter is where the team fixes them, so the two read
as a pair.

Proposed sequence. Each step is a snippet project derived from
`chapter-12/whole-system`:

| Step | Requirement | What the reader should see |
|---|---|---|
| 1 | A customer may read only their own order (chapter 12's authorisation question) | The fix is a domain decision in the handler and the agent. The compiler does **not** force it, which is an honest data point: `by Customer` made the gap visible but cannot close it. Consider the `where` claim predicates from the actors/authorisation guide. |
| 2 | Release stock when payment fails (chapter 12's missing compensation) | `Stock` gains a `release` handler and an invariant change. The orders handler changes. The `consumes` graph does not change. That makes the diff's architectural content legible: new behaviour on an existing edge. |
| 3 | Payments adds a `Fraudulent` decline | Orders matches `Err(_)`, so the new variant is **absorbed silently**. That is chapter 3's wildcard trade-off, now with a cost the reader can see. Then show the match rewritten exhaustively and the compiler listing every place that must decide. **verify** the `non_exhaustive_match` text. |
| 4 | Fraud assessment becomes its own context | First the refusal (`bynk.resolve.unconsumed_context`, already used in chapter 1, so quote it in this new setting). Then the one-line header diff, the new Service Binding in the workers build, and the `system` test that now stands up four contexts. |
| 5 | Payments is deployed alone with a changed contract | Contract skew: `bynk deploy` refuses, and at runtime the Worker answers `ContractMismatch` (409). This is change across deployments rather than across source. **verify** with two workers builds. |

For one step (step 4 is the strongest), add a **TypeScript counterpart**: the
same requirement in the chapter 1 conventional code. Its diff compiles, and
nothing in it says "orders now depends on fraud". This replaces chapter 11's
assertion with a demonstration.

**Showing diffs.** Typst can only read files, so diffs need a source:

- Option (recommended): add `scripts/make-book-diffs.sh`, which writes `.diff`
  files from consecutive snippet projects. CI regenerates them and fails if
  any differ from the checked-in copies. That way a printed diff cannot drift
  from the snippets, the same idea as the other gates.
- Option: print before and after listings with `source-lines`. This needs no
  new tooling, but it is wordier and a reader has to spot the difference.

**Restructure.**

- Rename the files: 13 → 14 (cost), 14 → 15 (epilogue), and
  `snippets/chapter-13/` → `snippets/chapter-14/`, with its `read()` path
  updated. Do this in its own commit.
- Fix the cross-references that would break: chapter 11 L344 ("Chapter 13
  returns to the accounting") and chapter 12 L333 ("The final chapter asks").
- Update the opening of chapter 13 (now 14): the bill should cite what change
  cost in the new chapter, not only chapter 12.
- Update the epilogue's "Remembering is not knowing" section. The order
  system's defects are now fixed in the book, so the point becomes "it took a
  human decision to fix them".
- Add index entries for the new chapter (`backmatter/index.typ` is maintained
  by hand).

**Size.** About 4,000–5,000 words, plus 5–7 snippet projects.

## Workstream B: put the thesis first and stop conceding it piecemeal

*Addresses finding 2. Do this after A, so the prose can point to A's
evidence.*

- **Prologue (around L170–180).** It currently raises the objection and
  defers it to Part IV. Instead, state the answer in one paragraph: a
  framework's rules are held in place by the team's discipline, while a
  language removes the option. The rest of the book tests that claim. Part IV
  still settles it, but the reader then meets every "Could … do this? Yes"
  knowing what is at stake.
- **The eight "Could … do this?" sections**: "Could TypeScript do this?" in
  chapters 2, 3, 5, 6 and 8, plus "dependency injection" (chapter 4), "a
  framework" (chapter 7) and "existing tooling" (chapter 9). Keep them, because they
  are the book's credibility. Change two things:
  - Vary the headings, so the structure stops being predictable.
  - End each one with a single sentence naming *what holds the TypeScript
    version together* in that chapter's case. For example: a lint rule, a
    reviewer, or a branding convention that `as` can bypass. The concessions
    then build up a ledger of enforcement gaps rather than a list of things
    TypeScript can do too.
- **Chapter 11, "Why a language, and not a framework?"** Rewrite the "no
  configuration to loosen" passage to face Bynk's escape hatches directly:
  `.unsafe` exists only inside the owning commons, adapters sit at a declared
  and searchable boundary, and a wildcard `_` is visible in the match.
  Concede what is true: an `as` cast and an `eslint-disable` comment are also
  searchable. The difference to argue for is **where the escape hatch can
  appear and who owns it**, not that Bynk has none. Then point to workstream
  A's TypeScript comparison as the evidence.
- **Chapter 13 (cost)**: no structural change. Check that its "Know which
  problem you are buying" table still agrees with the sharpened thesis.

**Size.** About 1,000 words net, mostly rewriting.

## Workstream C: missing topics

*Addresses finding 3. Each item is independent and can be its own PR.*

### C1. Events: a fact is not a command (chapter 8)

Bynk has in-system pub/sub: a context declares an event, its owner emits it,
and subscribers are `from Events(E)` services. Chapter 8 covers HTTP, queues,
cron and WebSockets, but not this.

- Add a section to chapter 8 and a fifth row to its "Four boundaries" table,
  then retitle the table. Contrast a command (queue: "do this") with a fact
  (event: "this happened"), and who owns each.
- Close the idempotency gap that chapters 8 and 12 both name but leave open:
  `on event(e, env: EventEnvelope)` gives a stable `env.eventId`, and the
  `Idempotency` capability can deduplicate on it. **verify** the API names at
  the pin.
- Candidate refusal: `bynk.event.emit_outside_owner` (only the owning context
  emits), which makes an architectural point. **verify** the trigger and the
  message.
- Mind the prologue's webhook: the actors/verify-webhooks guide may also
  belong here, or in chapter 7.

About 1,500 words and one snippet project.

### C2. Evolution across deployments (new chapter A, step 5, plus chapter 5)

- Contract skew is covered in workstream A, step 5.
- Event schema evolution: the `bynk.schema.lock` registry, automatic version
  bumps for additive changes, field defaults for old wire events, and the
  refusal `bynk.event.non_additive_schema_change`. It fits either chapter 8
  (with C1) or the new chapter as a sixth step. **Decide** which. Note:
  `.gitignore` now ignores `bynk.schema.lock` under `snippets/`. A snippet
  that demonstrates the registry needs its lock committed, so add a
  `!snippets/<that project>/bynk.schema.lock` exception.
- Chapter 5's "State outlives the code that wrote it" stays as it is: state
  migration is still not a Bynk feature, and the chapter says so.

About 1,000 words.

### C3. Operations: seeing the system run (Part III)

The prologue lists investigating production failures as part of a language's
world, and Part III is the shortest part. Before writing, **research** what
0.313.0 actually offers:

- the `Logger` platform capability;
- source maps and debug metadata (chapter 11 touches on these);
- named runtime faults (`InvariantViolation`, `RehydrationViolation`,
  `ContractMismatch`);
- anything for tracing or metrics, on its own or through Cloudflare.

Then decide: if the support is substantial, write a new section in chapter 9
or a short chapter. If it is thin, write an honest section saying what the
model makes observable (every effect crosses a named seam, every fault names
its contract) and what it leaves to the platform. Do not overclaim.

About 1,500–2,000 words.

### C4. Adoption: where the first context goes (chapter 13, now 14)

Expand "The choice need not cover an organisation" into a section on adopting
Bynk step by step:

- one new context at an HTTP or queue boundary beside an existing TypeScript
  service;
- an adapter wrapping an existing library (from the wrap-a-library guide);
- the exit path: readable generated TypeScript, and what leaving would cost.

This is not a tutorial (the brief rules that out); it is the cost-and-risk
shape of a first step. About 1,200 words. A snippet is optional, for example a
TypeScript service calling a Bynk context over HTTP.

### C5. Prior work

`bibliography.bib` is empty and the book cites nothing. The secondary readers
(architects, language designers) will expect positioning.

- **Decide** the apparatus: footnotes plus a "Further reading" backmatter page
  (recommended, and it suits the narrative voice), or Typst `#cite` with a
  bibliography.
- Candidate anchors, one or two sentences each, at the point of use:
  - chapter 1: bounded contexts (domain-driven design);
  - chapter 2: newtypes and refinement types;
  - chapter 3: `Result` types in ML-family languages and Rust;
  - chapter 4: effect systems and object-capability security;
  - chapter 5: the actor model, and virtual actors (Orleans), which Bynk's
    agents closely resemble;
  - chapter 9: property-based and stateful testing (the QuickCheck family);
  - chapter 10: diagnostic design (Elm, Rust);
  - chapter 11: compile-to-JavaScript languages, and service-oriented
    languages such as Ballerina and Unison;
  - chapter 1: architecture tests such as ArchUnit, as the conventional
    alternative.
- **Every source must be checked by the author**; none of these is a
  citation yet.

About 1,500 words, plus a Further reading page.

## Expected size

| Workstream | Words added |
|---|---|
| A: changing a system | 4,000–5,000 |
| B: thesis and concessions | about 1,000 net |
| C1: events | about 1,500 |
| C2: evolution | about 1,000 |
| C3: operations | 1,500–2,000 |
| C4: adoption | about 1,200 |
| C5: prior work | about 1,500 |
| **Total** | **about 12,000–13,000**, bringing the book to roughly 43,000–44,000 |

That is just under the brief's lower bound. The brief says to "let the
completed argument determine the final length", so don't pad to reach 45,000.
If more is wanted, Part III (C3) is the place to grow.

## Order of work

1. **Decisions** (below). They gate A's structure and C5's apparatus.
2. **A1**: the diff tooling and its CI gate, plus the chapter file renaming.
   This is mechanical; keep it in its own PR.
3. **A2**: the new chapter, steps 1–4, with the TypeScript counterpart.
4. **A3**: step 5 (contract skew), plus C2's schema registry if it goes
   there.
5. **B**: the thesis and concessions rewrite, which now cites A.
6. **C1**, **C3**, **C4**: in any order, each its own PR.
7. **C5**: prior work, best done last, once every chapter's text is stable.
8. **Whole-book pass**: transitions, part recaps (chapter 3 L314, chapter 8
   L281, chapter 10 L308, chapter 13 L254), the epilogue, the index, and a
   full read in the PDF.

## Decisions for the author

1. **The new chapter**: a new chapter after chapter 12 (recommended), or a
   second half of chapter 12. A second half avoids renaming files, but makes
   chapter 12 about 6,000 words.
2. **Diffs on the page**: generated `.diff` files with a CI gate
   (recommended), or before and after listings.
3. **Schema evolution**: in chapter 8 with events, or in the new chapter as
   step 6.
4. **Operations**: a section or a chapter. Decide after the C3 research.
5. **Prior work**: footnotes plus Further reading (recommended), or a
   citation apparatus.
6. **Pin**: stay on 0.313.0 for the whole revision (recommended, for one
   consistent evidence base), or move to the latest release at step 2.
