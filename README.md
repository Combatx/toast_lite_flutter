# toast_lite

Lightweight toast and full-screen loading overlay for Flutter — callable
from anywhere (services, callbacks, timers) without needing a
`BuildContext` at the call site.

Built as a smaller, race-free alternative to `bot_toast`: it uses a plain
`Overlay`/`OverlayEntry` and nullable local variables instead of a
`late final` closure-captured cancel function, so there's no window where
a reentrant dismiss can read an uninitialized value.

Ships as a Flutter plugin with native scaffolding for both platforms (no
actual native code runs — `showLoading`/`show` are pure Dart):
- iOS: CocoaPods (`ios/toast_lite.podspec`) **and** Swift Package Manager
  (`ios/toast_lite/Package.swift`) side by side.
- Android: Gradle (`android/build.gradle.kts`, Kotlin).

## Getting started

Attach a `GlobalKey<NavigatorState>` to your `MaterialApp`. Two ways:

**No existing navigator key** — just use `ToastLite.navigatorKey` directly:

```dart
MaterialApp(
  navigatorKey: ToastLite.navigatorKey,
  home: const HomePage(),
)
```

**Already have one** (e.g. your own navigation service) — `MaterialApp`
only accepts a single `navigatorKey`, so point `ToastLite` at the existing
one instead of introducing a second key. Do this once, before `runApp()`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ToastLite.navigatorKey = NavigationService.navigatorKey; // reuse, don't duplicate
  runApp(const MyApp());
}

// ...
MaterialApp(
  navigatorKey: NavigationService.navigatorKey,
  home: const HomePage(),
)
```

## Usage

```dart
// Toast
ToastLite.show('Berhasil disimpan');
ToastLite.show(
  'Gagal terhubung ke server',
  duration: const Duration(seconds: 3),
  align: ToastLiteAlign.top,
);

// Loading overlay
ToastLite.showLoading();
await doSomeWork();
ToastLite.hideLoading();

// Clear everything (e.g. on logout / hard navigation reset)
ToastLite.clearAll();
```

## Known limitation

Unlike bot_toast's `BackButtonBehavior.ignore`, `showLoading()` does **not**
yet swallow the Android back button — a user can still pop the current
screen while loading is showing. Deferred; not implemented yet.

## Additional information

Internal package — not published to pub.dev. Consumed via a `path`/`git`
dependency from sibling Flutter projects. Repo:
https://github.com/Combatx/toast_lite_flutter
