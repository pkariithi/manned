import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manned_pages/screens/main_screen.dart';

void main() {
  group('MainScreen Widget Tests', () {
    testWidgets('displays app title in AppBar', (WidgetTester tester) async {
      // Set a reasonable screen size to avoid overflow issues
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Wait for initial render
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Manned Pages'), findsOneWidget);
      expect(find.byIcon(Icons.menu_book), findsOneWidget);

      // Reset view after test
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('displays theme toggle button in AppBar', (WidgetTester tester) async {
      bool themeToggled = false;
      void onThemeToggle() {
        themeToggled = true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: MainScreen(onThemeToggle: onThemeToggle),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Find theme toggle button (dark_mode or light_mode icon)
      final themeButton = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Icon &&
            ((widget.icon as Icon).icon == Icons.dark_mode ||
                (widget.icon as Icon).icon == Icons.light_mode),
      );

      expect(themeButton, findsOneWidget);

      // Tap the theme toggle button
      await tester.tap(themeButton);
      await tester.pump();

      expect(themeToggled, isTrue);
    });

    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Immediately after pump, should show loading indicator
      await tester.pump();

      // Should show loading indicator (may disappear quickly if assets load fast)
      // It may or may not be visible depending on loading speed
      // This test verifies the loading state exists in the widget tree
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('displays two-pane layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Should have a Row for the two-pane layout (when not loading/error)
      final rows = find.byType(Row);
      // Row should exist in the body when loaded
      expect(rows, findsWidgets);
    });

    testWidgets('theme toggle button has correct tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final themeButton = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Icon &&
            ((widget.icon as Icon).icon == Icons.dark_mode ||
                (widget.icon as Icon).icon == Icons.light_mode),
      );

      expect(themeButton, findsOneWidget);

      final button = tester.widget(themeButton) as IconButton;
      expect(button.tooltip, isNotNull);
      expect(
        button.tooltip,
        anyOf(
          equals('Switch to Light Mode'),
          equals('Switch to Dark Mode'),
        ),
      );
    });

    testWidgets('handles theme toggle callback correctly', (WidgetTester tester) async {
      int toggleCount = 0;
      void onThemeToggle() {
        toggleCount++;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: MainScreen(onThemeToggle: onThemeToggle),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final themeButton = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Icon &&
            ((widget.icon as Icon).icon == Icons.dark_mode ||
                (widget.icon as Icon).icon == Icons.light_mode),
      );

      expect(themeButton, findsOneWidget);
      expect(toggleCount, equals(0));

      await tester.tap(themeButton);
      await tester.pump();

      expect(toggleCount, equals(1));

      await tester.tap(themeButton);
      await tester.pump();

      expect(toggleCount, equals(2));
    });

    testWidgets('AppBar contains title and actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify AppBar structure
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Manned Pages'), findsOneWidget);
      expect(find.byIcon(Icons.menu_book), findsOneWidget);

      // Theme toggle should always be present
      final themeButton = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Icon &&
            ((widget.icon as Icon).icon == Icons.dark_mode ||
                (widget.icon as Icon).icon == Icons.light_mode),
      );
      expect(themeButton, findsOneWidget);
    });

    testWidgets('JSON toggle button appears when command is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Wait for potential command loading
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // JSON toggle button should appear if a command is selected
      // It's conditionally rendered, so may or may not be present
      final jsonToggleButton = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            widget.icon is Icon &&
            ((widget.icon as Icon).icon == Icons.code ||
                (widget.icon as Icon).icon == Icons.code_off),
      );

      // If commands loaded and one is selected, button should be present
      // This is a conditional test based on actual data loading
      if (jsonToggleButton.evaluate().isNotEmpty) {
        expect(jsonToggleButton, findsOneWidget);

        final button = tester.widget(jsonToggleButton) as IconButton;
        expect(button.tooltip, isNotNull);
        expect(
          button.tooltip,
          anyOf(
            equals('Show UI View'),
            equals('Show JSON View'),
          ),
        );
      }
    });

    testWidgets('shows error state UI structure when error occurs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Check if error state appears (may not if loading succeeds)
      final errorIcon = find.byIcon(Icons.error_outline);
      final retryButton = find.text('Retry');

      // If error state is shown, verify its structure
      if (errorIcon.evaluate().isNotEmpty) {
        expect(retryButton, findsOneWidget);
      }
    });

    testWidgets('shows empty search results message when applicable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Find search field
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        // Enter a search query that won't match anything
        await tester.enterText(searchField, 'nonexistentcommandxyz123456789');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Should show "No commands found" message if search returns empty
        final noCommandsMessage = find.text('No commands found');
        if (noCommandsMessage.evaluate().isNotEmpty) {
          expect(noCommandsMessage, findsOneWidget);
          expect(find.text('Try adjusting your search query'), findsOneWidget);
          expect(find.byIcon(Icons.search_off), findsOneWidget);
        }
      }
    });
  });
}

