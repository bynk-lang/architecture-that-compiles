# Source map

This is a research index, not a reuse plan. Existing documentation supplies
facts, examples, and earlier explanations; manuscript prose should be written
for its own argument and reading rhythm.

Paths in the middle column are relative to a checkout of
[`accuser/bynk`](https://github.com/accuser/bynk); the published equivalent of
`site/src/content/docs/` is <https://bynk-lang.org/>. They are reading material
for the author, not build inputs — this repository compiles without them.

| Manuscript concern | Useful repository material | Editorial transformation |
|---|---|---|
| Architectural drift | `site/src/content/docs/book/about/why-bynk-exists.md` | Broaden from motivation page into the book's central problem |
| Program boundaries | `site/src/content/docs/book/guides/program-structure/` | Reframe constructs around information lost in ordinary service code |
| Domain meaning | `site/src/content/docs/book/guides/type-system/` | Build a narrative from shape, identity, validity, and admission |
| Explicit effects | `site/src/content/docs/book/guides/effects-and-capabilities/` | Begin with hidden dependencies and their architectural consequences |
| State ownership | `site/src/content/docs/book/guides/agents-and-state/` | Add concurrency and lifecycle pressure before introducing agents |
| Caller authority | `site/src/content/docs/book/guides/actors/` | Connect identity to the meaning of an operation, not route configuration |
| Testing confidence | `site/src/content/docs/book/guides/testing/philosophy.md` | Expand the critique of alternative test-only architectures |
| Pragmatic runtime | `site/src/content/docs/book/guides/projects-build-and-deployment/why-compile-to-typescript.md` | Treat TypeScript emission as a design trade, not a product feature |
| Case studies | `examples/` and `site/src/content/docs/by-example/projects/` | Select recurring systems; read code directly and write new analysis |
| Exact behaviour | `site/src/content/docs/book/reference/` and `spec/` | Verify claims; leave exhaustive rules online |

## Boundary rules

- Do not import prose from the online Book into the manuscript build. (Since the
  split this is structural: the build reads nothing outside this repository.)
- Do not maintain the same paragraph in both places.
- Prefer links in planning notes over comments embedded in chapters.
- Read complete examples from their canonical repository files when the book is
  discussing those exact programs.
- Put narrative-specific programs in `snippets/` and compile-test them.

## Chapter research record

### Chapter 1: When architecture becomes convention

- The description of contexts and `consumes` was checked against the current
  program-structure guide and compiler fixtures.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-01/`; they are not imported from the online Book.
- The declared project passes `bynkc check`. The undeclared project is retained
  deliberately to exercise `bynk.resolve.unconsumed_context`.

### Chapter 2: A data shape is not a domain model

- Identity, refinement, literal admission, `.of`, and opaque construction were
  checked against the current type-system specification and compiler fixtures.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-02/`; none is imported from the online Book.
- The declared project passes `bynkc check`. The two rejected projects are
  retained deliberately to exercise `bynk.types.argument_mismatch` and
  `bynk.refine.literal_violates`.

### Chapter 3: Failure is part of the contract

- `Result`, `Option`, exhaustive matching, `?`, and direct error embeddings
  were checked against the current type-system specification and compiler
  fixtures.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-03/`; none is imported from the online Book.
- The declared project passes `bynkc check`. The rejected project is retained
  deliberately to exercise `bynk.types.non_exhaustive_match` on a nested
  `Result` error variant.
- The chapter's `declared` project keeps each context in one file at the path
  of its qualified name (`commerce/<context>.bynk`), as Bynk's layout rule
  requires. Until October 2026 each context was split across several files,
  which `bynkc check` accepted (accuser/bynk#1820) but which did not build.
  The listings print the same lines as before, now as `source-lines` slices
  of the merged file, each prefixed with the file's `context` line. A
  page-by-page comparison of the PDF text with the previous build found no
  difference.

### Chapter 4: Effects should name their requirements

- `Effect`, capability declarations, handler and provider `given` clauses,
  provider composition, and cross-context capability use were checked against
  the current effects-and-capabilities guides, reference, and compiler
  fixtures.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-04/`; none is imported from the online Book.
- The declared project passes `bynkc check`. The rejected project is retained
  deliberately to exercise `bynk.given.undeclared_capability` when a handler
  uses a capability absent from its `given` clause.
- The chapter's `declared` project keeps each context in one file at the path
  of its qualified name (`commerce/<context>.bynk`), as Bynk's layout rule
  requires. Until October 2026 each context was split across several files,
  which `bynkc check` accepted (accuser/bynk#1820) but which did not build.
  The listings print the same lines as before, now as `source-lines` slices
  of the merged file, each prefixed with the file's `context` line. A
  page-by-page comparison of the PDF text with the previous build found no
  difference.

### Chapter 5: State needs an owner

- Agent keys, `store` fields, storage kinds, fresh-state initialisation,
  handler-atomic state commits, target-specific addressing, and rehydration
  validation were checked against the current agents-and-state guides,
  reference, static semantics, compiler fixtures, and accepted design records.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-05/`; none is imported from the online Book.
- The declared project passes `bynkc check`. The rejected project is retained
  deliberately to exercise `bynk.agents.non_zeroable_state_field` for a refined
  cell whose type excludes the implicit zero.
- The chapter's `declared` project keeps each context in one file at the path
  of its qualified name (`commerce/<context>.bynk`), as Bynk's layout rule
  requires. Until October 2026 each context was split across several files,
  which `bynkc check` accepted (accuser/bynk#1820) but which did not build.
  The listings print the same lines as before, now as `source-lines` slices
  of the merged file, each prefixed with the file's `context` line. A
  page-by-page comparison of the PDF text with the previous build found no
  difference.

### Chapter 6: State changes are contracts

- Sum-typed state, exhaustive transition handlers, snapshot invariants, step
  invariants, genesis-commit behaviour, and `InvariantViolation` persistence
  semantics were checked against the current agents-and-state guides,
  reference, static semantics, compiler fixtures, runtime tests, and accepted
  design records.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-06/`; none is imported from the online Book.
- The declared project passes `bynkc check`. Runtime checks confirm that failed
  snapshot and step predicates preserve the last committed state. The rejected
  project is retained deliberately to exercise
  `bynk.transition.no_step_reference` when a snapshot claim is misclassified as
  a transition.
- The chapter's `declared` project keeps each context in one file at the path
  of its qualified name (`commerce/<context>.bynk`), as Bynk's layout rule
  requires. Until October 2026 each context was split across several files,
  which `bynkc check` accepted (accuser/bynk#1820) but which did not build.
  The listings print the same lines as before, now as `source-lines` slices
  of the merged file, each prefixed with the file's `context` line. A
  page-by-page comparison of the PDF text with the previous build found no
  difference.

### Chapter 7: Who is calling is part of the operation

- Actor declarations, handler `by` clauses, sealed identities, refinement
  actors, HTTP fail-closed behaviour, and cross-context `Caller` identity were
  checked against the current actors guides, reference, static semantics,
  compiler fixtures, and representative examples.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-07/`; none is imported from the online Book.
- The declared project passes `bynkc check`, and the conventional comparison
  passes strict TypeScript checking. The rejected project is retained
  deliberately to exercise `bynk.actor.missing_by_on_http` because an HTTP
  route may not leave public versus authenticated access implicit.

### Chapter 8: Time and messages are architectural boundaries

- HTTP request-response agency, queue acknowledgement and retry, cron scheduled
  time and no-retry behaviour, and WebSocket connection ownership were checked
  against the current entry-point guides, reference, compiler fixtures, and
  representative examples.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-08/`; none is imported from the online Book.
- The declared project passes `bynkc check`, and the conventional comparison
  passes strict TypeScript checking. The rejected project is retained
  deliberately to exercise `bynk.queue.return_not_queue_result`: a domain
  `Result` does not state whether queue infrastructure should acknowledge or
  redeliver a message.
- The events section uses `snippets/chapter-08/events`: orders declares and
  emits `OrderPaid`, and notifications subscribes with `from Events(...)`,
  deduplicating on `env.eventId` with `Idempotency`. It also uses
  `snippets/chapter-08/forged-event`, a refusal (`bynk.event.emit_outside_owner`)
  gated in `EXPECTATIONS.tsv` and quoted word for word from 0.313.0. Both
  projects also pass `bynkc compile` and `tsc` on the bundle and workers
  targets.
- Behaviour was checked the way Bynk's own `events_behaviour` test does it:
  compile the project to a JS bundle, drive `composeApp()` under Node, and
  observe the subscriber, with the mailer swapped for one that logs. At
  0.313.0:
  - a first payment sends one receipt, and a repeat payment emits nothing;
  - a handler that emits and then faults (an invariant refusing a later
    commit) delivers nothing;
  - delivering the same envelope twice to `receipts` sends once, and a new
    `eventId` sends again;
  - a subscriber that faults runs once, its failure is logged as
    `EventsFanout delivery failed`, it is not retried, and the emitter's call
    still returns normally.
  The integration test runner does not deliver events at 0.313.0
  (`deps.__eventsDispatch is not a function`), so this could not be a
  `bynkc test` suite.
- Taken from Bynk's documentation, not run: the events guide and the
  capability reference say there is no delivery retry and no durable log to
  replay, and that the shipped `Idempotency` provider is an in-memory map lost
  on restart. On Workers, the guide describes the fan-out as a Durable Object
  that catches and logs each subscriber's failure.
- The listing emits from a service after the agent commits, rather than from
  inside the agent. At 0.313.0, reading an agent's key with `self.id` passes
  `bynkc check` but emits TypeScript that `tsc` rejects (`as id`, a cast to the
  key's name instead of its type). Reported as accuser/bynk#1818.
- `chapter-08/declared` keeps each context at the path of its name
  (`commerce/notifications.bynk`, `commerce/tracking.bynk`), as Bynk's layout
  rule requires; until October 2026 they were `notifications/delivery.bynk` and
  `tracking/gateway.bynk`. `Mailer` now has a provider (`AcceptingMailer`),
  appended after the last printed line, so the chapter's five `source-lines`
  ranges are unchanged. Without it the workers build failed
  (accuser/bynk#1822); both targets now compile and pass `tsc`.

### Chapter 9: Tests should preserve the architecture

- Suites and cases, capability-scoped stubs, automatic interaction
  observation, the `unit` / `integration` / `system` tier dial, system-tier
  participant inference, and driven agent histories were checked against the
  current testing guides, reference, static semantics, compiler fixtures, and
  representative example suites.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-09/`; none is imported from the online Book.
- The declared project passes `bynkc check` and `bynkc test`, including a
  system-tier cross-context case and a generated history property. The
  conventional comparison passes strict TypeScript checking. The rejected
  project is retained deliberately to exercise `bynk.stub.not_a_seam` when a
  test attempts to introduce a collaborator absent from the target's declared
  capability graph.
- "After the tests pass" (operations) rests on the generated code at 0.313.0,
  which I ran or read in Workers and bundle builds:
  - An adapter that throws behind an HTTP route: the generated Worker, run
    under Node, answers `500 Internal Server Error` (text/plain) and logs
    nothing. The entry point's `catch` is bare, and the `/_bynk/call/` path
    shares it. Unknown routes get `404`.
  - Invariant violations call `console.error("InvariantViolation
    <Agent>.<name>", { agent, invariant })` in the agent's code, on both
    targets.
  - Queue entry points log `queue <name> retry`, `threw`, and
    `deserialise failed` before `msg.retry()`. Cron logs
    `cron <expr> failed` on `Err`. Event fan-out logs
    `EventsFanout delivery failed` with the event and service.
  - A callee refusing a contract mismatch returns the `409` body without
    logging. The caller's `callService` throws, and its HTTP route falls into
    the bare `catch`.
  - `Logger.info` printed the message unchanged.
  - The generated `wrangler.toml` holds only `name`, `main`,
    `compatibility_date` and bindings, with no observability settings.
  From Bynk's documentation, not run: the two-level `Logger` API; debugging
  with `--inspect` and frames named by operation; debug metadata kept out of
  deployed Workers; no tracing, metrics or correlation IDs documented. That
  tracing "belongs in a capability" comes from Bynk's design notes
  (`design/bynk-design-notes.md`), not its published docs.
  The docs say a `RehydrationViolation` is logged, but the generated code
  throws it without a log call; the section does not mention it.
  Reported to Bynk: the silent 500 as accuser/bynk#1825, unlogged contract
  skew as #1826, and the unlogged rehydration violation as #1827.
- "Test-only constructs never reach a deployed Worker" was checked against a
  workers build of `chapter-09/declared` at 0.313.0. No Worker module imports
  the emitted `tests/` tree, and none contains stub or call-recording code.
  `bynkc compile` does write the suites into the output tree beside the
  Workers (accuser/bynk#1821), so the earlier wording, "removed from the deploy
  build", overstated it.

### Chapter 10: A compiler refusal can teach the design

- Diagnostic codes, severity, source attribution, notes, structured
  suggestions, project-wide recovery, the generated diagnostic registry, and
  negative-fixture conformance were checked against the current specification,
  compiler implementation, CLI and language-server documentation, and
  diagnostic regression tests.
- The successful and rejected programs are manuscript-specific sources under
  `snippets/chapter-10/`; none is imported from the online Book.
- The declared project passes `bynkc check`. The rejected projects are retained
  deliberately to exercise `bynk.resolve.unconsumed_context` for an undeclared
  cross-context call and `bynk.context.consumes_cycle` for the project-wide
  contradiction revealed by adding the missing edge. The warning project
  compiles successfully while reporting `bynk.given.unused_capability`.

### Chapter 11: A new language should not require a new universe

- Typed TypeScript and JavaScript emission, the bundle and workers topologies,
  strict TypeScript conformance, source maps and debug metadata, adapters and
  binding modules, the platform axis, and Cloudflare deployment mappings were
  checked against the current emission and compilation specifications, guides,
  compiler implementation, and representative fixtures.
- The manuscript-specific project under `snippets/chapter-11/declared/`
  compiles for both the Node bundle and Cloudflare workers targets. Both emitted
  TypeScript trees pass `tsc --strict`; generated output is inspected but not
  retained in the manuscript source.
- The project's TypeScript binding is copied into both targets and satisfies the
  capability interface emitted from its Bynk adapter. The workers build emits a
  Service Binding between the two contexts and a Durable Object for the agent.
- The platform-lock project passes under the default Cloudflare platform and is
  retained to exercise `bynk.target.vendor_required` when the same source is
  built for Node.
- The escape-hatch passage in "Why a language, and not a framework?" was
  checked at 0.313.0. `OrderId.unsafe(...)` outside the defining commons is
  refused (`bynk.types.opaque_unsafe_outside`). A refined type has no
  `.unsafe` (`bynk.types.unknown_static_member`). The project manifest
  reference lists only `[project]`, `[paths]`, `[fmt]`, and `[lsp]`, rejects
  unknown tables, and has no switch for diagnostic severity. (`[paths]
  exclude` leaves files out of the program entirely; it does not relax a rule
  for code that is compiled.) The adapter description matches
  `snippets/chapter-11/declared`: `adapter text.normalise` names its
  `binding`, and `commerce.catalog` reaches it through
  `consumes text.normalise { Slug }`.

### Chapter 12: Reading a whole system

- The whole-system reading method was checked against the current project
  structure, actors, agents, effects, entry-point, compilation, and deployment
  documentation. The chapter applies those facts to one new manuscript case
  study rather than reusing the documentation's prose or example projects.
- The manuscript-specific order system under
  `snippets/chapter-12/whole-system/` contains shared domain values and
  three contexts. It passes `bynkc check` and compiles for both the Node bundle
  and Cloudflare workers targets; both emitted TypeScript trees pass strict
  TypeScript checking.
- The case study deliberately retains two design questions for analysis. A
  failed payment leaves stock reserved because no compensation edge exists,
  and the authenticated order read does not compare caller identity with the
  stored owner. These are valid programs, not compiler-negative fixtures: the
  chapter distinguishes architecture the language can preserve from policy the
  team has not expressed.

### Chapter 13: Changing a system that compiles

- Every step is a compile-tested snippet project under `snippets/chapter-13/`,
  derived from `chapter-12/whole-system`. The printed diffs are generated from
  those projects by `scripts/make-book-diffs.sh` (manifest
  `snippets/DIFFS.tsv`), and CI fails if a diff is stale.
- The two refusals (`bynk.types.non_exhaustive_match` for the unmapped
  `Fraudulent` decline, and `bynk.resolve.unconsumed_context` for the
  undeclared fraud call) are gated in `EXPECTATIONS.tsv` and quoted from
  0.313.0's `bynkc check` output.
- Behaviour was checked with scratch `bynkc test` suites at 0.313.0, not
  committed. Each test was also run against a deliberately broken version, to
  show it could fail:
  - `viewFor` returns the order to its owner, and returns `None` to any other
    customer. This was a property over distinct generated customers; it failed
    when the owner comparison was removed.
  - A released hold restores `available` and `reserved`. Releasing more than
    was held faults with `InvariantViolation: Stock.nonnegative`.
  - With `rejected_holds_no_stock` declared, the chapter 12 form of `reject`
    faults with `InvariantViolation: Order.rejected_holds_no_stock`, the
    message the chapter quotes.
  - The demonstration bank returns `Fraudulent` above 90,000 cents and
    `Declined` above 50,000.
- The Workers build of step 4 was compiled: four Workers, with
  `COMMERCE_FRAUD` beside the inventory and payments bindings in the orders
  `wrangler.toml`. The claim that the test runner builds fraud for a `system`
  test was checked with a scratch `system` suite: all four Workers appear under
  `out/workers`. That suite then failed at load with a `ReferenceError` in the
  generated orders Worker: `__OrderWire` uses a second `values.js` import
  before it is initialised. This looks like a Bynk defect in system-tier test
  output, not a manuscript problem, so the chapter claims only the
  participants. Reported as accuser/bynk#1817, with a minimal reproduction.
- Step 5 (contract skew) needs no new project; it compares the
  `step-2-compensation` and `step-3-absorbed` Workers builds at 0.313.0:
  - `bynk-contracts.json`: payments provides `charge` as `888e75757af17f9e` at
    step 2 and `808bfde7a21640c2` at step 3. Orders built at step 2 expects
    the first.
  - Deploy-time check, run as `bynk deploy --context … --dry-run` against a
    hand-written `bynk.deploy.lock` recording what is live (format from
    `bynk/src/deploy/ledger.rs`). Deploying payments at step 3 alone, with the
    step-2 build live, plans `redeploy commerce-payments` and gives no warning.
    Deploying orders at step 2 alone, with the step-3 payments live, is refused
    with the quoted `bynk.deploy.contract_skew` message (exit 1). The gate's
    one-directional scope matches `contract_skews` in
    `bynk/src/deploy/graph.rs`, and dependencies-first upload order matches
    `deploy_order` there.
  - Runtime, from `--emit js` builds run under Node 24: the step-3 payments
    Worker answers a request stamped `888e75757af17f9e` with `409` and the
    quoted `ContractMismatch` body. The step-2 runtime's `callService` throws
    `BoundaryError: ContractMismatch`, rather than returning a value. A request
    stamped `808bfde7a21640c2` gets `200`.
  - That the step-2 orders handler then leaves the order placed and reserved
    follows from the generated handler's order of calls (hold, `markReserved`,
    then `charge`). Agent commits made before a fault stand (chapter 5).
- Step 6 (event schema evolution) uses three projects derived from
  `chapter-08/events`, each with its `bynk.schema.lock` committed (a
  `.gitignore` exception):
  - `step-6-announced` is baselined at schema 1.
  - `step-6-additive` adds `currency: String = "GBP"`. Built from the
    announced lock, it moves to schema 2. The printed lock diff is generated
    from these two locks.
  - `step-6-retyped` retypes `cents` to `String`. It passes `bynkc check`, but
    `bynkc compile` against the additive lock refuses it with the quoted
    `bynk.event.non_additive_schema_change` message and leaves the lock
    unchanged. This is gated as a `build-fail` expectation, which
    `check-book-emit.sh` asserts on both targets.
  Checked at 0.313.0:
  - `bynkc check` neither reads nor writes the lock; `bynkc compile` does both.
  - Constructing the event still requires the defaulted field
    (`bynk.resolve.missing_field`).
  - The workers build's `__deserialise_OrderPaid`, run under Node, decodes a
    schema-1 payload with `currency = "GBP"`, and refuses one missing `cents`
    (`StructuralMismatch`).
  - The step-6 orders Worker stamps `schemaVersion: 2` on emission.
  - Deleting the lock and building again records schema 1.
  Taken from Bynk's documentation, not run: that `bynk dev` and `bynk deploy`
  also update the lock, and `via schema(N)` dispatch.
- The TypeScript comparison (`conventional/before` and `after`) passes
  `tsc --strict` (5.9.3) with stub modules for its imports.

### Chapter 14: The cost of stronger constraints

- The costs of acyclic context dependencies, explicit capabilities, keyed state
  ownership, closed failure vocabulary, actor-bearing edges, validated
  boundaries, adapters, and TypeScript emission were checked against the
  current static semantics, reference, and project/deployment guides.
- The chapter distinguishes intrinsic trade-offs from temporary feature gaps.
  In particular, atomic agent commits do not imply cross-agent transactions,
  adapters bound what Bynk can inspect, and the JavaScript/Workers target brings
  operational and organisational dependencies alongside its ecosystem reach.
- The open plugin host under `snippets/chapter-14/` is a new
  manuscript-specific TypeScript comparison. It passes strict TypeScript
  checking and represents a genuinely runtime-defined graph, illustrating a
  case where Bynk's compile-visible dependency graph is not the desired model.
- "One context at a time" and "The way back out" (adoption and exit) were
  checked at 0.313.0:
  - A Workers build of `chapter-13/step-3-absorbed`, run under Node: a
    `/_bynk/call/charge` request without an `X-Bynk-Contract` header gets
    `409 {"kind":"ContractMismatch",...,"actual":null}`. The emitted callee
    checks the header before it reads the body.
  - Queue entry points log `queue <name> deserialise failed` and call
    `msg.retry()` on a malformed message.
  - The generated JS for several projects has no non-relative imports: the
    runtime is emitted into the tree, and each file opens "Generated by
    bynkc — do not edit by hand."
  From Bynk's guides (`wrap-a-library`, `why-compile-to-typescript`): an
  adapter's `requires` clause pins its npm dependency into the generated
  `package.json`, and a remote API wraps the same way with no dependency.

### Epilogue: The program should not be able to forget

- The epilogue synthesises the manuscript's existing argument and returns to
  the four-box service introduced in the prologue. It adds no new language
  claims or source examples.
- The closing distinction---a language can preserve a decision but cannot make
  it wise---is grounded in the deliberately valid design defects examined in
  Chapter 12 and the constraint accounting in Chapter 14.
- The final test is intentionally portable beyond Bynk: identify important
  architectural facts that the implementation medium repeatedly erases, then
  choose a proportionate representation and enforcement mechanism.

### Publication apparatus

- Prior-work footnotes and `backmatter/further-reading.typ` implement
  `notes/prior-work.md`, which records each source, how it was checked, the
  author's confirmations, and the three books held back pending
  confirmation. The footnotes cite by author and title; full details are on
  the Further reading page.

- The preface synthesises the editorial brief and the manuscript's established
  relationship with the online Bynk Book. It introduces no new language claims.
- Contents entries, running heads, Roman and Arabic matter numbering, and index
  locators are generated from semantic headings and live document locations.
- The subject index points at significant discussions, not whole chapters.
  Each locator is a label on the section heading where the concept is treated
  substantially (`<ix-NN-…>`), usually one to four per term, and passing
  mentions are not indexed. `backmatter/index.typ` is generated from one
  mapping of terms to sections. A locator shows each page once, in page
  order. In October 2026 five core terms were added: `consumes`, `given`,
  Durable Objects, Service Bindings, and wildcard arms.
