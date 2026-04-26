# iOS Clone Instruction Prompt — "Coffee Prices"

You are building a native iOS app that is a 1:1 clone of an existing Android app called **Coffee Prices**. Follow this spec exactly. The goal is feature parity, visual parity, and behavior parity — not a re-imagination.

---

## 1. App identity

- **Display name:** `Coffee Prices`
- **Bundle identifier (suggested):** `tk.mohithaiyappa.coffeeprices` (mirror Android `applicationId`); use `com.<yourorg>.coffeeprices` if Apple namespace requires it.
- **Marketing version:** start at `1.9.3` to match the Android version line.
- **Build number:** `25`.
- **Deep link host (Universal Link):** `http://coffeeprices.com` — the Android manifest registers an implicit VIEW intent for this host. iOS equivalent is a Universal Link (Associated Domain `applinks:coffeeprices.com`). Open the main screen on tap; no separate routing logic is required since there is only one screen.
- **Required network access:** standard outbound HTTPS to the API host below. No location, camera, or notifications.

---

## 2. What the app does (product spec)

The app shows the latest market prices for five Indian commodities (Arabica/Robusta coffee variants and pepper). It is a single-screen, read-only app:

1. On launch, show a **splash screen** with a centered coffee-bean logo. The logo fades in (`alpha 0 → 1` over **600 ms**), then after **1 second total** the app transitions to the main screen.
2. The transition from splash → main is a **shared-element animation** on the logo (the same logo image continues from splash into the main screen's top-left position). On iOS use a custom `UIViewControllerAnimatedTransitioning` with a matched-geometry effect, or a SwiftUI `matchedGeometryEffect`.
3. The **main screen** fetches `GET /prices/latest`, shows a spinner while loading, then renders a vertical list of price rows. A header reads `Prices` with a `Last Updated : <date>` line beneath it and the logo to the left of the header.
4. Each row shows: **commodity name** on the left, a **trend arrow** in the middle, **price string** on the right.
5. Pressing the system back gesture (or swipe-down on a modal-style presentation) finishes the app on Android via `finish()`. On iOS the equivalent is just dismissing — there is only one main screen, so no back navigation to design.

There is **no settings screen, no detail screen, no search, no filtering, no pull-to-refresh** in the Android source. Do **not** add them. (You may add pull-to-refresh as a small ergonomic improvement since iOS users expect it — but flag it as an addition, not a port.)

---

## 3. Backend / API contract

- **Base URL:** `https://cropmarketprices-production.up.railway.app/`
- **Endpoint:** `GET prices/latest`
- **Auth:** none. Plain HTTPS GET.
- **Read timeout:** 60 seconds (matches Android `OkHttpClient.readTimeout(60, SECONDS)`).
- **Date format on the wire:** `yyyy-MM-dd'T'HH:mm:ss.SSSZ` (ISO 8601 with milliseconds and timezone). Use `ISO8601DateFormatter` with `.withFractionalSeconds` or a custom `DateFormatter` with that pattern.

### Sample response (real, captured from production)

```json
{
  "status": "success",
  "data": [
    { "spiceName": "Arabica Parchment", "spiceCost": "₹27,000-28,000", "average": 27500, "status": 0, "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z" },
    { "spiceName": "Arabica Cherry",    "spiceCost": "₹14,000-16,300", "average": 15150, "status": 0, "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z" },
    { "spiceName": "Robusta Parchment", "spiceCost": "₹17,500-18,500", "average": 18000, "status": 0, "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z" },
    { "spiceName": "Robusta Cherry",    "spiceCost": "₹11,500-12,750", "average": 12125, "status": 0, "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z" },
    { "spiceName": "Pepper",            "spiceCost": "₹675",          "average": 675,   "status": 0, "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z" }
  ]
}
```

### Field semantics

| Field         | Type    | Notes                                                                                  |
|---------------|---------|----------------------------------------------------------------------------------------|
| `spiceName`   | String  | Display label. Render as-is.                                                           |
| `spiceCost`   | String  | Pre-formatted price, may be a single value (`₹675`) or a range (`₹27,000-28,000`).     |
| `average`     | Int     | Numeric average. **Not displayed** in current UI — keep on the model for future use.   |
| `status`      | Int     | Trend indicator. `1` = up (green ▲), `-1` = down (red ▼), `0` or other = unchanged (gray ▶). |
| `priceDiff`   | Int     | Returned by API; **not displayed**. Keep on the model.                                 |
| `scrappedAt`  | Date    | Server-side scrape timestamp (UTC). The first row's `scrappedAt` is shown as "Last Updated".|
| `_id`, `__v`  | String/Int | Mongo-ish metadata. Decode and ignore.                                              |
| `priority`    | Int     | Sort key (asc). May be missing on this endpoint; default to `-1`. Sort the list before rendering.|

### Display rules

- Sort items by `priority` ascending before rendering (Android: `it.mData.sortedBy { it.priority }`).
- "Last Updated" label format: `Last Updated : dd MMM yyyy hh:mm a` (e.g. `Last Updated : 16 Sep 2025 04:15 AM`). Source = `data[0].scrappedAt`. Use the device locale's calendar but the fixed format string. If the date is missing or parsing fails, leave the placeholder `Last Updated : --/--`.
- If the request fails, hide the spinner and leave the list empty. The Android app does not show an error UI — it just logs. **Do** add a non-intrusive error label or a retry on iOS only if you also propose it to the user; otherwise mirror the silent-failure behavior.

---

## 4. Visual design

All values come from the Android resources — match them exactly.

### Colors

| Role             | Hex        | Used for                                                  |
|------------------|------------|-----------------------------------------------------------|
| `colorPrimary`   | `#FEEAE6`  | Window/screen background (cream/peach).                   |
| `colorAccent`    | `#442C2E`  | Title, row labels, all primary text (dark brown).         |
| `colorPrimaryDark` | `#442C2E` | Status bar tint on Android. iOS: light-content status bar style on the cream background — actually, since the background is cream, use **dark-content** status bar style (default). |
| Trend up         | `#4CAF50`  | Up arrow fill.                                            |
| Trend down       | `#F44336`  | Down arrow fill (drawn at 0.8 alpha).                     |
| Trend unchanged  | `#9E9E9E`  | Sideways arrow fill.                                      |

### Typography

- System font (Android default = Roboto; iOS default = SF Pro is correct).
- **Title "Prices":** 36 sp → use `36 pt` (or `.system(size: 36)`), color `#442C2E`, centered horizontally, top margin `20 pt` from safe-area top.
- **"Last Updated" subtitle:** 12 sp → `12 pt`, color `#442C2E` (default text color).
- **Row labels (name + price):** default body size, color `#442C2E`, centered within their cell.

### Iconography

The Android app uses three vector drawables. Recreate as SF Symbols **or** as bundled SVG/PDF assets. SF Symbols equivalents are good enough:

| Android drawable    | Meaning   | iOS suggestion                                  | Color    |
|---------------------|-----------|-------------------------------------------------|----------|
| `ic_polygon_up`     | up ▲      | `arrowtriangle.up.fill` or custom triangle      | `#4CAF50` |
| `ic_polygon_down`   | down ▼    | `arrowtriangle.down.fill`                       | `#F44336` (alpha 0.8) |
| `ic_unchanged`      | unchanged | `arrowtriangle.right.fill`                      | `#9E9E9E` |

Sizes from Android: up/down icons are `11×10 dp`, unchanged is `10×11 dp`. Render around `11×11 pt`.

### Logo

The launcher/app logo is a stylized coffee bean rendered as an Android vector drawable. Re-export it as a PDF/SVG asset (or recreate manually). Key details:

- Two overlapping bean shapes, fill `#8D6E63`, stroke `#3E2723`, stroke width `10`, round line caps and joins.
- Decorative inner highlights at fill `#95000000`, `#70000000`, `#50000000` (semi-transparent black).
- Source viewport `250.987 × 239.012` — preserve aspect ratio.

This logo is used in **three** places: app icon (with adaptive background `#FEEAE6` matching `colorPrimary`), splash screen image, and the small image to the left of the "Prices" title on the main screen.

### Screens — layout

**Splash screen**
- Background: `#FEEAE6`.
- Single centered logo image. On appear, animate `opacity` from `0 → 1` over `0.6 s`. After `1.0 s` from screen appearance, push to MainScreen with a shared-element transition on the logo. The logo's destination on the main screen is the small position to the left of the "Prices" title (see main layout).

**Main screen**
- Background: `#FEEAE6`.
- Top header region:
  - "Prices" centered horizontally, top-margin `20 pt`.
  - Logo image on the **leading** edge with leading margin `24 pt`, square aspect ratio (`1:1`), top and bottom aligned to the title's top and bottom (so it sits inside the title's vertical band).
  - "Last Updated : ..." centered horizontally directly beneath "Prices".
