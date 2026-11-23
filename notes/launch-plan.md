# Launch plan

This plan follows a full read of the manuscript in November 2026, against Bynk
0.639.1 and a fresh build (192 pages). It aims at one goal: a finished edition,
released alongside Bynk 1.0.0, that reads as a quality piece of work in its own
right. It changes no prose by itself; each workstream below becomes one or more
PRs. Everything is open to change, including the title.

## Progress (November 2026)

Decisions taken: keep the title, with the subtitle *Making service design part
of the program* (1); prose under CC BY 4.0 and code under MIT, as for the Bynk
documentation and blog (2); rewrite the chapter 13 handler (3); give the
framework argument its own chapter (4); add the three held-back books (5).
Decision 6: the edition policy in A4 is agreed, and is now in the README, preface and rights page.

| Item | State |
|---|---|
| D1: handler rewritten with `let … else` in chapters 12 and 13 (now 13 and 14) | Done |
| Decision 2: `LICENSE-CC-BY-4.0.md`, MIT for code, rights page and README | Done |
| E2 / decision 5: Evans, Hohpe & Woolf, Kleppmann footnotes and entries | Done (details still [memory]) |
| D2: new chapter 11, later chapters and snippet folders renumbered | Done |
| C1–C7, C9, C11; C8 normalised in the book | Done |
| A1 subtitle, A5 outline | Done |
| A4 edition policy; A2 rights page and preface wording | Done, as a pre-release edition |
| A2 final edition line, A3 release artefact | Waits for Bynk 1.0.0 |
| B accuracy review | Waits for Bynk 1.0.0 |
| C10 dashes: house style recorded in `notes/typography.md` | Done |
| D3: stock "TypeScript can do this" openers removed; the "What holds…" sentences kept as the thread chapter 11's table collects | Done |
| D4: formulaic "cannot decide" closers cut in chapters 3, 4, 5, 6 and 9 | Done |
| D5: chapter 10 tightened; it now returns to chapter 1's refusal explicitly and points to chapter 2 for admission | Done |
| D6: prologue's duplicate reading guide cut | Done |
| D7 chapter 9 operations section | Waits for B |
| E1, E3, F | Not started |

Two findings for Bynk itself, from C8: build-time and registry refusals
(`bynk.target.vendor_required`, `bynk.event.non_additive_schema_change`) print
in a different layout from `bynk check` refusals, with no severity and a
lower-case `note:`; and `bynk.given.unused_capability` gives its alternative
("use the capability in the body") as Note 1, before the suggested fix.

Chapter numbers below refer to the manuscript as it was reviewed, before the
new chapter 11 moved later chapters up by one.

## What the book has to do

The reader is an experienced TypeScript or backend developer who has not chosen
Bynk. The book succeeds if that reader finishes able to:

1. recognise where architectural knowledge disappears in ordinary service code;
2. take seriously the idea that some of it belongs in the language; and
3. judge, fairly and for their own system, whether Bynk is worth its cost.

Every recommendation below is measured against those three points. Most of the
book already meets them. The work is about the last stretch: removing anything
that makes a careful reader doubt the author's care, and sharpening the two or
three places where the argument is weaker than it should be.

## What to protect

These are the book's strengths. No change should weaken them.

- **One argument, running from first page to last.** "A convention is a decision
  the compiler has been asked not to remember" is set up in the prologue, tested
  at increasing scale in Parts I and II, and cashed out in Part IV and the
  epilogue.
- **Candour.** Chapter 6's "The guarantee is weaker here, and worth admitting",
  chapter 12's defects left standing, chapter 13's results table, and chapter 14
  ("This chapter is the bill") are what earn a sceptical reader's trust.
- **Evidence that compiles.** Every program and refusal is real and gated in CI.
- **The prose.** It is calm, precise and quotable. The pull quotes earn their
  place.
- **The design.** The typesetting, listings, diagnostics and tables are clean and
  consistent. The rendered PDF already looks like a finished book.

## Decisions for the author

