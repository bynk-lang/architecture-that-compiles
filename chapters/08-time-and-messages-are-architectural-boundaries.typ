#import "../template.typ": code-listing, compiler-message, lead-in

#let source-lines(path, start, end) = {
  read(path).split("\n").slice(start, end).join("\n")
}

= Time and messages are architectural boundaries <time-and-messages-are-architectural-boundaries>

A payment requested over HTTP, a payment retry taken from a queue, and a
reconciliation started by a schedule may eventually call the same domain
operation. That does not make them the same operation.

In the first case, somebody is waiting for a response. In the second, a
delivery system needs a verdict about the message. In the third, no caller is
waiting and there may be no retry before the next scheduled run. A message on a
WebSocket adds a fourth shape: it belongs to a connection whose lifetime extends
beyond any one handler invocation. A fact that one context announces to whoever
is listening is a fifth: nobody asked for it, and nobody answers it.

These differences determine what success means, who may try again, which time
the work belongs to, and what must remain alive when a handler returns. They
are easy to lose because implementation languages give all five boundaries the
same convenient shape: an asynchronous callback.

== A callback can hide the agency

#lead-in[
A team might deliberately standardise its entry points like this:
]

#code-listing(
  [One callback type makes four entry mechanisms look interchangeable],
  read("../snippets/chapter-08/conventional.ts"),
  lang: "typescript",
)

The abstraction has an attractive property. Delivery logic is written once,
and each adapter registers the same function. Test doubles can invoke it
without an HTTP server, queue, scheduler, or socket.

The common type also discards every protocol decision. `DeliveryResult` does not
say whether a temporary failure should become HTTP 503, a queue retry, a logged
cron failure, or a frame sent to a connected client. It does not say who is
waiting for the promise. It cannot express a scheduled instant or the ownership
of a connection.

The adapter implementations can restore those meanings. Good adapters do.
But the shared `EntryPoint` contract does not require them to, and a reviewer
at the registration site cannot tell what each result will cause.

Reusing the domain operation is sound. Reusing the boundary contract is the
mistake.

== Let the protocol own the verdict <ix-08-let-the-protocol-own-the-verdict>

#lead-in[
The Bynk version keeps one effectful delivery requirement:
]

#code-listing(
  [The reusable operation knows nothing about how work arrived],
  source-lines(
    "../snippets/chapter-08/declared/src/commerce/notifications.bynk",
    0,
    20,
  ),
  lang: "bynk",
)

`Mailer.send` returns the domain outcome that every entry point needs:
successful delivery, a temporary failure, or a permanent failure. It does not
decide what the surrounding protocol should do with that outcome.

#lead-in[
The HTTP and queue handlers make different translations:
]

#code-listing(
  [The same delivery outcome has two different boundary meanings],
  source-lines(
    "../snippets/chapter-08/declared/src/commerce/notifications.bynk",
    21,
    48,
  ),
  lang: "bynk",
)

The HTTP caller waits for one response. Successful delivery becomes
`NoContent`. A temporary mailer failure becomes `ServiceUnavailable`, and a
permanent recipient problem becomes `UnprocessableEntity`. Those statuses
inform the caller; they do not cause the Bynk runtime to repeat the request. The
remote caller owns any subsequent retry policy.

The queue has a different principal to answer: the delivery system. `Ack` says
that the message is finished and may be removed. `Retry(reason)` asks for
redelivery. A temporary mailer failure therefore becomes `Retry`, while a
permanent failure becomes `Ack` even though the email was not sent. Repeating a
poison message cannot make its recipient valid.

This separation is more precise than treating `Ok` as acknowledgement and
`Err` as retry. A queue consumer may need to acknowledge a domain failure, as
this one does. It may also need to retry after some effects have already
succeeded. The delivery verdict and the domain result answer different
questions.

That second case carries a warning. If the mailer accepts the email and the
handler fails before its message is acknowledged, redelivery may send the email
again. `QueueResult` makes the retry decision visible; it does not make the
operation idempotent. The message needs a stable identity, and the owner of the
effect may need to remember that identity, if duplicates are unacceptable.#footnote[
  Pat Helland's “Idempotence Is Not a Medical Condition” explains why at-least-
  once delivery makes this unavoidable.
]
Dead-letter policy also remains queue configuration outside this handler.

