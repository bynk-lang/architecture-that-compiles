# Prior work: draft citations (C5)

Status: **implemented, except three held-back books** (October 2026). The
author reviewed this list (PR #25), and decided:

- **Optional footnotes** (3b Wlaschin, 6b Harel, 11a Ballerina and Unison):
  Further reading only.
- **Lehman (14b):** cited in the prologue, at "Each change was reviewed,
  tested, and deployed.", not on chapter 14's pull quote.
- **Held back until confirmed against a copy:** Evans (1a), Hohpe & Woolf
  (8a), and Kleppmann (13b). Their footnotes are not in the manuscript, and
  their entries are not in Further reading. To add one, insert its footnote
  at the anchor below and its entry in `backmatter/further-reading.typ`, then
  change its marker to [author].

So the manuscript has 20 footnotes from this list, and
`backmatter/further-reading.typ` has 37 entries.

**Anchors as implemented.** A footnote attaches to a prose sentence, so a
footnote whose proposed anchor was a pull quote, or a sentence ending in a
colon, moved to the nearest sentence making the same point:

| Footnote | Attached after |
|---|---|
| P1 | prologue, "It had become implicit." |
| 14b (Lehman) | prologue, "Each change was reviewed, tested, and deployed." |
| 1b | ch. 1, "…can be checked by a linter." |
| 2a | ch. 2, "It establishes a trust boundary." |
| 2b | ch. 2, "A refined type restricts the values of a base type with a predicate." |
| 3a | ch. 3, "…faults for which the program has no meaningful continuation." |
| 4a, 4b | ch. 4, as proposed |
| 4c | ch. 4, "These are established techniques, not approximations of serious design." |
| 5a, 5b | ch. 5, as proposed |
| 6a | ch. 6, "The union can make the invalid snapshot unrepresentable." |
| 7a | ch. 7, "…another owner's basket by changing the path." |
| 7b | ch. 7, "…without trusting a caller-supplied story about itself." |
| 8b | ch. 8, as proposed |
| 9a | ch. 9, "Generated histories search reachable behaviour because the handlers construct every step." |
| 9b | ch. 9, "The production design decides where substitution is legal." |
| 10a | ch. 10, "A useful diagnostic can turn those facts into design feedback…" |
| 13a | ch. 13, "A contract change is a coordinated deploy." |
| 14a | ch. 14, as proposed |

The proposals below are kept as the record of what was reviewed. Each source must be confirmed by the author before it is cited (revision
plan, decision 5).

## How the sources were checked

On 9 October 2026, every entry was compared against an authoritative source.
The marker after each citation records how:

- **[doi]**: matched against the Crossref record for the DOI, or the
  publisher's or proceedings' own page.
- **[site]**: checked against the author's or project's own page, which loaded.
- **[memory]**: a book whose details come from general knowledge, not a
  publisher page fetched that day. Check the publisher's record or the copy
  you own.
- **[author]**: confirmed by the author against their own copy or check.

A second pass on 9 October 2026 rechecked every DOI against Crossref, every
URL, and each page's date, and read section 2 of the Orleans report.

"Fits" says what the source supports in the book, and any qualification found
while checking.

## Apparatus

Decision 5: footnotes at the point of use, plus a "Further reading" page in
the backmatter.

- **Footnotes** are short, in the book's voice. They name the idea and its
  source, author and title, and do not argue. The manuscript already uses
  `#footnote[...]` (chapter 1), so no template work is needed.
- **Further reading** gives full citations grouped by part, including works
  too general to footnote at one sentence.
- Proposed scale: **26 footnotes** (23 without the optional 3b, 6b, and 11a),
  one to three per chapter, and 40 entries in Further reading. A footnote is proposed only where a reader
  would reasonably ask "where does this idea come from?"

Line numbers refer to `main` at commit `9aff348`.

---

## Footnote proposals

### Prologue

**P1.** `00-prologue.typ:49`, "The architecture had not disappeared. It had
become implicit."

> Software architecture research has long had words for this: architectural
> *drift* and *erosion*, the gap that opens between an intended architecture
> and the one a system actually has (Perry and Wolf, "Foundations for the Study
> of Software Architecture").

Source: Perry & Wolf 1992 **[doi]**. Fits: the paper introduces both terms.

### Chapter 1: When architecture becomes convention

**1a.** `01-…typ:168`, "Bynk makes the deployable boundary a language construct
called a _context_."

> The name echoes domain-driven design's *bounded context*: a boundary within
> which a model's terms keep one meaning (Evans, *Domain-Driven Design*).
> Bynk's context is narrower and more mechanical. It is a deployable unit with
> declared dependencies, not a whole modelling discipline.

Source: Evans 2003 **[memory]**. Fits: bounded contexts are a core pattern.
The qualification matters; Bynk's use is not Evans's. Cite the year as 2003;
library catalogues give the imprint as c2004, as with Hohpe and Woolf.

**1b.** `01-…typ:93`, "A boundary represented by a directory can be seen by a
person."

> Architecture tests are the strongest form of this convention: rules about
> which packages may depend on which, run as unit tests. ArchUnit is the
> best-known example, for Java.

Source: ArchUnit **[site]**. Fits: rules checked as tests. This supports
chapter 11's ledger as well: the rule is real, but it lives beside the
language.

### Chapter 2: A data shape is not a domain model

**2a.** `02-…typ:78`, the pull quote "Validation is an event. A validated type
lets the result of that event travel with the value."

> The same idea is put memorably in Alexis King's essay "Parse, don't
> validate": a check should return a more precise type rather than a yes or no.

Source: King 2019 **[site]**.

**2b.** `02-…typ:326`, "This separation helps prevent a common muddle."
(Refined types.)

> Refinement types (a base type restricted by a predicate) go back to Freeman
> and Pfenning's "Refinement Types for ML". LiquidHaskell is a practical
> descendant that checks such predicates statically.

Sources: Freeman & Pfenning 1991 **[doi]**; Vazou et al. 2014 **[doi]**. Fits.
Note that Bynk checks literals statically and everything else at admission,
so it is closer to "parse, don't validate" than to LiquidHaskell's static
verification. Keep the footnote's claim about lineage, not equivalence.

### Chapter 3: Failure is part of the contract

**3a.** `03-…typ:350`, "The distinction is between _expected operational
outcomes_ and faults for which the program has no meaningful continuation."

> Joe Duffy's account of the error model in Microsoft's Midori project draws
> the same line, between recoverable errors and bugs, which Midori handled by
> abandoning the process ("The Error Model").

Source: Duffy 2016 **[site]**. Fits: the post has a section "Bugs Aren't
Recoverable Errors!".

**3b.** `03-…typ:331`, "Several mature libraries provide exactly these tools."

> Scott Wlaschin's "Railway Oriented Programming" is a widely read
> explanation of composing `Result`-returning functions.

Source: Wlaschin 2013 **[site]**. Optional; this could go to Further reading
only.

### Chapter 4: Effects should name their requirements

**4a.** `04-…typ:82`, "Bynk distinguishes pure computation from work that
participates in effects."

> Typing effects is an old idea in programming languages, going back at least
> to Lucassen and Gifford's "Polymorphic Effect Systems". Effect *handlers*,
> which separate an effect's interface from its implementation much as
> capabilities and providers do here, come from Plotkin and Pretnar.

Sources: Lucassen & Gifford 1988 **[doi]**; Plotkin & Pretnar 2009 **[doi]**.
Fits. The checker flagged that Plotkin and Pretnar introduce *handlers*;
algebraic effects themselves are earlier work by Plotkin and Power. The
wording above says "effect handlers" for that reason.

**4b.** `04-…typ:120`, "A capability is a contract for a related set of
effectful operations."

> The word comes from object-capability security, where holding a reference
> is what grants authority (Mark S. Miller, *Robust Composition*). Bynk's
> capabilities borrow the vocabulary and the instinct, that authority should
> be explicit and narrow, but they are checked by a compiler, not enforced as
> references at runtime.

Source: Miller 2006 **[site]**. The qualification is essential: Bynk's
`given` is a static declaration, not a runtime object capability.

**4c.** `04-…typ:278`, the dependency-injection comparison.

> Martin Fowler's "Inversion of Control Containers and the Dependency
> Injection pattern" named the technique.

Source: Fowler 2004 **[site]**. Fits: the article coined the term.

### Chapter 5: State needs an owner

**5a.** `05-…typ:74`, "Bynk calls its state-owning unit an _agent_."

> Keyed owners of state descend from the actor model (Hewitt, Bishop, and
> Steiger, 1973). The closest relatives are *virtual actors*, which always
> exist logically and are never explicitly created; the runtime activates one
> when a request arrives (Bernstein et al., "Orleans"). Another is the platform
> primitive Bynk compiles to, Cloudflare's Durable Objects.

Sources: Hewitt et al. 1973 **[site]**; Bernstein et al. 2014 **[site]**;
Durable Objects docs **[site]**. Fits: section 2 of the report says an actor
"cannot be explicitly created or destroyed", and that "when a new request is
sent to an actor that is currently not instantiated", the runtime creates an
*activation*. The actor does not come into being when addressed; only its
in-memory instance does, which is why the wording says "activates".

**5b.** `05-…typ:247`, "Cross-owner consistency needs a protocol such as
idempotent operations, compensation, or a saga."

> Pat Helland's "Life beyond Distributed Transactions" argues that scalable
> systems keep atomicity inside one entity and coordinate between entities
> with messages, which is the bargain this chapter describes. *Sagas*
> (Garcia-Molina and Salem) named the compensating approach.

Sources: Helland 2007 **[site]**; Garcia-Molina & Salem 1987 **[doi]**.
Fits closely. Helland 2007 is also relevant to chapters 12 and 13. Footnote it
once, here, and list it in Further reading.

### Chapter 6: State changes are contracts

**6a.** `06-…typ:61`, the pull quote "A valid state does not imply a valid
transition."

> "Make illegal states unrepresentable" is Yaron Minsky's phrase for the
> stronger tool this chapter recommends where it applies ("Effective ML
> Revisited"). Invariants checked on every commit are closer to Bertrand
> Meyer's class invariants in design by contract.

Sources: Minsky 2011 **[site]**; Meyer 1992 **[doi]**. Fits. Cite Minsky's
2011 blog post as the written source; the idea comes from his 2010 Harvard
talk.

**6b.** `06-…typ:64`, "Calling a record with a status field a state machine is
therefore premature."

> Harel's statecharts are the classic formalism for state machines as a
> design notation.

Source: Harel 1987 **[doi]**. Optional. Statecharts are hierarchical and
richer than what Bynk declares, so put this in Further reading unless the
author wants the contrast.

### Chapter 7: Who is calling is part of the operation

**7a.** `07-…typ:57`, "There are three distinct decisions here:"

> The object-level case is common enough in practice to lead OWASP's API
> Security Top 10: "Broken Object Level Authorization" (API1:2023).

Source: OWASP API Security Top 10, 2023 **[site]**. Fits exactly the
TypeScript example's bug.

**7b.** `07-…typ:196`, "Identity crosses internal boundaries too".

> The classic statement of the internal-caller problem is Norm Hardy's "The
> Confused Deputy": a program acting with authority it holds for one caller on
> behalf of another.

Source: Hardy 1988 **[doi]**. Fits.

### Chapter 8: Time and messages are architectural boundaries

**8a.** `08-…typ:223`, "A fact is not a command".

> Hohpe and Woolf's *Enterprise Integration Patterns* distinguishes command
> messages from event messages, and names the idempotent receiver and the
> dead-letter channel this chapter relies on.

Source: Hohpe & Woolf 2003 **[memory]**. Fits: all four are named patterns.
Cite the year as 2003; the release was October 2003, with a 2004 copyright.

**8b.** `08-…typ:103`, "The message needs a stable identity, and the owner of
the effect may need to remember that identity…"

> Pat Helland's "Idempotence Is Not a Medical Condition" explains why
> at-least-once delivery makes this unavoidable.

Source: Helland 2012 **[doi]** (ACM Queue 10(4); reprinted in CACM 55(5)).

### Chapter 9: Tests should preserve the architecture

**9a.** `09-…typ:213`, "Generate histories by driving the owner".

> Property-based testing began with QuickCheck (Claessen and Hughes, 2000).
> Driving a stateful system with generated sequences of calls is its
> "stateful" or model-based form, described in Hughes's "Experiences with
> QuickCheck". In TypeScript, fast-check provides both.

Sources: Claessen & Hughes 2000 **[doi]**; Hughes 2016 **[doi]**; fast-check
**[site]**.

**9b.** The stub-at-a-seam rule (the section "The seam a test can't invent").

> Freeman and Pryce's advice to "only mock types you own" is the conventional
> discipline this rule turns into a check.

Source: Freeman & Pryce 2009 **[author]**. Fits: "Only Mock Types That You
Own" is a section in chapter 8, page 69.

### Chapter 10: A compiler refusal can teach the design

**10a.** `10-…typ:26`, the pull quote "A refusal teaches only when it makes the
invisible rule visible."

> Elm's "Compiler Errors for Humans" made the case for error messages as user
> experience. A survey of the research is Becker et al., "Compiler Error
> Messages Considered Unhelpful".

Sources: Czaplicki 2015 **[author]** (the page does not render without
JavaScript; the author confirmed the date, 30 June 2015); Becker et al. 2019 **[doi]**.

### Chapter 11: A new language should not require a new universe

**11a.** `11-…typ:45`, "Compiling to an established target changes that
equation."

> Other languages make similar bargains about services: Ballerina is designed
> around network integration, and Unison rethinks how code is stored and
> distributed.

Sources: Ballerina **[site]**, Unison **[site]**. Optional; probably Further
reading only. The book should not characterise other languages beyond what
it can support.

### Chapter 13: Changing a system that compiles

**13a.** `13-…typ:313`, the contract fingerprint in step 5.

> Service contracts that evolve independently are usually managed with
> consumer-driven contracts (Ian Robinson). Bynk's fingerprint detects skew
> instead of negotiating it.

Source: Robinson 2006 **[site]**. Fits as contrast.

**13b.** `13-…typ:368`, "An event outlives the shape it was sent in".

> Backward and forward compatibility in message encodings is treated in depth
> in chapter 4 of Martin Kleppmann's *Designing Data-Intensive Applications*.

Source: Kleppmann 2017 **[memory]**. Say "first edition": there is now a
second edition, by Kleppmann and Riccomini.

### Chapter 14: The cost of stronger constraints

**14a.** `14-…typ:257`, "A team does not have to rewrite a service to find out
whether Bynk fits it."

> Martin Fowler's "Strangler Fig" describes this pattern of replacing a system
> one piece at a time.

Source: Fowler 2024 **[site]**. The live page is a 2024 rewrite of an
original dated 29 June 2004 and first called "Strangler Application". The
live page does not give that date; the original is archived as
"Original Strangler Fig Application". Cite as "Strangler Fig" (2024,
originally 2004).

**14b.** `14-…typ:23`, the pull quote "Every guarantee has a shadow price…"

> Lehman's laws of software evolution, that a used system must keep changing
> and grows more complex unless work is done to prevent it, are the pressure
> behind this whole book.

Source: Lehman 1980 **[doi]**. This could move to the prologue or the epilogue
instead; the author should choose. Brooks's "No Silver Bullet" is a candidate
for the epilogue's close, on essence and accident, but only as Further
reading unless a sentence calls for it.

---

## Further reading (full entries)

### Architecture and its erosion
- Dewayne E. Perry and Alexander L. Wolf. "Foundations for the Study of
  Software Architecture." *ACM SIGSOFT Software Engineering Notes* 17(4):40–52,
  1992. doi:10.1145/141874.141884 **[doi]**
- D. L. Parnas. "On the Criteria to Be Used in Decomposing Systems into
  Modules." *Communications of the ACM* 15(12):1053–1058, 1972.
  doi:10.1145/361598.361623 **[doi]**
- M. M. Lehman. "Programs, Life Cycles, and Laws of Software Evolution."
  *Proceedings of the IEEE* 68(9):1060–1076, 1980.
  doi:10.1109/PROC.1980.11805 **[doi]**
- Frederick P. Brooks, Jr. "No Silver Bullet: Essence and Accidents of
  Software Engineering." *Computer* 20(4):10–19, 1987.
  doi:10.1109/MC.1987.1663532 **[doi]**
- Eric Evans. *Domain-Driven Design: Tackling Complexity in the Heart of
  Software.* Addison-Wesley, 2003. ISBN 0-321-12521-5 **[memory]**
- ArchUnit. https://www.archunit.org/ **[site]**

### Types, admission, and failure
- Alexis King. "Parse, don't validate." 5 November 2019.
  https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/ **[site]**
- Tim Freeman and Frank Pfenning. "Refinement Types for ML." PLDI '91,
  268–277, 1991. doi:10.1145/113445.113468 **[doi]**
- Niki Vazou, Eric L. Seidel, Ranjit Jhala, Dimitrios Vytiniotis, and Simon
  Peyton Jones. "Refinement Types for Haskell." ICFP 2014, 269–282.
  doi:10.1145/2628136.2628161 **[doi]**
- Joe Duffy. "The Error Model." 7 February 2016.
  https://joeduffyblog.com/2016/02/07/the-error-model/ **[site]**
- Scott Wlaschin. "Railway Oriented Programming." F# for Fun and Profit,
  11 May 2013. https://fsharpforfunandprofit.com/posts/recipe-part2/ **[site]**

### Effects, capabilities, and composition
- J. M. Lucassen and D. K. Gifford. "Polymorphic Effect Systems." POPL '88,
  47–57, 1988. doi:10.1145/73560.73564 **[doi]**
- Gordon Plotkin and Matija Pretnar. "Handlers of Algebraic Effects." ESOP
  2009, LNCS 5502, 80–94. doi:10.1007/978-3-642-00590-9_7 **[doi]**
- Mark Samuel Miller. *Robust Composition: Towards a Unified Approach to
  Access Control and Concurrency Control.* PhD thesis, Johns Hopkins
  University, 2006. http://erights.org/talks/thesis/ **[site]**
- Martin Fowler. "Inversion of Control Containers and the Dependency
  Injection pattern." 23 January 2004.
  https://martinfowler.com/articles/injection.html **[site]**
- Effect (TypeScript). https://effect.website/ **[site]**

### State, ownership, and contracts
- Carl Hewitt, Peter Bishop, and Richard Steiger. "A Universal Modular ACTOR
  Formalism for Artificial Intelligence." IJCAI 1973, 235–245.
  https://www.ijcai.org/Proceedings/73/Papers/027B.pdf **[site]**
- Philip A. Bernstein, Sergey Bykov, Alan Geller, Gabriel Kliot, and Jorgen
  Thelin. "Orleans: Distributed Virtual Actors for Programmability and
  Scalability." Microsoft Research, MSR-TR-2014-41, 2014. **[site]**
- Cloudflare. Durable Objects documentation.
  https://developers.cloudflare.com/durable-objects/ **[site]**
- Pat Helland. "Life beyond Distributed Transactions: an Apostate's
  Opinion." CIDR 2007, 132–141.
  https://www.cidrdb.org/cidr2007/papers/cidr07p15.pdf **[site]** (the page
  range is from dblp)
- Hector Garcia-Molina and Kenneth Salem. "Sagas." SIGMOD '87, 249–259,
  1987. doi:10.1145/38713.38742 **[doi]**
- Yaron Minsky. "Effective ML Revisited." Jane Street Tech Blog, 9 March
  2011. https://blog.janestreet.com/effective-ml-revisited/ **[site]**
- Bertrand Meyer. "Applying 'Design by Contract'." *Computer* 25(10):40–51,
  1992. doi:10.1109/2.161279 **[doi]**
- David Harel. "Statecharts: A Visual Formalism for Complex Systems."
  *Science of Computer Programming* 8(3):231–274, 1987.
  doi:10.1016/0167-6423(87)90035-9 **[doi]**

### Callers and authority
- OWASP. API Security Top 10 (2023): API1:2023 Broken Object Level
  Authorization.
  https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/
  **[site]**
- Norm Hardy. "The Confused Deputy (or why capabilities might have been
  invented)." *ACM SIGOPS Operating Systems Review* 22(4):36–38, 1988.
  doi:10.1145/54289.871709 **[doi]**
- Ruoming Pang et al. "Zanzibar: Google's Consistent, Global Authorization
  System." USENIX ATC 2019, 33–46.
  https://www.usenix.org/conference/atc19/presentation/pang **[site]** (a
  relationship-based model, though the paper does not use the term ReBAC)

