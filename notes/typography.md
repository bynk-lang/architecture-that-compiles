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
- **Short listings stay whole; long ones break.** A listing of 16 lines or
  fewer stays on one page. A longer one may break across pages, with its
  caption row kept on the first. Kept whole, a long listing left a hole at
  the foot of the previous page and pulled its lead-in after it.
  `breakable: true` forces a break regardless of length.
- **Widows and orphans** cost six times Typst's default (`text.costs`).

October 2026 pass, measured from the PDF: before it, 46 pages had a stranded
lead-in, a large gap mid-chapter, or a lone line. After it, six remain, all
gaps. Each is where a lead-in and a short listing that is kept whole cannot
fit in the space left, so they move together. That reads better than
splitting a 15-line function. One of the six is the end of Part III.

There is now no widow and no orphan. Both of the last two were footnote-driven:
a line that carries a long footnote moves to wherever the footnote fits. They
were fixed by moving each footnote's anchor to an adjacent sentence making the
same point (footnotes 6a and 7a in `notes/prior-work.md`). This is the first
thing to try if one reappears.

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
