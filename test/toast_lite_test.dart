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