These need an answer before the relevant workstream can finish.

1. **Title and subtitle.** See workstream A.
2. **Distribution terms.** The rights page says "unpublished working manuscript"
   and `RIGHTS.md` is "All rights reserved", marked provisional. A freely
   available artefact needs a stated licence (for example CC BY-NC-ND 4.0 for the
   prose, keeping MIT/Apache-2.0 for the snippets), or an explicit statement that
   it is free to read but not to redistribute.
3. **The chapter 13 handler.** Rewrite it with `let … else` (as chapter 8 already
   uses), or keep the eleven-level pyramid and say why. See D1.
4. **Where "Why a language, and not a framework?" lives.** See D2.
5. **The three held-back books** (Evans, Hohpe & Woolf, Kleppmann): add them or
   close the item.
6. **Edition policy after 1.0.** See A4.

## Workstreams

Priorities: **P1** must be done for launch; **P2** should be done for launch;
**P3** is worth doing if time allows.

### A. Launch identity (P1)

The book still describes itself as a draft in several places.

1. **Title.** *Architecture that compiles* is good: short, memorable, and it
   states the thesis. I recommend keeping it. The subtitle is the weaker part.
   "Why services become hard to reason about — and Bynk's answer" is long, puts
   the problem before the promise, and is the only place the book uses a spaced
   dash (the text uses unspaced em dashes). Options:
   - *Making service design part of the program* (the idea first, Bynk inside);
   - *Service design the compiler can see*;
   - *Bynk and the case for compiler-visible service design* (Bynk named, for
     discoverability at launch).

   Whichever is chosen, update `metadata.typ`, `notes/brief.md` and the README,
   and drop "provisional" from all three.
2. **Rights page and preface.**
   - Replace "Working manuscript" and "This is an unpublished working manuscript.
     The language and examples may change as Bynk approaches 1.0" with an edition
     line, such as "First edition, checked against Bynk 1.0.0".
   - Set `status` in `metadata.typ` to match.
   - Render "(c)" as "©".
   - Preface, "A note on versions": replace "Bynk is approaching 1.0 while this
     manuscript is being developed. The working edition therefore describes a
     moving implementation…" with wording for a released 1.0 edition. Keep the
     paragraph on version-sensitive and version-independent questions; it is
     good.
3. **Release artefact.**
   - Name the release PDF after the book (for example
     `architecture-that-compiles-1.0.pdf`) rather than `bynk-manuscript-v1.0.0.pdf`.
   - Set the PDF document metadata (title, author, language, subject).
   - Check that the output is tagged for accessibility, if Typst 0.15 supports it
     for this template.
   - Decide where the book is linked from (the Bynk website and the 1.0 release
     notes, at least).
4. **Edition policy.** State, in the README and briefly in the preface, how the
   book relates to later Bynk releases. For example:
   - The book is versioned by edition (1.0, 1.1, …).
   - Each edition names the Bynk release it was checked against.
   - The canary keeps running.
   - A new edition is released when a Bynk release changes something the text
     claims.

   This turns version drift from a weakness into a visible commitment.
5. **Housekeeping.**
   - `notes/outline.md` still lists 13 chapters and no chapter 13 on change.
   - `notes/revision-plan.md` says the index locators are chapter-level. The
     rendered index now has page numbers, and the descender problem is not
     visible in the current build, so confirm both and close those items.
   - `bibliography.bib` is empty: delete it, or adopt it (see E2).

### B. Accuracy at 1.0 (P1)

The snippet gates keep code and diagnostic codes honest. They do not check prose
claims about what Bynk does and does not do. Each of the following must be
re-verified against 1.0.0, then reworded or deleted:

