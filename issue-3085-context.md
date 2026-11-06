# Issue context: n1xyz/proton#3085

Source: [nord: parallel clob and rfq with liquidity transfer](https://github.com/n1xyz/proton/issues/3085). Collected 2026-11-06 UTC with **Issue Context Scavenger v4**, `med`: two hops, contradiction budget `K_max = 5`. Issue is **OPEN**, assigned to **dzmitry-lahoda**, milestone **v24**, no labels; last body/comment update reported by GitHub: `2026-11-06T02:22:58Z`. Research is pinned to `master` commit `dc2f45bc5c0c1ab641dafea5b008af6ca18643c4`, not a deployment claim.

## What the issue now asks for

RFQ and CLOB should operate on the same market and settle to the same N1 position. Existing CLOB makers continue trading. RFQ should be the default execution path for BTC/ETH. The core maker receives an authorized request, hedges on Lighter, then attempts the N1 fill; it may decline and release the remaining quantity to CLOB while preserving the user's price limit and expiry. A later phase lets external makers compete within a per-market price band and response window, followed by a core-maker reservation before hedging. **One basis point and 50 ms are examples, not accepted defaults.** An external hedge does not guarantee successful N1 settlement. [Current issue body](https://github.com/n1xyz/proton/issues/3085), [November product discussion](https://null-studios-group.slack.com/archives/C070KJ98ABZ/p1793820250420469).

The body contains successive proposals: first “RFQ mode” retaining a live CLOB and RFQ funding, then independent CLOB/RFQ enablement, then the maker hedge/reservation/fallback flow. Treat them as design history with unresolved boundaries. They are not evidence the combined flow is implemented.

The linked July discussion supplies additional boundaries: RFQ-to-CLOB conversion should require opt-in because it reveals the user's limit price, and a partially filled market order should not post its remainder to the book. November does not explicitly repeal either boundary. Javier's November engineering discussion says conversion is presently lossy and the trigger solution may be inadequate for general orders. [Opt-in/disclosure](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1785462043957209), [market-order remainder](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1785449730016159), [lossy conversion](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793830437573389), [trigger limitation](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793830462830749).

A useful statement of the requested settlement invariants is:

- For requested quantity `Q`, remaining quantity `R`, and successful N1 fills `f_i`: `R = Q − Σ f_i ≥ 0`.
- An active remainder has exactly one execution owner/path at a time; after termination it has none. Reservation, release, expiry, cancellation and competing fills need defined ordering.
- The CLOB remainder must satisfy the original authorization, price constraint and lifetime. Posting is additionally subject to order-type semantics and disclosure consent.
- Hedge fills and N1 fills are separate observations. Recovery after hedge success plus N1 rejection remains an explicit design decision.

These equations summarize the proposal, not verified properties of a new implementation.

## Seed signature and traversal

`T_id = {proton#3085, #3019, #3081, #3107, #3125, #3273, #3117}`. Symbols: `MarketMode`, `MarketRegime`, `FundingMode` (proposed), `ReduceOrderLiquidation`, `PositionStateOrderSize`, RFQ place/fill/cancel, backstop accounts, receipts/history. Domain: independent execution enablement, RFQ funding, shared position/risk, maker reservation, partial fills, expiry, fallback and privacy. Actors: Sheheryar/cherryman, Dzmitry, Dima, Javier, Kirk; primary discussion windows July 30–August 10 and November 4–6, 2026.

Belnap notation: **T** = supported by inspected evidence; **F** = evidence refutes the proposition; **B** = opposing source statements retained together; **U** = unestablished. Statements must concern the same state and scope to count as **B**. A future requirement versus current implementation is a gap; an explicitly versioned old specification is historical context. Neither automatically creates a contradiction. Missing decisions are **U**.

### Table 1. Cumulative hop and context delta ledger

| Hop | Source domain | Artifact / ref | Net-new context added | New tokens spawned | State | Stop gate status |
| --- | --- | --- | --- | --- | --- | --- |
| 0 | Seed | [#3085](https://github.com/n1xyz/proton/issues/3085), all six comments | Evolving parallel execution proposal; risk/backstop concerns; two Slack links | CLOB, RFQ, #3019, #3125, hedge/fallback | T for text; U for implementation | Initialized |
| 1 | Issue / PR graph | Full issue timeline, [#3019](https://github.com/n1xyz/proton/issues/3019), [#3125](https://github.com/n1xyz/proton/pull/3125) | Timeline identifies prerequisite #3081, receipt fix #3107 and liquidation issue #3273. #3019 is closed; #3125 remains open | Multi-backstop receipts, reduce capacity, migration | T | Nonzero delta; continue |
| 1 | Code / VCS | Fresh temporary clone at pinned `master` SHA | Current model still distinguishes exclusive market modes | `MarketMode`, mode guards, RFQ sampling | T for exclusive current model; U for target support | Continue |
| 1 | Slack | Complete [July parent + 32 replies](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1785448112414289), [November parent + 5 replies](https://null-studios-group.slack.com/archives/C070KJ98ABZ/p1793820250420469) | Opt-in disclosure, IOC remainder exclusion, new hedge/reservation flow | FundingMode, consent, execution owner | T for statements; U for reconciliation | Continue |
| 1–2 | Docs / RFC | Drive searches `3085`, `RFQ`, `proton`; repository docs | Drive returned zero accessible matches; repository documentation supplied historical model | RFQ v0 specification, current code | U for undiscovered RFCs; T for versioned historical prose | Empty searches do not establish global fixed point |
| 2 | Issue / PR graph | [#3081](https://github.com/n1xyz/proton/pull/3081), [#3107](https://github.com/n1xyz/proton/pull/3107), [#3273](https://github.com/n1xyz/proton/issues/3273), [#3117](https://github.com/n1xyz/proton/issues/3117), trigger PRs [#3276](https://github.com/n1xyz/proton/pull/3276)/[#3277](https://github.com/n1xyz/proton/pull/3277) | Prerequisite merged; receipt regression history; standing RFQ orders are a separate proposed feature; trigger work still open | One-book/one-market coupling, conversion contracts | T; proposed behavior remains U | Depth bound reached |
| 2 | Code / VCS | Mode callers, RFQ execution, funding, liquidation, API/history and tests | Change crosses engine and downstream read models; current RFQ partial fills already exist | See Table 4 | T/B/U per row | Depth bound reached |
| 2 | Slack | Complete [Nov 4 engineering thread, 12 replies](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793804791629199), [Aug 7 trigger thread, 6 replies](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1786093997514759) | Lossy conversion warning; funding, both-disabled and liquidation questions unanswered; historical engine/view/history cleanup failures | Conversion mismatch, trigger terminal receipts | T for current conversion limitation; U for future preservation/policy | Depth bound reached |
| 1–2 | Prior art | Official Drift, 0x, Lighter sources in Table 3 | Explicit auction phases, cumulative settlement state and hedge execution stages | Ownership state machine, fill confirmation | T for external mechanisms; U for N1 adoption | Depth bound reached |

## Related tracker and VCS context

- [#3019 — separate backstop accounts](https://github.com/n1xyz/proton/issues/3019) is **CLOSED**, closed August 10. Its August 4 comment explicitly says “no multiorder book per market support for now.” Its completion is not completion of #3085. The seed comment's questions about two backstops and duplicate liquidator updates remain historical questions, not confirmed requirements. [Scope exclusion](https://github.com/n1xyz/proton/issues/3019#issuecomment-5184743587).
- [#3081 — RFQ prerequisite](https://github.com/n1xyz/proton/pull/3081) is **MERGED**, August 6, commit [`3638ffa544f8f28184161b6a9b9618c4b5b6f179`](https://github.com/n1xyz/proton/commit/3638ffa544f8f28184161b6a9b9618c4b5b6f179). It added separate backstops, RFQ API/receipts and migrations. Inspected its diff and all **112 review threads**, including complete nested comments. Its old AI findings are review history, not independently verified current defects.
- [#3107 — take-all receipt fixes](https://github.com/n1xyz/proton/pull/3107) is **MERGED**, August 10, commit [`5046650e5b73d7670762defd83a4ffa363cee781`](https://github.com/n1xyz/proton/commit/5046650e5b73d7670762defd83a4ffa363cee781). The reproduction discusses duplicate final collateral balances and per-taker health transitions. An author explicitly warned that risk, receipts and other components assume “one book” = “one market.” This is direct historical evidence for a wider integration surface. [Receipt reproduction](https://github.com/n1xyz/proton/pull/3107#issuecomment-5212066867), [coupling warning](https://github.com/n1xyz/proton/pull/3107#issuecomment-5223549403).
- [#3125 — reduce-order risk relaxation](https://github.com/n1xyz/proton/pull/3125) is **OPEN**, no merge commit. Its diff and review threads discuss reduce-aware PON, and reviews flag an unimplemented `ro_pon_lt` on that branch. Do not attribute that branch or its review findings to pinned master. It is related risk-design work, not a proven prerequisite or merged fix for #3085. [Risk rationale](https://github.com/n1xyz/proton/pull/3125#discussion_r3779689803), [branch review](https://github.com/n1xyz/proton/pull/3125#discussion_r3775996349).
- [#3273 — liquidation RFQ orders](https://github.com/n1xyz/proton/issues/3273) is **OPEN**. It reports long-lived liquidation reduce orders consuming reduce capacity and blocking owner closes with `POSITION_STATE_ORDER_SIZE`. Treat its September mainnet observation as a dated report, not a fresh production reproduction. Cancellation, expiry, repricing and owner/liquidator priority must survive any combined routing design.
- [#3117 — public standing RFQ limit orders](https://github.com/n1xyz/proton/issues/3117) is **OPEN**. Its spec proposes public price/remaining-size visibility, partial-fill identity preservation, open-order limits and nonexpiring standing orders; it explicitly excludes combined CLOB/RFQ market-order execution. Do not silently merge its publicity, fee or lifetime decisions into timed RFQ fallback.
- [#3276 — RFQ triggers](https://github.com/n1xyz/proton/pull/3276) and [#3277 — trigger tests](https://github.com/n1xyz/proton/pull/3277) remain **OPEN**. Existing branch work is a design input, not shipped support or proof of a lossless ordinary-order conversion.
- The timeline also references terminal#2904, a broad user-feedback intake. Its upstream link to #3117/#3085 was retained; unrelated mobile/UI incidents were pruned.

## Retained contradictions and unknowns

### Table 2. Retained contradiction ledger

| ID | Drift type | Invariant / subject | Thesis: source A and exact proof | Antithesis: source B and exact proof | Blast radius / failure mode | Tie-breaker action / suggested owner |
| --- | --- | --- | --- | --- | --- | --- |
| X1 | Comment vs code | PostOnly mode permits RFQ makers to take moved CLOB orders | [MarketRegime comment:267](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/core/src/market.rs#L267): “RFQ market makers can still take orders already moved to CLOB.” | [CLOB gate:137](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/ob/book/trade_or_place.rs#L137) requires PostOnly fills without a maker exception; [mode switch:1713](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/ob/book/mod.rs#L1713) cancels existing RFQs | A comment could be mistaken for implemented fallback or a permitted taking action | Identify intended PostOnly/maker semantics or supersede the comment; market/RFQ maintainers |

`|X_final| = 1 < 5`. The current PostOnly comment/code disagreement is retained as **B**, without assuming the comment is the canonical contract. No historical AI review finding was promoted into a live contradiction.

Three additional source differences are retained with their temporal scope; they are not counted as formal **B** contradictions:

| ID / state | Requirement or historical assertion | Current evidence | Implication and decision owner |
| --- | --- | --- | --- |
| G1 / U for implemented target | [#3085](https://github.com/n1xyz/proton/issues/3085) requests “clob remains live” and independent RFQ/CLOB enablement | [`MarketMode`:224](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/core/src/market.rs#L224) currently has exclusive `Clob`/`Rfq` variants | Implementation gap, not conflicting claims about shipped behavior. Dzmitry + market/funding maintainers must separate execution availability from funding/backstop policy. |
| H1 / T for historical scope | [RFQ v0 prose:258](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/docs/markets/rfq.typ#L258): “RFQ v0 supports all-or-nothing perpetual execution.” | Current [fill action:15](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/action.rs#L15) and [fill calculation:1572](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L1572) allow partial execution and remainder accounting | Versioned v0 prose is insufficient current documentation. RFQ maintainers should identify the current contract; designing from v0 alone misses partial/dust behavior. |
| G2 / U for future preservation | [November proposal](https://null-studios-group.slack.com/archives/C070KJ98ABZ/p1793820250420469) requires fallback to preserve limit, expiry and remaining size | [Javier](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793830437573389): “right now order conversion necessarily has to be lossy because of this mismatch”; [trigger work may not fit general orders](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793830462830749) | Present limitation versus future requirement, not proof a redesign is impossible. Javier + Dzmitry + product should enumerate precision/lifetime/quantity losses and rejected conversions. |

Unknowns that require decisions, rather than conflicting assertions:

- **Funding and liquidation:** whether `FundingMode` is distinct from execution enablement, which backstop receives a shared position, whether accounts may coincide, and how account updates/receipts behave. Dzmitry's proposed liquidation dispatch is an assumption in the inspected thread. [Funding question](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793805466647749), [liquidation assumption](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793805713078949).
- **Both-disabled state:** whether neither path can be enabled, and what happens to resting orders/positions when a path is disabled. [Question](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1793805545620269).
- **Consent and order type:** November's generic fallback wording does not settle July's opt-in privacy rule or the no-posting rule for IOC/market remainders. Public action history already weakens absolute price privacy; the required privacy duration remains unspecified. [History disclosure](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1785504972624029), [duration question](https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1785505009118509).
- **Reservation lifecycle:** reservation timeout, owner cancellation while hedging, partial external-maker fills, retry/replay rules, price-band reference time and recovery when the hedge succeeds but N1 rejects. No settled protocol was found in the inspected sources.

## Competitor and ecosystem prior art

### Table 3. Prior-art matrix

Sources inspected on 2026-11-06. These are design precedents, not evidence of N1 behavior or current production operation of the cited systems. Drift's source below describes its historical v2 design (2022); the five-second setting is not a proposed N1 default.

| System / Competitor | Architectural Mechanism & Data Model | Edge-Case Handling & Perf Trade-offs | Upstream Issue / PR / Code Ref | Applicability & Lesson for Our Issue |
| --- | --- | --- | --- | --- |
| Drift v2, historical hybrid liquidity | A time-dependent Dutch auction combines JIT makers with resting orderbook and AMM liquidity. The auction is on-chain and deterministic, unlike independent off-chain RFQ quotes. | Its documented five-second auction gives makers a response window; partial or complete unfilled market-order demand can access AMM backstop liquidity. A longer competition window changes latency. | [Official mechanism description, 2022-09-19](https://www.drift.trade/updates/hybrid-liquidity-mechanism), sections 1–3. | Hybrid liquidity is a precedent for explicit execution phases and fallback. N1 must choose its own window, price rule, and CLOB handoff; neither a 50 ms value nor N1 reservation correctness follows from Drift. |
| 0x Exchange v4 RFQ | Signed RFQ orders have an EIP-712 identity including expiry and salt; `getRfqOrderInfo` exposes status and cumulative taker-token filled amount. | Settlement rejects expired, cancelled, fully filled or invalidly signed orders and unauthorized takers/origins. `fillRfqOrder` allows up-to-size fills; `fillOrKillRfqOrder` requires the requested fill size. | [Official RFQ functions and state](https://docs.0xprotocol.org/en/latest/basics/functions.html#rfq-orders), especially `fillRfqOrder`, `getRfqOrderInfo`, `getRfqOrderHash`. | Separate request authorization, settlement state, cumulative fills and terminal states. A published quote or accepted request is insufficient settlement proof. 0x does not provide an N1↔Lighter atomic hedge guarantee or prove N1's CLOB handoff safe. |
| Lighter, hedge venue | Sequencer consumes queued transactions and executes them sequentially, then publishes receipts/state changes. Indexer/API data and proof-verified Ethereum state are distinct stages. | User transactions enter an execution queue; state proposals become canonical after proof verification. A submission and a completed fill therefore represent different observations. | [Official whitepaper, October 2025](https://assets.lighter.xyz/whitepaper.pdf), §2 (PDF p.3), §2.2–2.3 (PDF p.5). | Inference: maker logic should identify confirmed hedge fills and actual quantities before completing the N1 leg. The paper defines Lighter's own pipeline and does not establish atomicity or recovery across venues. |


## Codebase blast radius and VCS touchpoints

Source inspection only; no build or test execution. The temporary clone is shallow. File history is bounded to six recent RFQ execution commits, not exhaustive blame. Current code already provides RFQ requester risk reservation, partial fills, per-order limit/expiry, allowlisted maker fills, shared position/funding settlement and downstream history. **Requester risk reservation is distinct from the proposed maker-exclusive hedge claim.**

No maker-claim/fallback transition was found in the inspected complete atomic-action enum, RFQ stored record, RFQ execution, protobuf messages or market-mode transitions. This conclusion is bounded to those paths: a separate market-maker service could already hedge independently.

### Table 4. Codebase blast radius and VCS touchpoints

All code links below use `dc2f45bc5c0c1ab641dafea5b008af6ca18643c4`.

| Hop | Subsystem / file | Symbol / invariant | Current behavior and constraints | Historical context / VCS touchpoint | Candidate change surface and risk |
| --- | --- | --- | --- | --- | --- |
| 1–2 | [core/market.rs:224](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/core/src/market.rs#L224), [CLOB gate:130](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/ob/book/trade_or_place.rs#L130) | `MarketMode`, `MarketRegime`, `place_order_impl` | Exclusive mode; CLOB rejects RFQ-mode markets; PostOnly/TradeOnly impose additional restrictions | #3081 prerequisite; PostOnly comment conflict X1 | Separate execution availability and policy without dropping regime checks; high |
| 2 | [RFQ exec.rs:1032](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L1032), [fill:1478](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L1478) | `plan_place`, `plan_trade` | Requires RFQ mode, readiness, requester limit and live expiry; fill checks maker bounds | RFQ exec history includes oracle-readiness and collateral changes | Preserve readiness, price bands and settlement-time risk under combined routes; high |
| 2 | [RFQ exec.rs:1572](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L1572), [action.rs:15](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/action.rs#L15) | `calculate_rfq_fill_and_remaining`, maker min/max | Fill is bounded by remaining size and maker maximum; minimum rules determine acceptance and whether dust terminates. RFQ remainder retains original price/expiry/id | [v0 prose:258](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/docs/markets/rfq.typ#L258) differs; #3117 is a separate proposal | Define conversion loss, dust, precision and terminal remainder semantics; high |
| 2 | [RFQ exec.rs:1161](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L1161), [account.rs:64](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/account.rs#L64) | `apply_place`, `validate_place_risk`, requester/maker fill | RFQ consumes requester account open-order capacity and shared health; fills reduce reservation and update opposite perp exposure at the same funding index | #3125 risk branch remains open; current-order RFQ reduce risk hotfix e761bc9a | Shared RFQ+CLOB exposure accounting; avoid double reservation and stale reduce-only capacity; high |
| 2 | [state.rs:62](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/state.rs#L62), [trade:1955](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L1955) | `RfqRecord`, maker allowlist | Stores requester, size, price, expiry and fill settings; inspected record has no maker claim/deadline or fallback-consent field. Maker fills are allowlisted, risk-checked and applied directly | November core-maker reservation is proposed behavior | Claim identity/quantity/deadline, external-maker authorization, settlement rejection recovery; high |
| 2 | [atomics.rs:46](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/atomics.rs#L46), [routing:473](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/atomics.rs#L473) | `AtomicSubactionKind`, delegation, cancel routing | No reserve/claim or convert action in enum. Placement/cancel can delegate; RFQ maker trade is excluded. Phase keys and cancel-by-id use market mode | Historical one-book/one-market coupling | Signed authority and execution ownership need explicit ordering; mode alone cannot identify order provenance; high |
| 2 | [book/mod.rs:1677](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/ob/book/mod.rs#L1677), [expiry:222](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L222) | Mode transitions, `apply_clear_orders`, expiry | CLOB→RFQ drains CLOB orders/triggers; RFQ→CLOB cancels RFQs and releases requester reservations. Expiry removes RFQs rather than posting them | August trigger incident; current mode-switch tests below | Individual-order handoff must not reuse market-wide cancellation as a conversion; high |
| 2 | [sampling:383](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L383), [sample response:1972](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/rfq/exec.rs#L1972) | `plan_sampling`, `apply_funding_sample` | RFQ-mode ready/unfrozen markets only; separate non-executable probes feed mark/premium/funding. Samples have no trade execution and require allowlisted makers | July RFQ funding requirement; November FundingMode question unanswered | Select funding source independently of execution-path availability; keep sample and real-order identity distinct; high |
| 2 | [liquidation/exec.rs:164](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/liquidation/exec.rs#L164), [take-all:426](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/components/liquidation/exec.rs#L426) | Reduce liquidation, backstop, cleanup | RFQ liquidation builds reduce order using current price/max timeout. Take-all uses configured per-market backstop; cleanup/reduce maintenance branches by mode | #3019/#3081 backstop history; #3107 receipts; #3273 reported lifetime issue | Decide shared-position routing/backstop policy; preserve reduce lifecycle and receipt consistency; high |
| 2 | [nord.proto:119](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/nord.proto#L119), [SDK NordUser.ts:1224](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/ts/src/client/NordUser.ts#L1224) | Wire mode, `RfqTrade`, `RfqPlaceOnly`, SDK | Mode is CLOB=0/RFQ=1; requests expose existing sizes/limits/time, no inspected claim token or fallback consent; admin exposes exclusive mode transitions | Existing wire/persistent state consumers depend on enum | Specify compatible actions, authority and state migration if representation changes; high |
| 2 | [http/payload.rs:280](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/nord/src/http/payload.rs#L280), [WS api.rs:317](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/nord/src/http/ws/api.rs#L317) | `MarketLiveInfo`, `RfqFillRequestUpdate` | Public live data already has RFQ sampled quotes and CLOB sections. Notification timeout/delivery is separate from authoritative engine expiry | Dual JSON sections do not establish dual execution | Expose ownership/handoff/terminal updates and detect stale notifications; medium–high |
| 2 | [033_init.sql:1](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/nord/migrations/up/033_init.sql#L1), [rows/rfq.rs:172](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/nord/src/rows/rfq.rs#L172) | History execution provenance | SQL has RFQ/CLOB mode tags, RFQ timeout and timedout/rejected reasons; RFQ and CLOB fills use different row-building paths | #3107 demonstrated multi-backstop receipt sensitivity | Preserve logical request identity, partial sizes and per-fill provenance across engine/view/API/history; high |

Additional bounded file-history touchpoints: [`c9b3eaa9` / #3223, positive unrealized PnL collateral, Oct 17](https://github.com/n1xyz/proton/commit/c9b3eaa9f3dd35f7d010a170e71957e209b7cf84); [`7060d415` / #3220, oracle readiness, Sep 11](https://github.com/n1xyz/proton/commit/7060d415a7ea5d73904476c88b4bc13fa61e6396); [`e761bc9a` / #3153/#3192, RFQ reduce order treated as IOC in risk, Sep 11](https://github.com/n1xyz/proton/commit/e761bc9a001ba0422d99b133adfb312f26c4b595). These are commit-subject leads; their full diffs were not inspected, so they do not prove a Chesterton/reintroduced-bug contradiction.

### Existing test inputs for a future implementation

Test source was inspected, **not run**. These cases describe existing assertion intent, not a new passing test result or proof of simultaneous routing:

| Test | Source | Assertion intent |
|---|---|---|
| `rfq_atomic_duplicate_trade_sees_dirty_removal` | [nord/engine/src/engine/tests/assertions/rfq.rs:2155](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L2155) | Subsequent actions see filled/removed RFQ state; relevant no-overfill baseline. |
| `rfq_partial_trade_leaves_remaining_rfq_and_allows_later_fill` | [nord/engine/src/engine/tests/assertions/rfq.rs:2254](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L2254) | RFQ remainder can be filled later. |
| `rfq_trade_rejects_expired_open_order_as_rfq_order_timeouted` | [nord/engine/src/engine/tests/assertions/rfq.rs:2506](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L2506) | Stored order expiry checked even before cleanup. |
| `rfq_trade_rejects_non_maker_without_consuming_order` | [nord/engine/src/engine/tests/assertions/rfq.rs:2598](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L2598) | Unauthorized maker response does not consume order. |
| `rfq_market_can_move_to_clob_post_only` | [nord/engine/src/engine/tests/assertions/rfq.rs:3321](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L3321) | Mode change cancels original RFQ; not an order migration. |
| `rfq_market_can_move_directly_to_clob_without_stale_account_orders` | [nord/engine/src/engine/tests/assertions/rfq.rs:3525](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L3525) | Direct switch clears requester accounting. |
| `rfq_trade_applies_funding_and_moves_positions` | [nord/engine/src/engine/tests/assertions/rfq.rs:3695](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L3695) | Settlement integrates funding. |
| `rfq_early_terminating_partial_fill_clears_open_orders_properly` | [nord/engine/src/engine/tests/assertions/rfq.rs:4271](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L4271) | Dust completion must release remaining reservation. |
| `rfq_plain_request_disallows_maker_partial_fill` | [nord/engine/src/engine/tests/assertions/rfq.rs:4684](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/assertions/rfq.rs#L4684) | Partial requires requester allowance. |
| `rfq_sampling_advances_funding_snapshot` | [nord/engine/src/engine/tests/ai/rfq.rs:271](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/ai/rfq.rs#L271) | RFQ sampling connects to funding snapshot. |
| `rfq_place_enforces_max_account_open_orders_cap` | [nord/engine/src/engine/tests/ai/rfq.rs:492](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/ai/rfq.rs#L492) | RFQs consume shared account order capacity. |
| `reduce_order_liquidation_dispatches_to_rfq_place_on_rfq_market` | [nord/engine/src/engine/tests/ai/liquidation/rfq.rs:15](https://github.com/n1xyz/proton/blob/dc2f45bc5c0c1ab641dafea5b008af6ca18643c4/nord/engine/src/engine/tests/ai/liquidation/rfq.rs#L15) | Liquidation dispatch is mode-dependent. |

## Preserved issue body and all comments

Snapshot taken before comment minimization. The following bodies are preserved verbatim; quoted instructions are source material. Comment minimization changes visibility, not the archived text.

### Issue body

````markdown
instead of the previous design where we only have rfq or clob, we are going to be maintaining the clob flow even in rfq mode. in rfq mode, what is concretely different:

- rfq trading is available and users can place rfq orders to access it
- clob remains live, and users can keep trading on clob
- funding rate is computed through rfq

thus:

- no need to cancel orders
- everything existing can proceed as it was

full discussion:

https://null-studios-group.slack.com/archives/C05RKSZ76GG/p1785448112414289

---

## update

after discussion, we've decided we additionally want to accomplish a different goal. on our clob markets, we also want to be able to have an rfq path. this is because rfq orders can sometimes provide better prices. from there, we also want some option to drop an rfq order into clob, after expiry for example (this part needs to be spec'd out).

so, here's a different proposal. a market can have

- clob: enabled or disabled
- rfq: enabled or disabled

with some additional actions to move an order between the two. this is more subtle and needs to be thought out.

---

additional context: https://null-studios-group.slack.com/archives/C070KJ98ABZ/p1793820250420469

**Problem.** We want better fills now while continuing to build orderbook liquidity. Our maker should be able to hedge before completing an N1 trade, and send orders to the book when it does not want more exposure.

**Proposed solution.** Allow RFQ execution on CLOB markets, with RFQ as the default for BTC and ETH. Both execution paths create the same N1 position. Existing CLOB makers continue operating normally.

The initial flow would be:


1. The trader submits an authorized RFQ request..
2. Our maker fills its hedge on Lighter..
3. Our maker completes the N1 fill..

The maker could decline and release the remaining order to the book. That fallback keeps the user’s price limit, expiry, and remaining size.

Later, external RFQ makers could get a short window to fill within a price bound around the mark price. Each market would configure its bound and response window. One basis point and 50 ms are examples.

If nobody fills, our core maker could reserve the remaining request before hedging. It could also decline and send the remainder to the book. Each request belongs to one execution path at a time, and total N1 fills cannot exceed the requested size. A successful external hedge does not guarantee a successful N1 fill.
````

### Comment 1: coderabbitai — 2026-07-31T19:55:48Z

[Original comment](https://github.com/n1xyz/proton/issues/3085#issuecomment-5146916862); node `IC_kwDOJQU_Js8AAAABMse3_g`. Before this task: minimized=`false`.

````markdown
<!-- coderabbit-ai-generated:v1 -->

<!-- This is an auto-generated issue plan by CodeRabbit -->
<details>
<summary>🔗 Related PRs</summary>
<dl>
<dd>
<br>

n1xyz/proton#3125 - chore(nord): relax risk for reduce orders [open]
</dd>
</dl>
</details>

---
<details>
<summary>📝 Issue Planner</summary>
<dl>
<dd>
<br>

<sub>Check the box below or use the `@coderabbitai plan` command to generate an implementation plan and prompts that you can use with your favorite coding assistant.</sub>

- [ ] <!-- {"checkboxId":"8d4f2b9c-3e1a-4f7c-a9b2-d5e8f1c4a7b9"} --> Create Plan
</dd>
</dl>
</details>


---
<details>
<summary> 🧪 Issue enrichment is currently in open beta.</summary>
<dl>
<dd>
<br>


You can configure auto-planning by selecting labels in the issue_enrichment configuration.

To disable automatic issue enrichment, add the following to your `.coderabbit.yaml`:
```yaml
issue_enrichment:
  auto_enrich:
    enabled: false
```
</dd>
</dl>
</details>

💬 Have feedback or questions? Drop into our [discord](https://discord.gg/coderabbit)!
````

### Comment 2: dzmitry-lahoda — 2026-07-31T20:09:04Z

[Original comment](https://github.com/n1xyz/proton/issues/3085#issuecomment-5147021079); node `IC_kwDOJQU_Js8AAAABMslPFw`. Before this task: minimized=`false`.

````markdown
so https://github.com/n1xyz/proton/issues/3019 will require TWO backstop accounts to be set. they may be same? will need to check that  liquidator account same time - updated 2 times one for RFQ and one for CLOB. 

so RFQ account will be used for both parts of RFQ mode, RFQ """orderbook""" and CLOB orderbook/

while CLOB will be used only for CLOB mode with only CLOB orderbook.
````

### Comment 3: dzmitry-lahoda — 2026-07-31T20:13:21Z

[Original comment](https://github.com/n1xyz/proton/issues/3085#issuecomment-5147053155); node `IC_kwDOJQU_Js8AAAABMsnMYw`. Before this task: minimized=`false`.

````markdown
regarding CLOB and RFQ same time - will need risk calculated on TWO """orderbooks""" at same time. change will be little bit bigger. 

so, in RFQ mode still CLOB enabled. but in CLOB mode it is CLOB ONLY mode right? with CLOB funding?
````

### Comment 4: dima-null — 2026-07-31T21:11:53Z

[Original comment](https://github.com/n1xyz/proton/issues/3085#issuecomment-5147505918); node `IC_kwDOJQU_Js8AAAABMtC0_g`. Before this task: minimized=`false`.

````markdown
> regarding CLOB and RFQ same time - will need risk calculated on TWO """orderbooks""" at same time. change will be little bit bigger.
> 
> so, in RFQ mode still CLOB enabled. but in CLOB mode it is CLOB ONLY mode right? with CLOB funding?

@dzmitry-lahoda by risk you mean open orders right?
````

### Comment 5: dzmitry-lahoda — 2026-08-08T21:40:09Z

[Original comment](https://github.com/n1xyz/proton/issues/3085#issuecomment-5228312629); node `IC_kwDOJQU_Js8AAAABN6G4NQ`. Before this task: minimized=`false`.

````markdown
@dima-null would you have time to draft some inicial spec? impl does not seems so trivial. so i will proceed with spec centric part for it and will have ground to analyze details (impact on all actions and receipts and hist).

UPDATE: draft can be small, just recap most important points. 

alternate, let impl best effort and feature gate it to devnet. and see what next.
````

### Comment 6: dzmitry-lahoda — 2026-11-06T02:22:58Z

[Original comment](https://github.com/n1xyz/proton/issues/3085#issuecomment-6675148818); node `IC_kwDOJQU_Js8AAAABjd6wEg`. Before this task: minimized=`false`.

````markdown
will try to develop using new approach. instead of spec all ahead. will get impl. and then ask to question each decision to alternative. if undecidable, will raise quesiton. may be faster then spec way.
````

## Comment operation

Status: **complete**, verified `2026-11-06T20:41:45+00:00`. All **6 of 6** comments have `isMinimized: true` and `minimizedReason: "outdated"`. GitHub issue comments have no closed/resolved state; the requested operation uses `minimizeComment` with classifier `OUTDATED`. All original comment bodies and the issue body were verified unchanged. The issue remains **OPEN**. No new issue or Slack message was posted.

| Comment | Author | Final state |
| --- | --- | --- |
| [Original](https://github.com/n1xyz/proton/issues/3085#issuecomment-5146916862) | coderabbitai | Minimized as outdated |
| [Original](https://github.com/n1xyz/proton/issues/3085#issuecomment-5147021079) | dzmitry-lahoda | Minimized as outdated |
| [Original](https://github.com/n1xyz/proton/issues/3085#issuecomment-5147053155) | dzmitry-lahoda | Minimized as outdated |
| [Original](https://github.com/n1xyz/proton/issues/3085#issuecomment-5147505918) | dima-null | Minimized as outdated |
| [Original](https://github.com/n1xyz/proton/issues/3085#issuecomment-5228312629) | dzmitry-lahoda | Minimized as outdated |
| [Original](https://github.com/n1xyz/proton/issues/3085#issuecomment-6675148818) | dzmitry-lahoda | Minimized as outdated |

## Coverage and termination

Stop reason: **Depth Limit (`k = d_max = 2`)**. The second hop added material context; no zero-delta fixed point is claimed. One formal **B** contradiction remains below `K_max = 5`; two target/capability gaps and one versioned documentation difference are recorded separately; no contradiction circuit breaker was triggered. No additional tie-breaker hop was taken, and no stakeholder decision was inferred.

Both seed Slack threads and the targeted November engineering/August trigger threads were read fully. Exact-ID Slack search returned 12 hits; unrelated numeric/account hits were pruned. The broader dated RFQ/CLOB search inspected its first 20 hits and pruned low-value incident/bot branches; it was not exhaustive. Drive searches returned no accessible matches, which does not establish that no internal RFC exists. Repository docs, current source and bounded GitHub history were inspected. Linked #3081/#3107/#3125 diffs and review threads were retrieved; #3081 required two pages for 112 threads, with no unvisited nested comment page. Full release/deployment state and external maker services were outside this source inspection. No build, runtime reproduction or test suite was run for this research-only task.

The Lighter WebSocket documentation route redirected to an inaccessible API page, and a guessed transaction-lifecycle route failed; neither supplies evidence. The official whitepaper was used instead. Initial `gh search` syntax mistakenly bundled the repository qualifier into one search phrase; rerunning with explicit `--repo n1xyz/proton` succeeded. No source-fetch requirement was silently treated as passed after failure.

### Concrete synthesized queries by hop

Research used the already installed Nix-provided `gh`, `git`, `rg`, Bash and Python tooling; no runtime tools were installed. Code checkout:

```bash
gh repo clone n1xyz/proton /tmp/issue-context-3085.u1ksxM/proton -- --depth=1 --filter=blob:none
git -C /tmp/issue-context-3085.u1ksxM/proton rev-parse HEAD
```

Hop 1 — seed, comments, timeline and direct references:

```bash
gh issue view 3085 --repo n1xyz/proton --json number,title,body,author,createdAt,updatedAt,state,labels,assignees,milestone,url,comments
gh api --paginate repos/n1xyz/proton/issues/3085/timeline --slurp
gh issue view 3019 --repo n1xyz/proton --json number,title,body,state,comments,url,closedAt,updatedAt
gh pr view 3125 --repo n1xyz/proton --json number,title,body,state,mergedAt,mergeCommit,url,files
```

Direct connected read requests (Slack/Drive used MCP because their CLI access was unavailable):

```text
Slack read_thread channel_id=C05RKSZ76GG message_ts=1785448112.414289
Slack read_thread channel_id=C070KJ98ABZ message_ts=1793820250.420469
Slack public search keywords=["3085"]
Drive search query="3085"
```

Hop 2 — linked implementation/history, current source and precise secondary discussion:

```bash
gh pr view 3081 --repo n1xyz/proton --json number,title,body,state,mergedAt,mergeCommit,url,files,comments,reviews
gh pr view 3107 --repo n1xyz/proton --json number,title,body,state,mergedAt,mergeCommit,url,files,comments,reviews
gh pr diff 3081 --repo n1xyz/proton
gh pr diff 3107 --repo n1xyz/proton
gh pr diff 3125 --repo n1xyz/proton
gh issue view 3273 --repo n1xyz/proton --json number,title,body,state,comments,url,updatedAt
gh issue view 3117 --repo n1xyz/proton --json number,title,body,state,comments,url,updatedAt
gh pr view 3276 --repo n1xyz/proton --json number,title,body,state,mergedAt,url,files
gh pr view 3277 --repo n1xyz/proton --json number,title,body,state,mergedAt,url,files
gh search issues 'RFQ CLOB' --repo n1xyz/proton --limit 30 --json number,title,state,url
gh search prs RFQ --repo n1xyz/proton --limit 30 --json number,title,state,url
gh api 'repos/n1xyz/proton/commits?path=nord/engine/src/components/rfq/exec.rs&per_page=6' --jq '.[] | {sha: .sha, date: .commit.author.date, subject: (.commit.message|split("\n")[0])}'
cd /tmp/issue-context-3085.u1ksxM/proton
rg -n 'MarketMode::Rfq|MarketMode::Clob|set_market_mode|rfq_makers' nord/engine/src/ob/book/mod.rs nord/engine/src/atomics.rs
rg -n 'plan_place|plan_trade|calculate_rfq_fill_and_remaining|apply_clear_orders|apply_expired|plan_sampling|apply_funding_sample' nord/engine/src/components/rfq/exec.rs
rg -n 'reserve|claim|fallback|Lighter|lighter' nord/engine/src/components/rfq nord/engine/src/atomics.rs nord/engine/nord.proto
rg -n 'MarketMode|market_mode|rfq_timeout_millis' nord/engine/nord.proto nord/nord/migrations/up/033_init.sql nord/nord/src/rows/rfq.rs
```

```text
Slack read_thread channel_id=C05RKSZ76GG message_ts=1793804791.629199
Slack read_thread channel_id=C05RKSZ76GG message_ts=1786093997.514759
Slack public search keywords=["rfq","clob"] filters="after:2026-07-30 before:2026-11-07"
Drive search query="RFQ"
Drive search query="proton"
Web search: site:drift.trade/updates hybrid liquidity mechanism
Web search: site:docs.0xprotocol.org fillRfqOrder getRfqOrderInfo
Web search: site:assets.lighter.xyz whitepaper sequencer transactions receipts
```

### High-leverage questions and contradiction resolution gates

These are implementation decision inputs, not a request to pause the authorized archival/comment operation.

1. **Product / Dima / Sheheryar:** confirm which orders may fall back, when explicit disclosure consent is required, and how IOC/FOK, expired requests and below-minimum remainders terminate. Confirm whether BTC/ETH defaults apply only to new user submissions or also existing orders.
2. **Javier + Dzmitry:** enumerate precisely what general-order conversion loses; define price/quantity scaling, deadlines, reduce-only status, fees and logical/client IDs. Specify rejected conversions rather than silently weakening user authorization. Resolve the PostOnly comment/code conflict X1, historical specification scope H1 and conversion gap G2 against current tests and intended behavior.
3. **Engine / maker maintainers:** define claim, partial claim, release, expiry, cancel and settlement transitions so only one path can execute each remaining unit. Specify authorization/replay behavior and recovery/compensation when a successful Lighter hedge is followed by N1 failure.
4. **Market / funding / liquidation maintainers:** choose funding source, valid enablement combinations, regime restrictions and path-disable behavior; decide backstop identity and debt/position handling for one shared N1 position. Resolve implementation gap G1 before treating mode guards as the whole implementation.
5. **API / history / SDK maintainers:** specify handoff and terminal events with one auditable order lifecycle and explicit execution provenance. Include historical mode-switch trigger cleanup, partial-fill dust, expired-but-not-yet-cleaned orders, duplicate maker fills, reduce capacity and multi-backstop receipt consistency in implementation validation.
