import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toast_lite/toast_lite.dart';

void main() {
  Widget wrapApp(Widget home) {
    return MaterialApp(
      navigatorKey: ToastLite.navigatorKey,
      home: home,
    );
  }

  tearDown(() {
    ToastLite.clearAll();
  });

  testWidgets(
      'show()/showLoading()/hideLoading() no-op instead of crashing when '
      'called before any Navigator has mounted', (tester) async {
    // Reproduces a real crash: FirebaseMessaging.onMessageOpenedApp can
    // deliver its buffered cold-start message before runApp() finishes
    // building the widget tree, so ToastLite.navigatorKey.currentState is
    // still null at call time. Deliberately no pumpWidget() here.
    expect(() => ToastLite.show('too early'), returnsNormally);
    expect(() => ToastLite.showLoading(), returnsNormally);
    expect(() => ToastLite.hideLoading(), returnsNormally);
    expect(() => ToastLite.clearAll(), returnsNormally);
  });

  testWidgets('show() inserts a toast with the given message',
      (tester) async {
    await tester.pumpWidget(wrapApp(const SizedBox.shrink()));

    ToastLite.show('halo', duration: const Duration(seconds: 5));
    await tester.pump();

    expect(find.text('halo'), findsOneWidget);

    ToastLite.clearAll();
    await tester.pump();
  });

  testWidgets('show() auto-dismisses after duration', (tester) async {
    await tester.pumpWidget(wrapApp(const SizedBox.shrink()));

    ToastLite.show('sebentar', duration: const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('sebentar'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('sebentar'), findsNothing);
  });

  testWidgets(
      'hideLoading() called before the entry ever gets a chance to mount '
      'still removes it (does not leak a stuck spinner)', (tester) async {
    // Reproduces a real bug: an entry inserted and removed within the same
    // frame (no pump() in between) is never `mounted` — Flutter only
    // builds it on the next frame. hideLoading() used to gate removal on
    // `entry.mounted`, which skipped the removal and left the entry
    // permanently orphaned in the Overlay, appearing on the very next
    // pump with no way left to remove it.
    await tester.pumpWidget(wrapApp(const SizedBox.shrink()));

    ToastLite.showLoading();
    ToastLite.hideLoading(); // no pump() between show and hide
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('showLoading()/hideLoading() toggle the spinner',
      (tester) async {
    await tester.pumpWidget(wrapApp(const SizedBox.shrink()));

    ToastLite.showLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    ToastLite.hideLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('showLoading() twice does not stack overlays', (tester) async {
    await tester.pumpWidget(wrapApp(const SizedBox.shrink()));

    ToastLite.showLoading();
    await tester.pump();
    ToastLite.showLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    ToastLite.hideLoading();
    await tester.pump();
  });

  testWidgets('clearAll() removes toasts and loading together',
      (tester) async {
    await tester.pumpWidget(wrapApp(const SizedBox.shrink()));

    ToastLite.show('a', duration: const Duration(seconds: 5));
    ToastLite.show('b', duration: const Duration(seconds: 5));
    ToastLite.showLoading();
    await tester.pump();

    expect(find.text('a'), findsOneWidget);
    expect(find.text('b'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    ToastLite.clearAll();
    await tester.pump();

    expect(find.text('a'), findsNothing);
    expect(find.text('b'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
