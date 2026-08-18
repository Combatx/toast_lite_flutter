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
