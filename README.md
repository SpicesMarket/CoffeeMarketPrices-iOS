# Coffee Prices

[![Tests](https://github.com/SpicesMarket/CoffeeMarketPrices-iOS/actions/workflows/tests.yml/badge.svg?branch=master)](https://github.com/SpicesMarket/CoffeeMarketPrices-iOS/actions/workflows/tests.yml)

A native iOS port of the Android **Coffee Prices** app — a single-screen, read-only view of the latest Indian commodity market prices (Arabica/Robusta coffee variants and pepper).

The Android original is the source of truth for product/visual/behavior parity. See [`iOS_CLONE_PROMPT.md`](./iOS_CLONE_PROMPT.md) for the full clone spec.

---

## Features

- Splash screen with a shared-element logo handoff into the main screen (`matchedGeometryEffect`).
- Single `GET /prices/latest` call on launch, with a spinner while in flight.
- Sorted, formatted price list with up / down / flat trend indicators.
- Locale-aware "Last Updated" timestamp pulled from the first row.

---

## Architecture

MVVM + Swift Concurrency. UI is SwiftUI; the prices screen is driven by a single `PricesState` struct exposed by `PricesViewModel`.

```
View                  ←  reads only  →   @Published state: PricesState
  │
  │ lifecycle / user event
  ▼
ViewModel  ── async ─→  CoffeePricesAPI (protocol)
                              │
                              ▼
                        Alamofire (LiveCoffeePricesAPI)
                              │
                              ▼
                        JSON DTO  ── Mapper (off-main) ──→ UI Model
```

Key design decisions:

- **Single state object.** `PricesViewModel` exposes one `@Published private(set) var state: PricesState`. The view reads `state.isLoading`, `state.ui.rows`, `state.ui.lastUpdatedText` — nothing else.
- **DTO ⟂ UI model.** Network types (`PricesResponse`, `PriceItem`) are kept separate from rendering types (`PricesUIModel`, `PriceRowUI`). A pure `PricesMapper` converts between them.
- **Off-main mapping.** Sorting, DTO → UI conversion, and date string formatting all run on a `Task.detached(priority: .userInitiated)` so the main actor only assigns the finished `PricesUIModel`.
- **Injected dependencies.** `PricesViewModel.init(api:mapper:)` takes both the API and the mapper as parameters with production defaults — the view model has no knowledge of Alamofire, JSON, or `DateFormatter`.
- **Silent failure.** Network errors are logged but do not surface in the UI, matching the Android original.

---

## Project structure

```
CoffeePrices/
  CoffeePricesApp.swift           # @main entry
  RootView.swift                  # splash → prices coordinator
  Features/
    Splash/
      SplashView.swift
    Prices/
      PricesView.swift
      PriceRowView.swift
      PricesViewModel.swift       # state holder, async loader
      PricesUIModel.swift         # PriceRowUI, PricesUIModel
      PricesMapper.swift          # DTO → UI, runs off-main
  Networking/
    CoffeePricesAPI.swift         # protocol (the seam for tests)
    LiveCoffeePricesAPI.swift     # Alamofire implementation
  Models/
    PriceItem.swift               # DTO
    PricesResponse.swift          # DTO
  Resources/
    Theme.swift                   # color palette
    CoffeeBeanLogo.swift          # SwiftUI Shape-based logo
  Assets.xcassets/

CoffeePricesTests/
  Doubles/
    FakeCoffeePricesAPI.swift     # programmable test double
    SampleData.swift              # canonical response fixture
  PricesMapperTests.swift
  PricesViewModelTests.swift
```

---

## Tech stack

| | |
|-|-|
| Language | Swift 5 (`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`) |
| UI | SwiftUI |
| Concurrency | `async`/`await`, `Task`, `Task.detached` |
| Networking | [Alamofire](https://github.com/Alamofire/Alamofire) 5.10+ via SPM |
| Tests | Swift Testing (`@Suite`, `@Test`, `#expect`) |
| Tooling | Xcode 26.3, iOS 26.2 deployment target |
| Orientation | iPhone portrait |

---

## API

| | |
|-|-|
| Base URL | `https://cropmarketprices-production.up.railway.app` |
| Endpoint | `GET /prices/latest` |
| Auth | none |
| Timeout | 60s |
| Date format | `yyyy-MM-dd'T'HH:mm:ss.SSSZ` (ISO 8601 w/ ms + tz) |

---

## Getting started

Open the project in Xcode and Run:

```bash
open CoffeePrices.xcodeproj
```

Or from the command line:

```bash
xcodebuild \
  -project CoffeePrices.xcodeproj \
  -scheme CoffeePrices \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

Alamofire is resolved automatically via Swift Package Manager on first build.

---

## Tests

```bash
xcodebuild \
  -project CoffeePrices.xcodeproj \
  -scheme CoffeePrices \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

**12 tests across two suites:**

- `PricesMapper` — DTO → UI field mapping, `status` → `Trend` translation, priority-ascending sort with `-1` default, `dd MMM yyyy hh:mm a` formatting, empty-data placeholder.
- `PricesViewModel` — initial empty state, success populates rows + clears `isLoading`, the injected mapper is honored, silent failure leaves UI state untouched, `loadIfNeeded()` is idempotent after success and retries after failure, `isLoading` flips during an in-flight request.

Tests use a `FakeCoffeePricesAPI` (programmable `Result` + delay + call counter) injected through the `CoffeePricesAPI` protocol — no real network calls.

### Continuous integration

GitHub Actions runs the suite on every push and PR to `master` (`.github/workflows/tests.yml`):

- macOS 15 runner with the latest stable Xcode (via `maxim-lobanov/setup-xcode`).
- SwiftPM dependencies cached against `Package.resolved`.
- `xcodebuild test` against `iPhone 16` / iOS Simulator (latest), with code coverage on.
- The `.xcresult` bundle is uploaded as a workflow artifact; `xcodebuild.log` is attached on failure.

---

## Out of scope

Mirroring the Android source: no settings screen, no detail view, no search/filter, no pull-to-refresh, no offline cache, no analytics, no in-app updates. App Store handles updates externally.
