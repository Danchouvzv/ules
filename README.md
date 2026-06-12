# Ules Flutter MVP

Ules is a premium Flutter MVP for group buying in Kazakhstan. It includes onboarding, eSIM verification mock, localized RU/KZ UI, an explainable recommendation feed, product details, live group joining, Kaspi Pay hold messaging, order status, profile settings, and dark/light themes.

The product flow is stateful: profile edits, language/theme, onboarding completion, group participants, joined groups, Kaspi hold orders, and order statuses are persisted locally with `shared_preferences`.

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

Product/catalog data is still local seed data, but user actions are real inside the app: joining a group creates an order, reserves one eSIM-bound place, updates participant counts, persists the Kaspi hold, and shows the order in profile history after restart.