### Messages, events, and evolution
- Gregor Hohpe and Bobby Woolf. *Enterprise Integration Patterns: Designing,
  Building, and Deploying Messaging Solutions.* Addison-Wesley, 2003.
  ISBN 0-321-20068-3 **[memory]**
- Pat Helland. "Idempotence Is Not a Medical Condition." *ACM Queue*
  10(4):30–46, 2012. doi:10.1145/2181796.2187821 **[doi]**
- Martin Kleppmann. *Designing Data-Intensive Applications*, first edition.
  O'Reilly, 2017. Chapter 4, "Encoding and Evolution." **[memory]**
- Ian Robinson. "Consumer-Driven Contracts: A Service Evolution Pattern."
  12 June 2006.
  https://martinfowler.com/articles/consumerDrivenContracts.html **[site]**

### Testing and diagnostics
- Koen Claessen and John Hughes. "QuickCheck: A Lightweight Tool for Random
  Testing of Haskell Programs." ICFP 2000, 268–279.
  doi:10.1145/351240.351266 **[doi]**
- John Hughes. "Experiences with QuickCheck: Testing the Hard Stuff and
  Staying Sane." In *A List of Successes That Can Change the World*, LNCS
  9600, 169–186. Springer, 2016. doi:10.1007/978-3-319-30936-1_9 **[doi]**