- Loading state: a single centered `UIActivityIndicatorView` (or `ProgressView`) below the header. Visible while the request is in flight. Hide on success or error.
- Loaded state: a vertical list (`UITableView`/`UICollectionView`/`List`) filling the remaining space below the header.
- Each row: horizontal layout, height ~100 pt to match Android `100 dp`.
  - **Leading cell (1/2 width):** `spiceName`, centered text, color `#442C2E`.
  - **Center:** trend arrow image (~`11×11 pt`).
  - **Trailing cell (1/2 width):** `spiceCost`, centered text, color `#442C2E`.
- No row separators are rendered explicitly in the Android version (`LinearLayout`). Either match (no separators) or use the default iOS separator if it looks acceptable; pick one and be consistent.

### Status bar / safe area

- Status bar style: default (dark icons on cream background).
- Respect safe areas (notch, dynamic island, home indicator).

---

## 5. Strings (verbatim)

```
app_name              = "Coffee Prices"
prices                = "Prices"
last_updated_default  = "Last Updated : --/--"
splash_image_a11y     = "Splash screen image"
row_arrow_a11y        = "recycler view image view"   // replace with a clearer iOS label, e.g. "Trend"
logo_a11y             = "logo"
```

The Android app is English-only. Do not localize.

---

## 6. Architecture

