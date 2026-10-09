# Typography

The Source family and open paragraph treatment are settled as the manuscript's
typographic direction. Detailed production choices remain provisional.

## Source family

- Source Serif 4 Small Text at 10.1 pt for body copy.
- Source Serif 4 Display for book and chapter titles.
- Source Serif 4 Caption for footnotes.
- Source Sans 3 for section headings, labels, captions, and front-matter
  furniture.
- Source Code Pro at 8.2 pt for listings, inline code, and diagnostics.

Paragraphs use no first-line indent, 1.5 em of paragraph spacing, and 0.80 em
of leading. This gives the manuscript a contemporary technical-book rhythm and
clear separation between narrative and structural material. With no indent,
the paragraph space is the only signal of a new paragraph. 1.5 em adds about
half a line (7.1 pt over the 14.8 pt line pitch), so a one-line paragraph still
reads as its own paragraph. The template had drifted to 1.05 em, which added
only 2.6 pt; restored and widened in October 2026.

Inline code is set at 0.9 of the surrounding text (9.1 pt in body copy), close
to the serif's x-height. Typst's raw default of 0.8 em had compounded with an
earlier 0.9 em rule, leaving inline code at 0.72. Inside a compiler message,
which is already in the code font, inline code matches the message.

The build uses a vendored, checksum-verified subset of static OpenType files:
Source Serif 4.005, Source Sans 3.052, and Source Code Pro 2.042. Typst is
pinned to 0.15.0 and system fonts are ignored. This makes line and page breaks
consistent between local and CI builds.

## Pagination

The pagination rules are kept in the template, not page by page, so they
survive edits:

- **Lead-ins stick.** A paragraph that introduces a listing, a compiler
  message, a figure, or a list (one ending in a colon) is wrapped in
  `#lead-in[...]`, a sticky block, so it is never stranded at the foot of a
  page.
- **Listings break only between declarations.** A listing of up to 10 lines
  stays whole. A longer one may break across pages, but only at a blank line,
  never inside a declaration. It is set as parts, one per declaration, in one
  shaded box, and a part shorter than three lines joins its neighbour. The
  caption row stays with the first part. The gap between parts is calibrated
  to an ordinary blank line: 24.0 pt across it, as before, and 11.9–12.0 pt
  line pitch is unchanged. A single declaration over 20 lines may break
  between lines, and `breakable: true` lets any listing break anywhere.
- **Widows and orphans** cost six times Typst's default (`text.costs`). A
  widow or orphan that persists is usually footnote-driven: a line carrying a
  long footnote moves to wherever the footnote fits. Move the footnote's
  anchor to an adjacent sentence that makes the same point (footnotes 6a, 7a
  and 13a in `notes/prior-work.md`).

October 2026, measured from the PDF:

- **Before the pass:** 46 problems.
- **After the first pass:** six gaps of 25–47% of a page, where a heading, a
  lead-in, and a whole listing moved together.
- **After the second pass:** the large gaps are gone. Four moderate ones
  (25–30%) remain, each before a new section whose heading, lead-in and first
  declaration cannot fit in the space left. Ending the page short there is
  ordinary practice. No widows or orphans remain. The ends of Parts II and III,
  before a part opener, are not gaps.

## Before production

- Revisit optical margin alignment and widow/orphan policy during copy-editing.
- Reassess the pinned font and Typst versions only as a deliberate pagination
  change, followed by a complete visual proof.

## Publication-apparatus proof

The current proof establishes a provisional page-furniture system:

- running heads use Source Sans 3 at 7.7 pt, with the book title on versos and
  the current chapter or matter title on rectos;
- a fine rule separates running heads from the text block;
- Arabic and Roman folios sit at the outside edge of the footer;
- opening, part-title, and intentionally blank pages suppress both running
  heads and visible folios while remaining part of the page count;
- the contents uses chapter-level entries only, with part entries acting as
  visual groups and subordinate chapter entries inset;
- the subject-index proof uses Source Serif 4 Small Text at 8.55 pt in two
  columns with Source Sans 3 alphabet headings. Entries are spaced 0.6 em
  apart, with 0.6 em leading inside an entry that wraps. That is about 1.27
  baseline to baseline (10.9 pt), enough for descenders to clear. The columns
  flow without manual breaks, because a hand-placed break stops fitting as
  soon as entries change.

These are proof decisions rather than settled production specifications. They
should be judged again after the contents, preface, and editorial index have
their final extent.
