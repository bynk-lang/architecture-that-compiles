#import "../template.typ": subject-index

#let index-entries = (
  (
    letter: "A",
    entries: (
      (
        term: [actors],
        refs: (
          <ix-07-declare-the-boundary-contract>,
          <ix-07-put-the-caller-beside-the-operation>,
          <ix-12-read-the-edge-as-a-contract>,
        ),
      ),
      (
        term: [adapters],
        refs: (
          <ix-11-typescript-is-also-a-checking-boundary>,
          <ix-14-the-host-boundary-is-a-proof-boundary>,
          <ix-14-one-context-at-a-time>,
        ),
      ),
      (
        term: [admission],
        refs: (
          <ix-02-admission-is-the-boundary-that-matters>,
          <ix-10-the-compiler-must-know-when-it-does-not-know>,
        ),
      ),
      (
        term: [adoption],
        refs: (
          <ix-11-the-surrounding-system-is-part-of-the-language>,
          <ix-14-one-context-at-a-time>,
          <ix-14-the-way-back-out>,
        ),
      ),
      (
        term: [agents],
        refs: (
          <ix-05-give-memory-an-identity>,
          <ix-05-the-key-selects-the-owner>,
          <ix-05-ownership-is-the-commit-boundary>,
          <ix-12-open-the-owners>,
        ),
      ),
      (
        term: [architecture],
        refs: (
          <prologue>,
          <epilogue>,
        ),
        subs: (
          (
            term: [as convention],
            refs: (
              <ix-01-where-the-boundary-went>,
              <ix-01-convention-and-declaration>,
            ),
          ),
          (
            term: [compiler-visible],
            refs: (
              <ix-01-the-architecture-in-the-diff>,
              <ix-11-why-a-language-and-not-a-framework>,
            ),
          ),
          (
            term: [recovering from source],
            refs: (
              <ix-12-start-with-the-map>,
              <ix-12-make-a-recoverability-ledger>,
              <ix-15-draw-what-the-source-can-support>,
            ),
          ),
        ),
      ),
      (
        term: [authentication],
        refs: (
          <ix-07-authenticated-is-not-authorised>,
          <ix-07-declare-the-boundary-contract>,
        ),
      ),
      (
        term: [authorisation],
        refs: (
          <ix-07-authenticated-is-not-authorised>,
          <ix-12-read-the-edge-as-a-contract>,
          <ix-13-a-rule-the-compiler-could-not-ask-for>,
        ),
      ),
    ),
  ),
  (
    letter: "B",
    entries: (
      (
        term: [boundaries],
        refs: (
          <ix-01-naming-the-boundary>,
          <ix-01-the-edge-that-must-be-declared>,
        ),
        subs: (
          (
            term: [entry points],
            refs: (<ix-08-five-boundaries-five-promises>,),
          ),
          (
            term: [host language],
            refs: (
              <ix-11-typescript-is-also-a-checking-boundary>,
              <ix-14-the-host-boundary-is-a-proof-boundary>,
            ),
          ),
        ),
      ),
      (
        term: [Bynk],
        refs: (
          <prologue>,
          <epilogue>,
        ),
        subs: (
          (
            term: [costs and fit],
            refs: (
              <ix-14-a-constraint-spends-flexibility>,
              <ix-14-know-which-problem-you-are-buying>,
            ),
          ),
          (
            term: [relationship to TypeScript],
            refs: (
              <ix-11-meaning-by-translation>,
              <ix-11-why-a-language-and-not-a-framework>,
              <ix-13-the-same-change-without-a-declaration>,
            ),
          ),
        ),
      ),
    ),
  ),
  (
    letter: "C",
    entries: (
      (
        term: [caller identity],
        see: [actors],
      ),
      (
        term: [capabilities],
        refs: (
          <ix-04-name-what-the-world-can-do>,
          <ix-04-the-authority-a-signature-can-t-omit>,
          <ix-12-trace-effects-through-both-layers>,
        ),
      ),
      (
        term: [Cloudflare Workers],
        refs: (
          <ix-11-topology-is-a-build-choice>,
          <ix-11-how-much-survives-without-cloudflare>,
        ),
      ),
      (
        term: [compensation],
        refs: (
          <ix-12-follow-the-irreversible-work>,
          <ix-13-compensation-becomes-a-contract>,
          <ix-14-ownership-does-not-compose-into-a-transaction>,
        ),
      ),
      (
        term: [compiler diagnostics],
        refs: (
          <ix-10-a-type-error-is-not-yet-an-explanation>,
          <ix-10-diagnostics-are-part-of-the-language>,
        ),
      ),
      (
        term: [compiler refusals],
        refs: (
          <ix-01-the-edge-that-must-be-declared>,
          <ix-10-name-the-rule-not-only-the-symptom>,
          <ix-10-advice-and-refusal-are-different-commitments>,
        ),
      ),
      (
        term: [constraints],
        refs: (
          <ix-14-a-constraint-spends-flexibility>,
          <ix-14-the-cost-arrives-first>,
        ),
      ),
      (
        term: [`consumes`],
        refs: (
          <ix-01-naming-the-boundary>,
          <ix-01-the-edge-that-must-be-declared>,
          <ix-13-a-new-edge-has-to-be-declared>,
        ),
      ),
      (
        term: [contexts],
        refs: (
          <ix-01-naming-the-boundary>,
          <ix-12-start-with-the-map>,
          <ix-13-a-new-edge-has-to-be-declared>,
        ),
      ),
      (
        term: [contract skew],
        refs: (
          <ix-09-after-the-tests-pass>,
          <ix-13-shipping-one-context-at-a-time>,
        ),
      ),
    ),
  ),
  (
    letter: "D",
    entries: (
      (
        term: [dependency graphs],
        refs: (
          <ix-01-the-edge-that-must-be-declared>,
          <ix-10-a-fix-is-not-a-design-decision>,
          <ix-12-start-with-the-map>,
        ),
      ),
      (
        term: [deployment topology],
        refs: (
          <ix-11-topology-is-a-build-choice>,
          <ix-12-start-with-the-map>,
        ),
      ),
      (
        term: [domain models],
        refs: (
          <ix-02-the-record-looks-convincing>,
          <ix-02-three-facts-not-one>,
          <ix-02-what-the-model-still-cannot-know>,
        ),
      ),
      (
        term: [Durable Objects],
        refs: (
          <ix-05-the-key-selects-the-owner>,
          <ix-11-topology-is-a-build-choice>,
          <ix-11-how-much-survives-without-cloudflare>,
        ),
      ),
    ),
  ),
  (
    letter: "E",
    entries: (
      (
        term: [effects],
        refs: (
          <ix-04-effect-marks-the-boundary>,
          <ix-04-what-the-list-does-not-promise>,
        ),
      ),
      (
        term: [entry points],
        refs: (
          <ix-08-let-the-protocol-own-the-verdict>,
          <ix-08-five-boundaries-five-promises>,
        ),
      ),
      (
        term: [escape hatches],
        refs: (
          <ix-02-opacity-is-authority-not-decoration>,
          <ix-11-why-a-language-and-not-a-framework>,
          <ix-14-some-systems-are-open-on-purpose>,
        ),
      ),
      (
        term: [events],
        refs: (
          <ix-08-a-fact-is-not-a-command>,
          <ix-13-an-event-outlives-the-shape-it-was-sent-in>,
        ),
      ),
      (
        term: [exhaustiveness],
        refs: (
          <ix-03-exhaustiveness-makes-change-visible>,
          <ix-13-a-failure-the-wildcard-absorbed>,
        ),
      ),
    ),
  ),
  (
    letter: "F",
    entries: (
      (
        term: [failure contracts],
        refs: (
          <ix-03-put-the-alternatives-in-the-operation>,
          <ix-03-propagation-is-not-disappearance>,
          <ix-03-designing-a-useful-failure-vocabulary>,
        ),
      ),
    ),
  ),
  (
    letter: "G",
    entries: (
      (
        term: [`given`],
        refs: (
          <ix-04-name-what-the-world-can-do>,
          <ix-04-the-authority-a-signature-can-t-omit>,
        ),
      ),
    ),
  ),
  (
    letter: "H",
    entries: (
      (
        term: [histories],
        refs: (<ix-09-generate-histories-by-driving-the-owner>,),
      ),
      (
        term: [HTTP],
        refs: (
          <ix-07-absence-is-also-a-security-decision>,
          <ix-08-let-the-protocol-own-the-verdict>,
        ),
      ),
    ),
  ),
  (
    letter: "I",
    entries: (
      (
        term: [idempotency],
        refs: (
          <ix-05-ownership-is-the-commit-boundary>,
          <ix-08-let-the-protocol-own-the-verdict>,
          <ix-08-a-fact-is-not-a-command>,
        ),
      ),
      (
        term: [identity],
        refs: (
          <ix-02-a-refusal-about-meaning>,
          <ix-02-opacity-is-authority-not-decoration>,
          <ix-07-declare-the-boundary-contract>,
        ),
      ),
      (
        term: [invariants],
        refs: (
          <ix-06-make-the-lifecycle-finite>,
          <ix-06-the-commit-is-the-checking-point>,
          <ix-06-the-guarantee-is-weaker-here-and-worth-admitting>,
          <ix-13-compensation-becomes-a-contract>,
        ),
      ),
    ),
  ),
  (
    letter: "M",
    entries: (
      (
        term: [messages],
        refs: (
          <ix-08-let-the-protocol-own-the-verdict>,
          <ix-08-a-fact-is-not-a-command>,
        ),
      ),
    ),
  ),
  (
    letter: "O",
    entries: (
      (
        term: [observability],
        refs: (<ix-09-after-the-tests-pass>,),
      ),
      (
        term: [opaque values],
        refs: (
          <ix-02-three-facts-not-one>,
          <ix-02-opacity-is-authority-not-decoration>,
        ),
      ),
      (
        term: [ownership],
        refs: (
          <ix-05-a-database-is-a-place-not-an-owner>,
          <ix-05-the-key-selects-the-owner>,
          <ix-14-ownership-does-not-compose-into-a-transaction>,
        ),
      ),
    ),
  ),
  (
    letter: "P",
    entries: (
      (
        term: [plugins],
        refs: (<ix-14-some-systems-are-open-on-purpose>,),
      ),
      (
        term: [providers],
        refs: (<ix-04-providers-make-the-requirements-concrete>,),
      ),
    ),
  ),
  (
    letter: "Q",
    entries: (
      (
        term: [queues],
        refs: (
          <ix-08-let-the-protocol-own-the-verdict>,
          <ix-08-the-verdict-a-queue-insists-on>,
        ),
      ),
    ),
  ),
  (
    letter: "R",
    entries: (
      (
        term: [recoverability],
        refs: (
          <ix-12-make-a-recoverability-ledger>,
          <ix-14-the-accounting>,
        ),
      ),
      (
        term: [refined values],
        refs: (
          <ix-02-admission-is-the-boundary-that-matters>,
          <ix-02-the-proof-must-survive-the-journey>,
        ),
      ),
      (
        term: [`Result`],
        refs: (
          <ix-03-absence-is-not-failure>,
          <ix-03-put-the-alternatives-in-the-operation>,
        ),
      ),
      (
        term: [retries],
        refs: (
          <ix-08-let-the-protocol-own-the-verdict>,
          <ix-08-scheduled-time-is-not-the-current-time>,
          <ix-08-a-fact-is-not-a-command>,
        ),
      ),
    ),
  ),
  (
    letter: "S",
    entries: (
      (
        term: [schedules],
        refs: (<ix-08-scheduled-time-is-not-the-current-time>,),
      ),
      (
        term: [schema registry],
        refs: (<ix-13-an-event-outlives-the-shape-it-was-sent-in>,),
      ),
      (
        term: [Service Bindings],
        refs: (
          <ix-11-topology-is-a-build-choice>,
          <ix-13-a-new-edge-has-to-be-declared>,
        ),
      ),
      (
        term: [state transitions],
        refs: (
          <ix-06-a-state-type-is-not-a-state-machine>,
          <ix-06-make-the-lifecycle-finite>,
          <ix-06-when-a-transition-names-no-step>,
        ),
      ),
      (
        term: [stubs],
        refs: (
          <ix-09-substitute-at-the-declared-seam>,
          <ix-09-the-seam-a-test-can-t-invent>,
        ),
      ),
    ),
  ),
  (
    letter: "T",
    entries: (
      (
        term: [test tiers],
        refs: (<ix-09-realism-should-be-a-setting>,),
      ),
      (
        term: [testing],
        refs: (
          <ix-09-a-green-test-can-describe-another-system>,
          <ix-09-mocks-spies-and-property-tests>,
        ),
      ),
      (
        term: [transactions],
        refs: (
          <ix-05-ownership-is-the-commit-boundary>,
          <ix-14-ownership-does-not-compose-into-a-transaction>,
        ),
      ),
      (
        term: [TypeScript],
        refs: (
          <preface>,
          <ix-11-meaning-by-translation>,
        ),
        subs: (
          (
            term: [emission],
            refs: (
              <ix-11-meaning-by-translation>,
              <ix-11-typescript-is-also-a-checking-boundary>,
            ),
          ),
          (
            term: [when it fits better],
            refs: (
              <ix-11-why-a-language-and-not-a-framework>,
              <ix-14-know-which-problem-you-are-buying>,
            ),
          ),
        ),
      ),
    ),
  ),
  (
    letter: "V",
    entries: (
      (
        term: [validation],
        see: [admission],
      ),
    ),
  ),
  (
    letter: "W",
    entries: (
      (
        term: [WebSockets],
        refs: (<ix-08-a-connection-is-not-a-request>,),
      ),
      (
        term: [wildcard arms],
        refs: (
          <ix-03-exhaustiveness-makes-change-visible>,
          <ix-13-a-failure-the-wildcard-absorbed>,
        ),
      ),
      (
        term: [Workers],
        see: [Cloudflare Workers],
      ),
    ),
  ),
)

= Index <index>

#subject-index(index-entries)
