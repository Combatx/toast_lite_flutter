import Flutter
import UIKit

/// toast_lite has no native functionality — everything runs in pure Dart
/// via `Overlay`/`OverlayEntry`. This class exists only so the plugin can
/// be registered and distributed through CocoaPods/Swift Package Manager.
public class ToastLitePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // No method channel needed — nothing to register.
  }
}
