## 0.1.2

* Fix: `hideLoading`/`show`'s auto-dismiss no longer leak a permanently
  stuck overlay entry when removal happens before the entry's first
  build (e.g. `showLoading()` immediately followed by `hideLoading()`
  within the same frame — a real scenario when the awaited work resolves
  from a local cache in a few ms). The previous code gated
  `entry.remove()` on `entry.mounted`, but `OverlayEntry.mounted` only
  becomes true after Flutter's next build pass — gating on it skipped
  the removal and left the entry orphaned in the Overlay, rendering on
  the following frame with no way left to remove it. `remove()` doesn't
  require `mounted`; it only requires the entry not already be removed.

## 0.1.1

* Fix: `show`/`showLoading` no longer crash with "Null check operator used
  on a null value" when called before any `Navigator` has mounted (e.g.
  from `FirebaseMessaging.onMessageOpenedApp`, which can deliver its
  buffered cold-start message before `runApp()` finishes building the
  widget tree). They now silently no-op in that case instead.

## 0.1.0

* Add plugin platform scaffolding: iOS (CocoaPods + Swift Package Manager
  side by side) and Android (Gradle/Kotlin). No native code runs —
  registration stubs only.
* Fix: remove leftover reference to an undefined `_BackButtonInterceptor`
  class that broke compilation.
* `navigatorKey` is now mutable so a host app can reuse an existing
  `GlobalKey<NavigatorState>` instead of introducing a second one.
* Docs: document the `navigatorKey` reuse pattern and the known
  back-button limitation.

## 0.0.1

* Initial release: `ToastLite.show`, `showLoading`, `hideLoading`, `clearAll`.
