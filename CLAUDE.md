# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Umra Guide** — an iOS app (App Store ID: 1673683355) helping Muslims perform Umrah and Hajj pilgrimage with step-by-step instructions, supplications, audio playback, prayer times, and offline functionality.

- **Platform:** iOS 17.0+ (SwiftUI only, no UIKit)
- **Languages:** Swift 5.9+, 7 localization targets (en, ru, de, fr, ar, tr, id)
- **Dependencies:** Adhan (prayer times), StoreKit 2, AVFoundation, BackgroundTasks, UserNotifications

## Build Commands

**Open project:**
```bash
open umra.xcodeproj
```

**CI build (no code signing):**
```bash
xcodebuild \
  -project umra.xcodeproj \
  -scheme umra \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

There is no test target — the project has no unit or UI tests.

## Architecture

**Pattern:** MVVM with environment-based dependency injection.

All managers are `@Observable` + `@MainActor` classes created in `umraApp.swift` and injected via `.environment()`. Views access them with `@Environment(ManagerType.self)`.

**Manager responsibilities (`umra/ViewModel/UserSettings.swift` and `StoreKit.swift`):**

| Manager | Responsibility |
|---|---|
| `ThemeManager` | Theme (Auto/Light/Dark/Emerald), colors, color scheme |
| `LocalizationManager` | Dynamic bundle switching for 7 languages |
| `UserPreferences` | Language selection, app rating — persisted to UserDefaults |
| `FontManager` | Custom font selection, dynamic sizes (iPad vs iPhone) |
| `PurchaseManager` | StoreKit 2 consumable donations ($0.99–$99.99) |
| `AudioManager` | AVAudioPlayer, playback rate, audio session lifecycle |
| `BackgroundTaskManager` | BGAppRefreshTask for prayer time updates |

**Navigation:** `MainTabView` → two tabs: `ContentView` (Umrah, 7 steps + useful info) and `HajjView` (Hajj guide). Uses `NavigationStack` + `navigationDestination` for type-safe routing.

**Content structure:** Umrah is broken into 7 sequential steps (Ihram → Tawaf → Maqam Ibrahim → Zamzam → Istilam → Sa'i → Halq). Each step is a dedicated SwiftUI view under `umra/View/ContentView/`.

**Key supporting views:**
- `PrayerTimeView` — Mecca/Medina prayer times via Adhan, Hijri calendar, push notifications
- `PlayerView` — Audio player with progress, rate control (0.5×–2×), repeat
- `TawafCounterView` / `CounterTapView` — Circuit counter for Tawaf and Sa'i
- `DonationView` / `DonationSheetView` — StoreKit purchase UI
- `SettingsView` — Theme, language, font, notification preferences

**Centralized config:** `umra/Model/Constants.swift` holds product IDs, animation names, prayer city data, and other app-wide constants.

## Key Conventions

- Use `@Observable` (not `ObservableObject`) for all new managers/state classes.
- All UI state mutations must be on `@MainActor`.
- Custom errors conform to `LocalizedError` (see `AudioError`, `PurchaseError`).
- Async work uses `async/await` and `Task`; the `TaskHolder` actor manages task lifecycle.
- Theme colors and typography always go through `ThemeManager` / `FontManager` — never hard-code colors or font sizes in views.
- Localized strings must be added to all 7 `.lproj/Localizable.strings` files.
- Logging uses `OSLog` — not `print`.