- fast-check. https://fast-check.dev/ **[site]**
- Steve Freeman and Nat Pryce. *Growing Object-Oriented Software, Guided by
  Tests.* Addison-Wesley, 2009. ISBN 0-321-50362-7 **[author]**
- Evan Czaplicki. "Compiler Errors for Humans." 30 June 2015.
  https://elm-lang.org/news/compiler-errors-for-humans **[author]**
- Brett A. Becker et al. "Compiler Error Messages Considered Unhelpful: The
  Landscape of Text-Based Programming Error Message Research." ITiCSE-WGR
  '19, 177–210. doi:10.1145/3344429.3372508 **[doi]**

### Adoption and other service languages
- Martin Fowler. "Strangler Fig." 22 August 2024 (first published 29 June
  2004 as "Strangler Application").
  https://martinfowler.com/bliki/StranglerFigApplication.html **[site]**
- Ballerina. https://ballerina.io/ **[site]**
- Unison. https://www.unison-lang.org/ **[site]**

---

## Open points for the author

1. **[memory] entries** (Evans, Hohpe & Woolf, Kleppmann): confirm against
   a publisher record or your copy. The Evans and Hohpe & Woolf ISBNs match
   library catalogues and retailer listings.
2. **Scale:** 26 footnotes is a proposal. Optional ones (3b, 6b, 11a) can go
   to Further reading only.
3. **Brooks and Lehman (14b):** choose whether the pressure argument is
   cited in the prologue, chapter 14, or the epilogue.
4. **Implementation, once approved:** add the footnotes with
   `#footnote[...]`, add `backmatter/further-reading.typ` included before the
   index in `main.typ`, and record each citation in `notes/source-map.md`.
   `bibliography.bib` can stay empty under decision 5, or be removed.
