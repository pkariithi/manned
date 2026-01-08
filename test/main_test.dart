import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manned_pages/main.dart';

void main() {
  group('MannedPagesApp Tests', () {
    testWidgets('app initializes with MainScreen', (WidgetTester tester) async {
      // Set a reasonable screen size to avoid overflow issues
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MannedPagesApp());

      // Wait for initial render
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should have MaterialApp
      expect(find.byType(MaterialApp), findsOneWidget);

      // Should have MainScreen (indirectly through widget tree)
      // MainScreen has AppBar with "Manned Pages" title
      expect(find.text('Manned Pages'), findsOneWidget);

      // Reset view after test
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('app uses YaruTheme', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MannedPagesApp());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // YaruTheme wraps MaterialApp
      // We can verify by checking the theme is applied
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);

      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('app starts in light mode by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MannedPagesApp());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.light));
    });

    testWidgets('app title is set correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MannedPagesApp());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, equals('Manned Pages'));
    });

    testWidgets('app has debug banner disabled', (WidgetTester tester) async {
      await tester.pumpWidget(const MannedPagesApp());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('theme toggle changes theme mode', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MannedPagesApp());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Initially light mode
      MaterialApp materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.light));

      // Find theme toggle button
      final themeButton = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Icon &&
            ((widget.icon as Icon).icon == Icons.dark_mode ||
                (widget.icon as Icon).icon == Icons.light_mode),
      );

      expect(themeButton, findsOneWidget);

      // Tap to toggle theme
      await tester.tap(themeButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should now be dark mode
      materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.dark));

      // Tap again to toggle back
      await tester.tap(themeButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should be light mode again
      materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, equals(ThemeMode.light));

      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });
}