| Location | Claim to verify |
|---|---|
| ch 5, "State outlives the code that wrote it" | No versioned state schema or migration path |
| ch 6, several | Invariant breach is a fault "callers cannot currently pattern-match"; compiler only warns (`bynk.transition.may_violate`) |
| ch 8, "A fact is not a command" | Shipped `Idempotency` provider is in-memory; events have no redelivery |
| ch 8, "One adapter per protocol" | "a durable log or a retry; at present it offers neither" |
| ch 9, "Realism should be a setting" | `unit` tier does not synthesise returns for unstubbed seams |
| ch 9, "Generate histories…" | Histories cover one agent only |
| ch 9, "After the tests pass" | **"At 0.377.2, a failure surfaces like this"**: a hard-coded, stale version (the pin is 0.639.1). Use `book-meta.bynk-version` or drop the version. Re-check every row of the table and the observability paragraph (two log levels, no tracing, no metrics, no correlation IDs, no deployed source maps). |
| ch 11, "How much survives without Cloudflare" | No second production runtime; bundle target behaviour |
| ch 13, "Shipping one context at a time" | Deploy-time skew check is one-directional; `ContractMismatch` is thrown, not returned |
| ch 14, "One context at a time" and "The way back out" | Fingerprint behaviour for hand-written callers; generated tree has no package dependencies |

Add a short checklist to the release process (README or this file) so this
review is repeated for each edition.

### C. Errors and inconsistencies (P1)

Concrete defects found in the read. Each is small; together they are what make a
careful reader wonder what else was missed.

1. **ch 12, "Open the owners"**: "The compiler also prevents either count from
   committing below zero." It does not: that is the runtime invariant check
   chapter 6 is careful to distinguish. Reword as "the invariant refuses any
   commit that would take either count below zero".
2. **ch 13, "An event outlives the shape…"**: a sentence starts in lower case:
   "updating the emitter to match. every emitter and subscriber…".
3. **ch 8, opening**: says implementation languages give "all five boundaries"
   the same callback shape, but the conventional listing and its caption show
   four ("One callback type makes four entry mechanisms look interchangeable").
   This is left over from adding events. Either add an event bus to the listing
   or reword the opening.