== Scheduled time is not the current time <ix-08-scheduled-time-is-not-the-current-time>

#lead-in[
A schedule has neither a request caller nor a message to acknowledge:
]

#code-listing(
  [A scheduled run receives its intended instant and reports a logged result],
  source-lines(
    "../snippets/chapter-08/declared/src/commerce/notifications.bynk",
    49,
    64,
  ),
  lang: "bynk",
)

The expression `0 8 * * *` declares one daily run at hour eight. Its `at`
parameter is the scheduled fire time in Unix epoch milliseconds. It is not a
call to a clock made after the handler starts. If a run begins late, the
scheduled instant still identifies the time bucket it was meant to process.

That distinction matters for daily summaries, reconciliation windows, and
idempotency keys. “Process the 08:00 run” is a stable instruction. “Process
whatever day `now` happens to report after startup delay” is not.

The return type is `Result[(), String]`. `Ok(())` completes silently.
`Err(...)` is logged and the run completes. Cron has no retry channel: a failure
does not secretly turn this invocation into another one. The next scheduled
fire is a new event, and catch-up or retry behaviour must be designed
explicitly.

The example includes `at` in the digest subject only to keep the relationship
visible. A production system would usually turn it into a domain time or
period type before using it. An epoch integer is precise transport information,
not yet a rich model of business time.

== The verdict a queue insists on <ix-08-the-verdict-a-queue-insists-on>

#lead-in[
The protocol distinction becomes clearest when a queue handler returns an
ordinary domain result:
]

#code-listing(
  [This result says whether work succeeded, but not what to do with the message],
  read("../snippets/chapter-08/wrong-verdict/src/commerce/notifications.bynk"),
  lang: "bynk",
)

#lead-in[
The compiler refuses the handler:
]

#compiler-message[
[bynk.queue.return_not_queue_result] Error:
`on message` handler must return `Effect[QueueResult]`,
but got `Effect[Result[(), SendError]]`
]

`Ok(())` sounds successful, but it leaves the queue's agency unstated. Should
the message be removed? Is a logical failure permanent? Did partial success
make retry dangerous? A queue handler must answer with `Ack` or `Retry` because
the infrastructure, not a synchronous caller, acts on its answer.

The compiler does not choose the verdict. It makes the missing choice visible.

== A connection is not a request <ix-08-a-connection-is-not-a-request>

HTTP, queue, and cron handlers can release their input when they return. A
WebSocket opening creates a resource whose reason for existing is to outlive
that first handler.

#lead-in[
The tracking service declares both directions of the conversation and all
three lifecycle events:
]

#code-listing(
  [Opening, receiving, and closing are separate parts of one connection],
  source-lines(
    "../snippets/chapter-08/declared/src/commerce/tracking.bynk",
    10,
    37,
  ),
  lang: "bynk",
)

`ClientFrame` is the shape the client may send; `ServerFrame` is the shape the
server may send. The upgrade authenticates `Subscriber` before the connection
is accepted. On success, `on open` receives an owned
`Connection[ServerFrame]`.

#lead-in[
Sending the initial frame does not consume that connection. Transferring it to
`Tracking(trackingId).join(...)` does. The opening handler may then return
because another owner is responsible for the live resource:
]

#code-listing(
  [The keyed agent holds the connection until the close event removes it],
  source-lines(
    "../snippets/chapter-08/declared/src/commerce/tracking.bynk",
    38,
    63,
  ),
  lang: "bynk",
)

The `on message` and `on close` handlers recover the same route identity and
delegate to that agent. Removing the stored connection closes it. On the
Workers target, the connection can survive hibernation and be restored with the
agent.

This is stronger than adding a `socket` property to a generic event object. The
connection is a held resource. It must move into exactly one routable agent,
cannot be used after transfer, and cannot be forgotten when a branch returns.
The compiler is checking lifetime and ownership because those are part of the
WebSocket boundary.

