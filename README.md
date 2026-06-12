# Ules Flutter MVP

Ules is a premium Flutter MVP for group buying in Kazakhstan. It includes onboarding, eSIM verification mock, localized RU/KZ UI, an explainable recommendation feed, product details, live group joining, Kaspi Pay hold messaging, order status, profile settings, and dark/light themes.

The product flow is stateful: profile edits, language/theme, onboarding completion, group participants, joined groups, Kaspi hold orders, and order statuses are persisted locally with `shared_preferences`.

The UI is optimized for a product demo: the feed has a search surface, city context, trust metrics, category chips, premium product cards, persistent bottom navigation, order history, and sticky price-aware CTAs on product pages.

Ules adds two trust-first mechanics beyond classic group buying:

- **Group Passport**: transparent group economics, eSIM seats, local demand, marketplace source, refund SLA, and Kaspi hold rules.
- **Smart Close**: participants can choose whether to close the group now or wait for the next participant tier to unlock a lower price.

## Project Structure

- `lib/main.dart` - app entry point
- `lib/app/` - router and global Riverpod state
- `lib/core/` - design tokens and theme
- `lib/models/` - product, profile, eSIM, recommendation models
- `lib/repositories/` - mock repository, scoring formula, live group stream
- `lib/app/state.dart` - local session store, persistence, group joining, order lifecycle
- `lib/widgets/` - reusable product, price, progress, avatar, recommendation, eSIM widgets
- `lib/features/` - onboarding, profile setup, feed, product, group, order, settings screens
- `lib/l10n/` - RU/KZ localization files and runtime localizations

## Run

If this folder was empty before, generate Flutter platform files once:

```sh
flutter create --platforms=ios .
```

Then install dependencies and run:

```sh
flutter pub get
flutter run
```

## Open in Xcode

The iOS workspace is generated at:

```sh
open ios/Runner.xcworkspace
```

Open the `.xcworkspace`, not `Runner.xcodeproj`, because CocoaPods plugins are linked through the workspace.

If Flutter or Xcode says `xcodebuild` is unavailable, install full Xcode from the App Store and select it:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```

Product/catalog data is still local seed data, but user actions are real inside the app: joining a group creates an order, reserves one eSIM-bound place, updates participant counts, persists the Kaspi hold, and shows the order in profile history after restart.