4. **ch 8, "A fact is not a command"**: the point that a refused send is logged
   and never retried is made twice in neighbouring paragraphs ("When the mailer
   reports a failure…" and "That matches the point made earlier…"). Cut the
   second, and tighten the idempotency paragraph around it.
5. **ch 2**: "commons" is used four times ("the commons that owns them") before
   the book ever says what a commons is. Define it at first use in one sentence.
6. **ch 13 vs ch 14**: chapter 13 makes six changes. Chapter 14's "The
   accounting" says "Of four realistic changes", mentions the deployment, and
   leaves out the event schema change entirely. Bring the summary into line with
   chapter 13's table.
7. **ch 13 introduction**: "This chapter makes four changes…, ships one of them…,
   and then changes the shape of the event", followed by a list numbered 1–6.
   Reconcile how the changes are counted.
8. **Diagnostic rendering is inconsistent.** Most refusals print as `[code]
   Error:` with `Note:`. These do not:
   - ch 11 `bynk.target.vendor_required`: no severity, lower-case `note:`;
   - ch 13 `bynk.event.non_additive_schema_change`: no severity, lower-case
     `note:`;
   - ch 13 deploy skew: a different `bynk: … (code)` layout.

   If these are verbatim compiler output, the inconsistency is in Bynk and
   worth fixing upstream before 1.0. If not, normalise them in the book. Do the
   same for ch 10's `Note 1: alternatively… / Note 2: help: remove…`, which
   reads oddly and gives the alternative before the main suggestion.
9. **Stacked openers.** ch 7's "Security in the framework" opens "A framework can
   do this. A well-designed web framework can…"; ch 8's last section opens
   "TypeScript can do this. Mature TypeScript systems…". Both read as
   template text. They are addressed by D3, or can be fixed on their own.
10. **Dashes.** The subtitle uses a spaced en/em dash; the text uses unspaced em
   dashes (`---`). Pick one house style and record it in `notes/typography.md`.
11. **Further reading, last entry**: `- Unison. https://www.unison-lang.org/ ---`
   ends with a stray `---`, which prints as a dangling em dash on the book's final
   reading entry.

### D. Argument and structure (P2)

These are the changes that most affect whether the book does its job.

#### D1. The chapter 13 handler (decision 3)

The handler that closes "A new edge has to be declared" is eleven levels of
indentation deep, and the text presents that depth as the cost of explicitness.
Chapter 14 then cites it ("The handler grew deeper"). It is the most visible
exhibit of cost in the book.

But Bynk has `let Pattern <- expr else { … }`, and chapter 8's subscriber uses
it. If the chapter 13 handler can be written flatter in idiomatic 1.0 Bynk, with
`let … else` or small helper functions per step, then the book is overstating
its own language's cost and showing readers code they should not write. If it
cannot (for example because `else` cannot see the `Err` payload needed to map
each failure), the text should say so in one sentence, so the reader does not
think of the obvious objection first.

Steps:
1. Try the rewrite against 1.0.
2. If it flattens: print the flat version, keep an honest sentence about volume,
   and adjust chapter 14's "Explicitness has volume" to match.
3. If it does not: keep the pyramid, add the sentence, and consider raising a
   language issue before 1.0.

#### D2. Give the central argument its own place (decision 4)

"Why a language, and not a framework?" is the hinge of the whole book. The
prologue promises it, chapter 13 tests it, chapter 14 prices it. Yet it sits as
the last section of chapter 11, a chapter mostly about lowering to TypeScript,
deployment topology and portability. A reader skimming the contents cannot find
it, and its weight is diluted by the material around it.

Options, in order of preference:
1. **Make it a short chapter that opens Part IV** (roughly 1,200–1,500 words,
   mostly the existing section plus the ledger from D3). Part IV then reads:
   - why a language;
   - what it runs on (the rest of chapter 11);
   - reading a system;
   - changing it;
   - what it costs.
2. **Move it to open chapter 11**, retitling the chapter to cover both halves.
3. **Leave it** and add a contents-visible signpost (for example a sentence in
   the Part IV page or the preface).

Option 1 renumbers chapters 11–14. The source labels (`ix-11-…`) and the
cross-references ("Chapter 11 argued…" in chapter 13, "Chapter 13 tests this" in
chapter 11) need updating in the same change.

#### D3. Turn the repeated concession into a device

Chapters 2–9 each end with a section that concedes TypeScript can do the same
thing, then names "What holds the TypeScript version together". The repetition
is deliberate: chapter 11 totals the ledger. But read straight through, it feels
like a template, and the section openers (C9) show it.

Recommendation: keep the ledger, make it explicitly structural, and make it
short.
- Give each chapter's comparison section a consistent, brief form. For example,
  a closing aside titled "The ledger" with two short parts: *TypeScript can…* and
  *What holds it together…*. It could be set with a small template component, as
  the diagnostics are.
- Keep the discussion of costs and alternatives that currently surrounds each
  one, but in the body of the section, not as boilerplate.
- In the D2 chapter, print the full ledger as one table, so the reader sees the
  pattern was deliberate.

This turns a stylistic tic into an argument the reader can follow.

#### D4. Thin out the closing disclaimer

Nearly every chapter ends with a form of "the compiler preserves what you
declare; it cannot supply the judgement". The candour is right; the frequency is
not. After chapter 3 the reader has it, and by chapter 10 it starts to read as
reflex. Keep it where it adds something specific (ch 6, ch 12, ch 14, the
epilogue), and cut or vary it elsewhere, especially:
- ch 2, "What the model still cannot know";
- ch 4, "What the list does not promise";
- ch 9, closing;
- ch 10, "The compiler must know when it does not know".

#### D5. Strengthen chapter 10

Chapter 10 is the weakest chapter.
- Its first worked example is chapter 1's `unconsumed_context` refusal again,
  which chapter 13 also reuses.
- Parts of it are about how the Bynk project manages diagnostics (the code
  registry, negative fixtures), which matters to language designers but not
  much to the primary reader.
- It closes with "the compiler cannot decide" again.

Suggested changes:
- Open with a refusal the reader has not met yet.
- Keep the cycle example (it is the chapter's best moment: a quick fix that
  reveals a design decision).
- Keep the error/warning/runtime table.
- Compress the tooling and registry material into a paragraph.
- Target 1,500–1,700 words.

#### D6. Trim the double introduction

The preface ("What this book is for", "The print book and the online Book") and
the end of the prologue both lay out the route and both say the book is not a
language reference. Cut the prologue's "It is not a language reference…"
paragraph and the one after it. The prologue should end on the four boxes, not
on a reading guide.

#### D7. Chapter 9's operations section

"After the tests pass" is honest and useful, but it is mostly a list of present
absences (tracing, metrics, correlation IDs, deployed source maps). After B is
done:
- keep the table of what the model names;
- reduce the list of absences to what remains true at 1.0; and
- consider moving the residual "you still need your own observability" point to
  chapter 14, where costs are counted.

### E. Apparatus (P2)

1. **Index.** It has about 69 headwords and works, but it is light for a book of
   this length. Add the terms a reader will look up, including:
   - commons, `.unsafe`, zero values / zeroability;
   - Service Bindings, fingerprints, schema lock;
   - `Effect`, `Result`, `Option`, `match` and exhaustiveness;
   - `let … else`, adapters, providers.

   Check every locator after the D-workstream moves.
2. **Footnotes and further reading.**
   - Footnotes cite informally and inconsistently: Lehman has a year, Perry and
     Wolf do not, Orleans has "et al.". Since full details are in Further
     reading, adopt one short-form rule (author and title only, no year) and
     apply it everywhere.
   - Re-check the web addresses ("checked in October 2026") at launch.
   - Resolve the held-back books (decision 5).
3. **Part pages.** The part pages carry only a number and title. Consider one
   sentence under each title saying what the part asks. The `notes/outline.md`
   descriptions are a good start.

### F. Final pass (P1, last)

1. **A full proofread** of the PDF after all other changes, not of the source:
   - typos;
   - British spelling ("catalog" appears in prose in ch 11 because it is the
     context's name; set it as code or say "catalogue context");
   - sentence case;
   - consistent capitalisation of "Book" for the online Book.
2. **A layout pass** on the PDF:
   - widows and orphans;
   - listings split across pages (especially the `breakable: true` listings in
     ch 8 and ch 13);
   - table widths;
   - blank versos before part pages;
   - running heads.
3. **A cold read** by someone who matches the reader in the brief and has not
   seen Bynk. Ask them only: where did you stop trusting it, and where did you
   get lost?

## Sequencing

| Order | Work | Size | Depends on |
|---|---|---|---|
| 1 | C1–C7, C9–C11, A5 (defects and housekeeping) | small | — |
| 2 | D1 rewrite trial against current Bynk | small | — |
| 3 | B (accuracy review), once 1.0.0 or a release candidate exists | medium | Bynk 1.0 |
| 4 | D2 and D3 together (structure and ledger) | large | decision 4 |
| 5 | D4–D7 (prose tightening) | medium | 4 |
| 6 | C8 diagnostics, upstream issues if needed | small | 3 |
| 7 | E (index, citations, part pages) | medium | 4, 5 |
| 8 | A1–A4 (title, edition, rights, release artefact) | small | decisions 1, 2, 6 |
| 9 | F (proofread, layout, cold read) | medium | everything |

Items 1 and 2 can start now. Item 3 waits for 1.0.0 but is the gate for launch.
Item 4 is the largest change to the text and should land well before the final
pass, so the index and cross-references are rebuilt once.

## Expected size

The book is about 40,700 words. D5, D6 and D4 remove roughly 1,500–2,000; D2
and D3 add roughly 500–1,000. The finished edition should land at about 39,000–
40,000 words and 185–195 pages. That is below the brief's 45,000, and it should
stay there: the argument is complete, and a tight book serves this reader
better than a padded one.