The Android app uses Hilt (DI) + Retrofit + RxJava2. On iOS, do **not** port the Android idioms verbatim. Use idiomatic iOS:

- **Language:** Swift 5.9+.
- **UI framework:** SwiftUI is preferred for a single-screen app this small. UIKit is acceptable if the developer is more comfortable. Either way, the splash → main shared-element animation must work.
- **Minimum iOS:** iOS 15 or later (Android `minSdk 24` ≈ ~95% device coverage; iOS 15 gives an equivalent reach).
- **Networking:** `URLSession` + `async/await` + `Codable`. Do **not** pull in Alamofire, RxSwift, or Combine just to mirror the Android stack — the app makes one GET request.
- **Concurrency:** Swift Concurrency (`async`/`await`, `Task`). The Android version uses RxJava `Observable<LatestSpiceData>` with `subscribeOn(io)` / `observeOn(mainThread)`; the equivalent is a `Task` that awaits `URLSession.data(for:)` and then updates `@MainActor`-annotated state.
- **Decoding:** `JSONDecoder` with `dateDecodingStrategy = .formatted(<DateFormatter for "yyyy-MM-dd'T'HH:mm:ss.SSSZ">)` or `.iso8601` with fractional seconds.
- **State:** a single `@StateObject` view model on the main screen with `@Published var rows: [PriceRow]`, `@Published var lastUpdated: Date?`, `@Published var isLoading: Bool`.
- **DI:** none required for an app this size. Inject the `URLSession` into the view model's initializer if you want test seams; otherwise default to `.shared`.

### Suggested module layout

