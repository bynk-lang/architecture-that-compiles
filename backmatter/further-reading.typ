#import "../template.typ": apparatus-note

= Further reading <further-reading>

// Long URLs and DOIs stretch justified lines; set the entries ragged-right.
#set par(justify: false)

#apparatus-note[
  The footnotes name a source where an idea in this book has one. This list
  gives full details for those sources and for some related reading, grouped
  by the parts of the argument they inform. Web addresses were checked in
  October 2026.
]

== Architecture and its erosion

- Dewayne E. Perry and Alexander L. Wolf. "Foundations for the Study of Software
  Architecture." _ACM SIGSOFT Software Engineering Notes_ 17(4):40–52, 1992.
  doi:10.1145/141874.141884
- D. L. Parnas. "On the Criteria to Be Used in Decomposing Systems into
  Modules." _Communications of the ACM_ 15(12):1053–1058, 1972.
  doi:10.1145/361598.361623
- M. M. Lehman. "Programs, Life Cycles, and Laws of Software Evolution."
  _Proceedings of the IEEE_ 68(9):1060–1076, 1980. doi:10.1109/PROC.1980.11805
- Frederick P. Brooks, Jr. "No Silver Bullet: Essence and Accidents of Software
  Engineering." _Computer_ 20(4):10–19, 1987. doi:10.1109/MC.1987.1663532
- ArchUnit. https://www.archunit.org/

== Types, admission, and failure

- Alexis King. "Parse, don't validate." 5 November 2019.
  https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/
- Tim Freeman and Frank Pfenning. "Refinement Types for ML." PLDI '91, 268–277,
  1991. doi:10.1145/113445.113468
- Niki Vazou, Eric L. Seidel, Ranjit Jhala, Dimitrios Vytiniotis, and Simon
  Peyton Jones. "Refinement Types for Haskell." ICFP 2014, 269–282.
  doi:10.1145/2628136.2628161
- Joe Duffy. "The Error Model." 7 February 2016.
  https://joeduffyblog.com/2016/02/07/the-error-model/
- Scott Wlaschin. "Railway Oriented Programming." F\# for Fun and Profit, 11 May
  2013. https://fsharpforfunandprofit.com/posts/recipe-part2/

== Effects, capabilities, and composition

- J. M. Lucassen and D. K. Gifford. "Polymorphic Effect Systems." POPL '88,
  47–57, 1988. doi:10.1145/73560.73564
- Gordon Plotkin and Matija Pretnar. "Handlers of Algebraic Effects." ESOP 2009,
  LNCS 5502, 80–94. doi:10.1007/978-3-642-00590-9\_7
- Mark Samuel Miller. _Robust Composition: Towards a Unified Approach to Access
  Control and Concurrency Control._ PhD thesis, Johns Hopkins University, 2006.
  http://erights.org/talks/thesis/
- Martin Fowler. "Inversion of Control Containers and the Dependency Injection
  pattern." 23 January 2004. https://martinfowler.com/articles/injection.html
- Effect (TypeScript). https://effect.website/

== State, ownership, and contracts

- Carl Hewitt, Peter Bishop, and Richard Steiger. "A Universal Modular ACTOR
  Formalism for Artificial Intelligence." IJCAI 1973, 235–245.
  https://www.ijcai.org/Proceedings/73/Papers/027B.pdf
- Philip A. Bernstein, Sergey Bykov, Alan Geller, Gabriel Kliot, and Jorgen
  Thelin. "Orleans: Distributed Virtual Actors for Programmability and
  Scalability." Microsoft Research, MSR-TR-2014-41, 2014.
- Cloudflare. Durable Objects documentation.
  https://developers.cloudflare.com/durable-objects/
- Pat Helland. "Life beyond Distributed Transactions: an Apostate's Opinion."
  CIDR 2007, 132–141. https://www.cidrdb.org/cidr2007/papers/cidr07p15.pdf
- Hector Garcia-Molina and Kenneth Salem. "Sagas." SIGMOD '87, 249–259, 1987.
  doi:10.1145/38713.38742
- Yaron Minsky. "Effective ML Revisited." Jane Street Tech Blog, 9 March 2011.
  https://blog.janestreet.com/effective-ml-revisited/
- Bertrand Meyer. "Applying 'Design by Contract'." _Computer_ 25(10):40–51,
  1992. doi:10.1109/2.161279
- David Harel. "Statecharts: A Visual Formalism for Complex Systems." _Science
  of Computer Programming_ 8(3):231–274, 1987. doi:10.1016/0167-6423(87)90035-9

== Callers and authority

- OWASP. API Security Top 10 (2023): API1:2023 Broken Object Level
  Authorization.
  https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/
- Norm Hardy. "The Confused Deputy (or why capabilities might have been
  invented)." _ACM SIGOPS Operating Systems Review_ 22(4):36–38, 1988.
  doi:10.1145/54289.871709
- Ruoming Pang et al. "Zanzibar: Google's Consistent, Global Authorization
  System." USENIX ATC 2019, 33–46.
  https://www.usenix.org/conference/atc19/presentation/pang

== Messages, events, and evolution

- Pat Helland. "Idempotence Is Not a Medical Condition." _ACM Queue_
  10(4):30–46, 2012. doi:10.1145/2181796.2187821
- Ian Robinson. "Consumer-Driven Contracts: A Service Evolution Pattern." 12
  June 2006. https://martinfowler.com/articles/consumerDrivenContracts.html

== Testing and diagnostics

- Koen Claessen and John Hughes. "QuickCheck: A Lightweight Tool for Random
  Testing of Haskell Programs." ICFP 2000, 268–279. doi:10.1145/351240.351266
- John Hughes. "Experiences with QuickCheck: Testing the Hard Stuff and Staying
  Sane." In _A List of Successes That Can Change the World_, LNCS 9600, 169–186.
  Springer, 2016. doi:10.1007/978-3-319-30936-1\_9
- fast-check. https://fast-check.dev/
- Steve Freeman and Nat Pryce. _Growing Object-Oriented Software, Guided by
  Tests._ Addison-Wesley, 2009. ISBN 0-321-50362-7
- Evan Czaplicki. "Compiler Errors for Humans." 30 June 2015.
  https://elm-lang.org/news/compiler-errors-for-humans
- Brett A. Becker et al. "Compiler Error Messages Considered Unhelpful: The
  Landscape of Text-Based Programming Error Message Research." ITiCSE-WGR '19,
  177–210. doi:10.1145/3344429.3372508

== Adoption and other service languages

- Martin Fowler. "Strangler Fig." 22 August 2024 (first published 29 June 2004
  as "Strangler Application").
  https://martinfowler.com/bliki/StranglerFigApplication.html
- Ballerina. https://ballerina.io/
- Unison. https://www.unison-lang.org/ ---