The model is intentionally particular. A WebSocket service has one opening
shape, typed inbound and outbound frames, and an owner for each accepted
connection. Applications that need arbitrary upgrade routing or a library's
unrestricted socket object may find the constraint too narrow. The gain is that
long-lived state does not become an invisible exception to the ownership model
from Chapter 5.

== A fact is not a command <ix-08-a-fact-is-not-a-command>

A queue message asks for work, and its handler answers the broker: done, or try
again. Some boundaries have a different shape. When an order is paid, ordering
does not need receipts, ledgers, or analytics to do anything in particular. It
needs them to know that something happened. Bynk calls that an event.

#code-listing(
  [The orders context declares what it announces, and announces it after the owner commits],
  read("../snippets/chapter-08/events/src/commerce/orders.bynk"),
  lang: "bynk",
  breakable: true,
)

`event OrderPaid` is a record shape declared by the context that owns the fact,
and `exports transparent` lets other contexts see it. `Events` is a capability,
so the service that emits says so with `given Events`, like any other effect.
The emission follows the `Order` agent's decision: a repeated payment returns
`false` and announces nothing.

Emission is fire and forget. `Events.emit` returns `Effect[()]`, so the service
learns nothing about who received the fact or what they did with it. That is
the point of the boundary. Orders does not depend on its subscribers, and adding
a subscriber does not change orders.

#lead-in[
The subscriber is a service with a different protocol:
]

#code-listing(
  [Notifications reacts to the fact, once per emission],
  source-lines(
    "../snippets/chapter-08/events/src/commerce/notifications.bynk",
    0,
    4,
  ) + "\n\n" + source-lines(
    "../snippets/chapter-08/events/src/commerce/notifications.bynk",
    17,
    40,
  ),
  lang: "bynk",
  breakable: true,
)

`from Events(OrderPaid)` makes `receipts` a subscriber. It is never called
directly; it runs when the fact arrives. Its context `consumes commerce.orders`
in order to name the event, the same declaration that would permit a service
call, here permitting a subscription.

The handler returns `Effect[()]`, and that type carries the sharpest difference
from a queue. There is no `Ack` and no `Retry`. Nobody waits for the answer,
and Bynk does not redeliver a fact whose subscriber failed. When the mailer
reports a failure, this handler can log it, and that is all: the receipt is not
sent, and nothing will ask again. A team that needs the receipt eventually must
give that obligation an owner, such as an agent that records unsent receipts or
a scheduled sweep, because the event boundary will not carry it. Choosing an
event rather than a queue is choosing who owns the retry.

The handler also defends against the opposite failure: hearing the same fact
twice. A subscriber should not assume it runs exactly once, so the optional
`env` parameter carries the emission's identity. Its `eventId` is minted once
per emission, not once per delivery. `Idempotency.dedup` asks whether this
subscriber has already handled that emission, and `remember` records that it
has. Delivered twice with the same envelope, the handler sends one receipt.

That guarantee is narrower than it looks, and the listing shows where.
`remember` runs after the send, so a fault between the two leaves a window in
which a second delivery would send again. And the `Idempotency` provider Bynk
ships keeps its record in memory, so a restart forgets what it remembered.
Handling each fact once is a discipline this subscriber follows, with gaps the
code makes visible. It is not a property of the boundary.

Two rules on the emitting side do come from the language.

First, an emission is released only if the handler that raised it commits. A
handler that emits and then faults, for instance because an invariant refuses
a commit later in the same handler, delivers nothing. The announcement and the
state change it describes stand or fall together.

#lead-in[
Second, only the context that declares an event may emit it. Suppose
notifications, which can already see `OrderPaid` in order to subscribe, tries
to emit one to backfill a missing receipt:
]

#code-listing(
  [A subscriber attempts to assert a fact it does not own],
  read("../snippets/chapter-08/forged-event/src/commerce/notifications.bynk"),
  lang: "bynk",
)

#compiler-message[
[bynk.event.emit_outside_owner] Error:
`OrderPaid` is not declared in this context — only the context
that declares an event may emit it