```
CoffeePricesApp/
  App/
    CoffeePricesApp.swift          // @main entry
  Features/
    Splash/
      SplashView.swift
    Prices/
      PricesView.swift
      PriceRowView.swift
      PricesViewModel.swift
  Networking/
    CoffeePricesAPI.swift          // protocol
    LiveCoffeePricesAPI.swift      // URLSession impl
  Models/
    PriceItem.swift                // Codable, mirrors LatestSpiceData.Data
    PricesResponse.swift           // top-level { status, data }
  Resources/
    Assets.xcassets                // logo, app icon, accent color, primary color
```

### Required model (Swift)

```swift
struct PricesResponse: Decodable {
    let status: String
    let data: [PriceItem]
}

struct PriceItem: Decodable, Identifiable, Hashable {
    let id: String           // maps from "_id"; if absent, fall back to spiceName
    let spiceName: String
    let spiceCost: String
    let average: Int
    let status: Int          // -1, 0, 1
    let priceDiff: Int?
    let scrappedAt: Date?
    let priority: Int?       // default -1 when nil

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case spiceName, spiceCost, average, status, priceDiff, scrappedAt, priority
    }
}

enum Trend {
    case up, down, unchanged
    init(rawStatus: Int) {
        switch rawStatus {
        case 1:  self = .up
        case -1: self = .down
        default: self = .unchanged
        }
    }
}
```

Tolerate optional fields (`_id`, `priceDiff`, `priority` may be missing) and decode into a stable model.

---

## 7. App update / crash reporting parity

The Android app integrates two services. Decide explicitly whether to port:

- **Google Play in-app updates (`AppUpdateManager`)** — forces an immediate update flow when a new version is on the Play Store. iOS has no equivalent; the App Store handles updates externally. **Skip.** Optionally add a manual "version-check against an endpoint" later, but it is not in scope for this clone.
- **Firebase Crashlytics + Analytics** — present on Android. On iOS, optionally add Firebase iOS SDKs (`FirebaseCrashlytics`, `FirebaseAnalytics`). If skipping, leave a TODO. Do not block the clone on this — the core feature is the price list.

---

## 8. Behaviors and edge cases to match

1. **Cold start:** SplashView shows for ~1 s with a 600 ms fade-in, then transitions to PricesView. Do **not** make the splash duration depend on the network call — the network request runs on the main screen, not the splash.
2. **Loading:** spinner visible until the request completes (success or failure). On success, fade in the list; on error, hide the spinner silently.
3. **Sorting:** sort by `priority` ascending. Items with no priority should fall back to `-1` (or sort to the top deterministically — match Android, which puts `-1` first via `sortedBy`).
4. **Last-updated label:**
   - Format `dd MMM yyyy hh:mm a` (12-hour clock with `AM`/`PM`).
   - Source = `data[0].scrappedAt`, shown in the device's local timezone.
   - If parsing fails or list is empty, leave `Last Updated : --/--`.
5. **Background → foreground:** Android's `onResume` hides the spinner if the list is already visible. Equivalent on iOS: ensure your loading state is correctly tied to view-model state, not to view appearance — re-entering the foreground should not re-show a spinner unnecessarily.
6. **No retry UI.** Failures are silent in the Android source. Either match this or add a single "Tap to retry" affordance; do not invent a full error screen.
7. **No offline cache.** Each launch hits the network. There is no local persistence.
8. **No analytics events** are explicitly logged in the Android code (only Crashlytics initialization). Don't fabricate event taxonomy.

---

## 9. Accessibility

- Use Dynamic Type where reasonable (title and rows). The Android app uses fixed sp values; on iOS prefer `.font(.system(size: 36))` plus `.dynamicTypeSize(...)` clamping if scaling would break the header layout.
- Trend arrows must have an `accessibilityLabel` (e.g. "Price up", "Price down", "Price unchanged"). The Android `contentDescription` is generic ("recycler view image view") — improve this on iOS, since it costs nothing.
- Logo: `accessibilityLabel("Coffee Prices logo")`.

---

## 10. Build/release configuration

