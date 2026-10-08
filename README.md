# Architecture that compiles

The source of a narrative, print-first book about the problems Bynk is designed
to address and the choices it makes in addressing them.

It is deliberately separate from the [online Bynk
Book](https://bynk-lang.org/book/), whose source lives in `site/` in
[`accuser/bynk`](https://github.com/accuser/bynk):

- the online Book teaches and documents Bynk;
- this manuscript develops an argument about service design, with Bynk as its
  worked answer;
- documentation may inform the manuscript, but prose is not imported or shared
  mechanically between them.

That separation is why the manuscript lives in its own repository. It reads no
file outside this tree, and nothing in the compiler repository reads it; the one
real dependency runs the other way, in `snippets/` — see [Compiler
version](#compiler-version).

The title, subtitle, structure, trim, and component vocabulary are provisional
while the manuscript finds its shape.

## Source structure

- `main.typ` assembles the manuscript.
- `metadata.typ` holds working publication metadata.
- `template.typ` owns page design and semantic presentation rules.
- `frontmatter/`, `chapters/`, and `backmatter/` contain publishable text.
- `notes/` contains editorial planning and source maps, not manuscript prose.
- `snippets/` contains book-specific Bynk programs and fragments.
- `syntaxes/` contains the Bynk highlighting grammar the template loads for
  `.bynk` listings (a presentation aid scoped to what the book prints, mirroring
  the editor grammar and keyword registry; not a parser).
- `figures/` contains original book artwork.
- `fonts/` contains the fixed, licensed Source faces used for typesetting.
- `scripts/` contains the build wrapper, the snippet compile and formatting
  gates, and the CI-artifact fetch helper.
- `build/` is ignored local output.

Chapter files should describe meaning, not page geometry. New visual components
belong in `template.typ`; they should only be added when real manuscript content
demands them.

## Build

Build the manuscript from anywhere in the worktree:

```sh
./scripts/build-book.sh
```

The PDF is written to `output/pdf/bynk-manuscript.pdf`. For continuous preview
while writing:

```sh
./scripts/build-book.sh watch
```

The generated PDF and downloaded toolchain are not committed.

The build is pinned to **Typst 0.15.0**. If that exact version is already on
`PATH`, the script uses it. Otherwise, on macOS or Linux (arm64 or x86_64), it
downloads the official release, verifies its SHA-256 digest, and caches the
binary under `build/toolchain/`. Set `BYNK_TYPST_BIN` to use an exact Typst
0.15.0 executable on another platform.

Optional environment overrides:

- `BYNK_TYPST_BIN` selects an exact Typst 0.15.0 executable.
- `BYNK_BOOK_OUTPUT` changes the generated PDF path.
- `SOURCE_DATE_EPOCH` sets the PDF creation timestamp. When omitted in a Git
  checkout, the build derives a stable timestamp from `HEAD`.

CI runs the same command on every push and pull request. The resulting PDF is
uploaded to the workflow run as the `bynk-manuscript` artifact (14-day
retention). To download and open the newest CI-built PDF for your branch without
hunting through the Actions UI:

```sh
./scripts/fetch-book-pdf.sh          # newest build for the current branch (or main)
./scripts/fetch-book-pdf.sh --watch  # wait for an in-flight run to finish first
```

It needs the GitHub CLI (`gh auth login`). The PDF is not published to a
website, but it is not private either: while the repository is public, any
signed-in GitHub user can download a workflow run's artifacts until they expire.

## Compiler version

Working principle 7 — compile-test every listing presented as a complete
program — is enforced by:

```sh
./scripts/check-book-snippets.sh
```

It runs `bynkc check` over every project under `snippets/` and asserts each
one's expected outcome: a clean pass, the exact refusal the chapter quotes, or a
specific warning. A `build-fail` project is accepted by `check`, and the emit
gate below asserts that building it is refused with the listed code: some
refusals, such as a breaking change to a committed event schema, only a build
can see. Expectations for the projects that are not clean live in
`snippets/EXPECTATIONS.tsv`.

The chapters typeset those files verbatim, so their layout is printed layout. A
second gate holds them to canonical Bynk:

```sh
./scripts/check-book-format.sh
```

It runs `bynkc fmt --check` over every snippet project expected to compile,
skipping the deliberately-rejected ones. It writes nothing; it names each file
that is not already canonical, which `bynkc fmt <file>` then fixes.

Passing `bynkc check` does not prove a program builds. A third gate compiles
every project expected to pass, for both the `bundle` and `workers` targets, and
type-checks the emitted TypeScript with `tsc --strict`:

```sh
./scripts/check-book-emit.sh
```

It needs `tsc` on `PATH`, or `TSC=/path/to/tsc`; CI pins TypeScript 5.9.3. Builds
known to fail are listed, with the reason, in `snippets/EMIT-BASELINE`. Like the
formatting baseline below, it is a ratchet that can only shrink.

Canonical formatting is per project: each `bynk.toml` carries a `[fmt]` section
(`indent`, `max_line_width`, `trailing_comma`) that `bynkc fmt` reads for the
files inside that project. Reading `[fmt]` requires Bynk 0.243.0 or newer;
earlier releases silently format to their built-in defaults.

Two projects are not canonical yet and are listed in `snippets/FORMAT-BASELINE`,
which the gate reports without failing — both are hand-wrapped tighter than the
formatter's output, so reformatting would widen the printed listings. The
baseline is a ratchet: a project on it that has become canonical fails the gate
with a note to delete its line, so the list can only shrink.

Beware that several chapters print listings by slicing hard-coded line ranges out
of these files (`source-lines(path, start, end)`). Reformatting a snippet shifts
those line numbers, and a shifted range prints the wrong region while the build
still succeeds. Re-derive the affected ranges in the same change.

Both scripts use whichever `bynkc` is on `PATH`; override with
`BYNKC=/path/to/bynkc`. Install the toolchain from
[accuser/bynk releases](https://github.com/accuser/bynk/releases), or in CI with
[`bynk-lang/setup-bynk`](https://github.com/bynk-lang/setup-bynk).

Because the chapters quote **exact diagnostic codes**, the compiler version is
part of the book's evidence, not an incidental build detail. CI pins it in
`BYNK_VERSION` in `.github/workflows/snippets.yml`, and the manuscript is
written against that published release rather than an unreleased compiler.
The copyright page and preface print the same release from `bynk-version` in
`metadata.typ`; CI fails if the two disagree, so bump both together.

The book is enrolled in the org-wide
[Bynk canary](https://github.com/bynk-lang/.github/blob/main/canary/README.md):
on each Bynk release (and weekly), `.github/workflows/bynk-canary.yml` re-runs
both gates against that release. When they fail, the language has moved past
what a chapter claims: the canary opens a `canary` issue here (and comments on
it while the break lasts), and the chapter, or the pin, needs a deliberate
revision. The next passing run closes the issue.

### Source fonts

The manuscript uses Source Serif 4 Small Text for narrative text, Source Serif
4 Display for chapter and book titles, Source Serif 4 Caption for footnotes,
Source Sans 3 for section headings and book furniture, and Source Code Pro for
listings, inline code, and diagnostics. There is no alternate typography
setting.

The ten static OpenType faces used by the manuscript are vendored in `fonts/`.
The build ignores system fonts and verifies these files before compiling, so
local and CI line breaks do not depend on machine state. Their exact versions,
upstream archives, checksums, copyright notices, and SIL Open Font License 1.1
are recorded in that directory.

## Working principles

1. Begin with the engineering problem; introduce Bynk as a response.
2. Use code as evidence, not as a disguised reference manual.
3. Show compiler refusals where they reveal the language's design.
4. State costs and counterarguments alongside benefits.
5. Prefer one evolving system over disconnected feature demonstrations.
6. Keep exact syntax and exhaustive reference material in the online Book.
7. Compile-test every listing presented as a complete program.
8. Use sentence case for book, part, chapter, and section titles.

See `notes/brief.md` for the current editorial proposition,
`notes/source-map.md` for the boundary between research material and manuscript
prose, and `notes/typography.md` for the current typographic specification.

## Rights

The manuscript prose and original artwork are **not** open-source licensed — see
[`RIGHTS.md`](RIGHTS.md). The example programs under `snippets/` are dual MIT /
Apache-2.0, matching the Bynk repository; the two licence texts are included for
that purpose.