Note: a foreign event is visible via `consumes` for subscription
(`from Events(...)`), but only its owning context may `Events.emit` it
]

The other cross-context rules in this book govern what a context may name.
This one governs what a context may do with something it can already see. If
subscribers could forge the facts they listen to, every subscriber's view of
the world would depend on the most careless one. Being able to read a fact is
not the authority to assert it.

== Five boundaries, five promises <ix-08-five-boundaries-five-promises>

#lead-in[
The contrasts can be summarised without collapsing them:
]

#figure(
  block(width: 100%)[
    #set text(size: 8.2pt, hyphenate: false)
    #set par(justify: false, leading: 0.56em, first-line-indent: 0pt)
    #table(
      columns: (0.62fr, 0.92fr, 1.15fr, 1.25fr),
      inset: (x: 0.45em, y: 0.48em),
      stroke: (x, y) => if y == 0 { (bottom: 0.8pt + rgb("#4b44d6")) } else { none },
      table.header(
        text(weight: "semibold")[Boundary],
        text(weight: "semibold")[Begins with],
        text(weight: "semibold")[Handler determines],
        text(weight: "semibold")[Time or lifetime],
      ),
      [HTTP], [A request], [The response to its caller], [One request-response exchange],
      [Queue], [A delivered message], [Acknowledgement or redelivery], [May repeat; duplicates matter],
      [Cron], [A schedule firing], [Logged success or failure], [The declared scheduled instant],
      [WebSocket], [An authenticated upgrade], [The connection's lifecycle effect], [A connection outlives handlers],
      [Event], [A fact another context committed], [Its own reaction; nothing returns to the emitter], [After the emitter commits; no redelivery],
    )
  ],
  caption: [A shared domain operation does not imply a shared boundary contract.],
)

The handler forms and return types are not ceremony around the same callback.
They identify who has agency after the handler finishes. An HTTP result gives
the remote caller information. A queue result instructs the broker. A cron
result records the run. A WebSocket lifecycle handler changes the state of a
continuing conversation. An event handler answers to no one: it reacts to a fact
whose owner has already moved on.

There are further protocol details: path admission and status codes, malformed
message handling, schedule validation, frame authentication, connection
hibernation. Those belong in the online reference. The architectural point is
smaller and more durable: a boundary should retain the guarantees of the
mechanism that crossed it.

== One adapter per protocol

TypeScript can do this. Mature TypeScript systems use different adapter interfaces for HTTP,
queues, schedules, WebSockets, and event buses. Queue libraries expose
acknowledgement and retry. Schedulers provide a fire time. WebSocket frameworks
expose connection lifecycle. Event emitters decouple a publisher from its
subscribers. Branded types and lint rules can keep the adapters from collapsing
into one generic callback.

What holds that version together is that each adapter keeps to its own
contract. A queue consumer registered through the generic callback still
compiles, and its verdict to the broker is whatever the adapter infers from a
result that was never designed to give one.

That can be the right design, especially when platform choice or protocol
details change frequently. Bynk's closed set of entry protocols is a cost. A
new transport cannot be introduced as an ordinary library interface; the
language, compiler, and runtime must agree on its semantics. Even within the
supported set, deployment policies such as dead-letter configuration remain
outside the program. Nor does the language decide whether a fact needs a
durable log or a retry; at present it offers neither.

Bynk's wager is that these five boundaries are common and consequential enough
to deserve language support. Their source forms preserve the questions that a
generic callback loses: who waits, who retries, which time applies, and who owns
what survives.

That completes the argument of Part II. An effect names what work requires. An
agent names who owns state. A state contract names what may be committed. An
actor names who crosses a boundary. An entry protocol names the temporal and
delivery rules under which the call occurs.

Together they make more of the architecture visible in the program. They do
not prove that the architecture behaves as intended.

A queue handler can choose the wrong verdict. An invariant can be too weak. A
capability provider can return an inconvenient answer. A WebSocket
conversation can produce an unexpected history while every individual call is
well typed.

Part III turns to confidence: how to test these declared boundaries without
constructing a second, easier architecture that exists only in the test suite.