- Xcode 15+.
- Targets: iPhone (portrait). The Android app does not declare landscape behavior — keep iOS portrait-locked unless the developer wants otherwise.
- App Transport Security: default. The API is HTTPS, so no exception is needed. The Universal Link `coffeeprices.com` is `http://` on Android — on iOS, deep linking should be HTTPS; configure the AASA file accordingly when/if Universal Links are wired up.
- Privacy manifest: declare `URLSession` usage; no tracking SDKs unless Firebase is added.

---

## 11. Out of scope (do NOT build)

These are commented-out or absent in the Android source — skip them on iOS:

- AdMob banner ads (commented out).
- Room/SQLite local cache (commented out).
- Settings screen.
- Authentication.
- Push notifications.
- Multi-commodity filters or search.
- Charts / historical data view.

---

## 12. Acceptance checklist

A reviewer should be able to confirm each of these on a built `.ipa`:

- [ ] Launching the app shows the coffee-bean logo on a `#FEEAE6` background.
- [ ] Logo fades in over ~600 ms, then transitions to the main screen ~1 s after launch.
- [ ] The transition visibly carries the logo from center to the top-leading position (shared-element).
- [ ] Main screen shows "Prices" centered, dark brown `#442C2E`, ~36 pt.
- [ ] Logo is visible to the leading edge of the header at 24 pt margin, square.
- [ ] "Last Updated : <date>" renders below "Prices" with the date from `data[0].scrappedAt` in `dd MMM yyyy hh:mm a` format.
- [ ] Five rows render: `Arabica Parchment`, `Arabica Cherry`, `Robusta Parchment`, `Robusta Cherry`, `Pepper`. (Sort order is `priority` asc; if API returns them in this order with `priority` absent, this order is preserved.)
- [ ] Each row shows name on the left, trend arrow in the middle, price string on the right, all in `#442C2E`.
- [ ] Trend arrow color matches `status`: green up, red down, gray unchanged.
- [ ] Spinner shows while the request is in flight and disappears on completion.
- [ ] Hitting `GET https://cropmarketprices-production.up.railway.app/prices/latest` is visible in proxy/logs on launch.
- [ ] No crashes when the API returns the canonical response shown in §3.
- [ ] App is portrait-only on iPhone.
- [ ] Status bar is legible on the cream background.

---

## 13. References from the Android source (for the implementing engineer)

| Concern              | Android file                                                                                        |
|----------------------|-----------------------------------------------------------------------------------------------------|
| App entry            | `app/src/main/java/tk/mohithaiyappa/coffeeprices/CoffeApplication.kt`                                |
| Splash               | `app/src/main/java/tk/mohithaiyappa/coffeeprices/ui/SplashScreenActivity.kt`                         |
| Main screen          | `app/src/main/java/tk/mohithaiyappa/coffeeprices/ui/MainActivity.kt`                                 |
| Network API          | `app/src/main/java/tk/mohithaiyappa/coffeeprices/data/network/CoffeePricesApi.kt`                    |
| Model                | `app/src/main/java/tk/mohithaiyappa/coffeeprices/data/model/LatestSpiceData.kt`                      |
| Adapter (row binding)| `app/src/main/java/tk/mohithaiyappa/coffeeprices/data/adapter/RecyclerViewAdapter.kt`                |
| DI / network module  | `app/src/main/java/tk/mohithaiyappa/coffeeprices/di/modules/{NetworkModule,ApiModule}.kt`            |
| Layouts              | `app/src/main/res/layout/{activity_splash_screen,activity_main,rv_coffee_prices_view}.xml`           |
| Colors / strings     | `app/src/main/res/values/{colors,strings,styles}.xml`                                                |
| Drawables            | `app/src/main/res/drawable/{ic_logo,ic_polygon_up,ic_polygon_down,ic_unchanged}.xml`                 |
| Manifest             | `app/src/main/AndroidManifest.xml`                                                                   |
| Gradle config        | `app/build.gradle`                                                                                   |

When in doubt, read the Android source and match its behavior — not your assumptions.
