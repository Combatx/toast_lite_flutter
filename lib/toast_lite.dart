import 'dart:async';

import 'package:flutter/material.dart';

/// Where a toast is anchored on screen.
enum ToastLiteAlign { top, center, bottom }

/// Lightweight toast + loading overlay, callable from anywhere (services,
/// callbacks, timers) without needing a [BuildContext] at the call site.
///
/// Setup: attach [navigatorKey] once —
/// `MaterialApp(navigatorKey: ToastLite.navigatorKey)`.
class ToastLite {
  ToastLite._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static OverlayState get _overlay {
    final overlay = navigatorKey.currentState?.overlay;
    assert(
      overlay != null,
      'ToastLite.navigatorKey belum dipasang di '
      'MaterialApp(navigatorKey: ToastLite.navigatorKey), atau belum ada '
      'Navigator yang ter-mount saat ToastLite dipanggil.',
    );
    return overlay!;
  }

  static final Map<OverlayEntry, Timer> _toastEntries = <OverlayEntry, Timer>{};
  static OverlayEntry? _loadingEntry;

  /// Show a text toast for [duration], then auto-dismiss.
  ///
  /// Unlike bot_toast's `cancelFunc`, [entry] here is a plain nullable local
  /// — it is assigned synchronously right after construction, before the
  /// [Timer] or the widget tree can ever read it, so there is no
  /// late-initialization race.
  static void show(
    String message, {
    Duration duration = const Duration(seconds: 2),
    ToastLiteAlign align = ToastLiteAlign.bottom,
    Color backgroundColor = const Color(0xCC000000),
    Color textColor = Colors.white,
  }) {
    final overlay = _overlay;
    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        align: align,
        backgroundColor: backgroundColor,
        textColor: textColor,
      ),
    );
    _toastEntries[entry] = Timer(duration, () => _removeEntry(entry));
    overlay.insert(entry);
  }

  /// Show a full-screen loading overlay. Call [hideLoading] to dismiss.
  /// Calling this again while one is active replaces it — loading never
  /// stacks.
  static void showLoading({
    Widget? indicator,
    Color barrierColor = const Color(0x80000000),
  }) {
    hideLoading();
    final overlay = _overlay;
    final entry = OverlayEntry(
      builder: (context) => _LoadingWidget(
        indicator: indicator,
        barrierColor: barrierColor,
      ),
    );
    _loadingEntry = entry;
    overlay.insert(entry);
  }

  static void hideLoading() {
    final entry = _loadingEntry;
    _loadingEntry = null;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
  }

  /// Remove every active toast and the loading overlay, if any — useful on
  /// logout or a hard navigation reset.
  static void clearAll() {
    for (final entry in List<OverlayEntry>.from(_toastEntries.keys)) {
      _removeEntry(entry);
    }
    hideLoading();
  }

  static void _removeEntry(OverlayEntry? entry) {
    if (entry == null) return;
    _toastEntries.remove(entry)?.cancel();
    if (entry.mounted) {
      entry.remove();
    }
  }
}

class _ToastWidget extends StatelessWidget {
  const _ToastWidget({
    required this.message,
    required this.align,
    required this.backgroundColor,
    required this.textColor,
  });

  final String message;
  final ToastLiteAlign align;
  final Color backgroundColor;
  final Color textColor;

  Alignment get _alignment => switch (align) {
        ToastLiteAlign.top => Alignment.topCenter,
        ToastLiteAlign.center => Alignment.center,
        ToastLiteAlign.bottom => Alignment.bottomCenter,
      };

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: _alignment,
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({this.indicator, required this.barrierColor});

  final Widget? indicator;
  final Color barrierColor;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: barrierColor,
        alignment: Alignment.center,
        child: indicator ?? const CircularProgressIndicator(),
      ),
    );
  }
}
