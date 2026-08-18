package com.makanbangstaffnew.toast_lite

import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * toast_lite has no native functionality — everything runs in pure Dart
 * via `Overlay`/`OverlayEntry`. This class exists only so the plugin can
 * be registered and distributed through Gradle, matching the iOS side's
 * SPM/CocoaPods dual-support setup. No method channel is needed.
 */
class ToastLitePlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}
