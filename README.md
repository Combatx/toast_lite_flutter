# toast_lite

Lightweight toast and full-screen loading overlay for Flutter — callable
from anywhere (services, callbacks, timers) without needing a
`BuildContext` at the call site.

Built as a smaller, race-free alternative to `bot_toast`: it uses a plain
`Overlay`/`OverlayEntry` and nullable local variables instead of a
`late final` closure-captured cancel function, so there's no window where
a reentrant dismiss can read an uninitialized value.

## Getting started

Attach `ToastLite.navigatorKey` to your `MaterialApp` once:

```dart
MaterialApp(
  navigatorKey: ToastLite.navigatorKey,
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

## Additional information

Internal package — not published to pub.dev. Consumed via a `path`/`git`
dependency from sibling Flutter projects.
