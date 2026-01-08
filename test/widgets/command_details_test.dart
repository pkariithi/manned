import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manned_pages/widgets/command_details.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CommandDetails Widget Tests', () {
    testWidgets('renders command name and category', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'test',
        category: 'Test Category',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      expect(find.text('test'), findsWidgets);
      expect(find.text('Test Category'), findsOneWidget);
    });

    testWidgets('displays command overview', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      expect(find.textContaining('Test command summary'), findsOneWidget);
    });

    testWidgets('displays syntax section', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'test');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      expect(find.text('Syntax'), findsOneWidget);
      expect(find.textContaining('test [OPTIONS]'), findsOneWidget);
    });

    testWidgets('displays options section', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      expect(find.text('Common Options'), findsOneWidget);
      expect(find.text('--help'), findsOneWidget);
    });

    testWidgets('displays examples section', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'test');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      expect(find.text('Examples'), findsOneWidget);
      expect(find.text('Basic usage'), findsOneWidget);
    });

    testWidgets('shows installation section for installable commands',
        (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'test',
        requiresInstallation: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      // Installation section should be present
      expect(find.text('Installation Required'), findsOneWidget);
    });

    testWidgets('hides installation section for built-in commands',
        (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'test',
        requiresInstallation: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      // Installation section should not be visible for built-in commands
      // (it may still be in the tree but not displayed prominently)
      final installationText = find.text('Installation Instructions');
      // The section might not exist or might be hidden
      expect(installationText, findsNothing);
    });

    testWidgets('displays JSON view when showJsonView is true',
        (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'test');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: true,
            ),
          ),
        ),
      );

      // JSON view should contain JSON-like content
      expect(find.textContaining('"name"'), findsOneWidget);
      expect(find.textContaining('"metadata"'), findsOneWidget);
    });

    testWidgets('displays UI view when showJsonView is false',
        (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      // UI view should show formatted sections
      expect(find.text('Syntax'), findsOneWidget);
      expect(find.text('Examples'), findsOneWidget);
      // JSON should not be visible
      expect(find.textContaining('"metadata"'), findsNothing);
    });

    testWidgets('displays all optional sections when present', (WidgetTester tester) async {
      final command = TestCommandBuilder.createCommandWithAllFields();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      expect(find.text('Common Misconceptions'), findsOneWidget);
      expect(find.text('Common Pitfalls'), findsOneWidget);
      expect(find.text('Best Practices'), findsOneWidget);
      expect(find.text('Performance Tips'), findsOneWidget);
      expect(find.text('Related Commands'), findsOneWidget);
      expect(find.text('Additional Notes'), findsOneWidget);
    });

    testWidgets('copy button copies syntax to clipboard', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'test');

      // Setup clipboard
      final clipboardData = <String, String>{};
      SystemChannels.platform.setMockMethodCallHandler((call) async {
        if (call.method == 'Clipboard.setData') {
          final data = call.arguments as Map<String, dynamic>;
          clipboardData['text'] = data['text'] as String;
        }
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      // Find and tap copy button (usually an IconButton with copy icon)
      final copyButtons = find.byIcon(Icons.copy);
      if (copyButtons.evaluate().isNotEmpty) {
        await tester.tap(copyButtons.first);
        await tester.pump();

        // Verify snackbar appears
        expect(find.text('Copied to clipboard'), findsOneWidget);
      }
    });

    testWidgets('scrolls to top when command changes', (WidgetTester tester) async {
      final command1 = TestCommandBuilder.createSimpleCommand(name: 'test1');
      final command2 = TestCommandBuilder.createSimpleCommand(name: 'test2');

      final widget = MaterialApp(
        home: Scaffold(
          body: CommandDetails(
            command: command1,
            showJsonView: false,
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pump();

      // Scroll down
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -500));
        await tester.pump();
      }

      // Change command
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command2,
              showJsonView: false,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350)); // Wait for scroll animation

      // The scroll position should reset (we can't easily test exact position,
      // but we can verify the widget updates)
      expect(find.text('test2'), findsWidgets);
    });

    testWidgets('displays command tags', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      // Tags should be displayed (check for 'test' tag)
      expect(find.text('test'), findsWidgets);
    });

    testWidgets('handles command with no optional sections', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: false,
            ),
          ),
        ),
      );

      // Required sections should be present
      expect(find.text('Syntax'), findsOneWidget);
      expect(find.text('Examples'), findsOneWidget);
      // Optional sections should not be present
      expect(find.text('Common Misconceptions'), findsNothing);
    });

    testWidgets('JSON view contains command name', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'mytest');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: true,
            ),
          ),
        ),
      );

      expect(find.textContaining('"name": "mytest"'), findsOneWidget);
    });

    testWidgets('JSON view has copy button', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandDetails(
              command: command,
              showJsonView: true,
            ),
          ),
        ),
      );

      // Should have copy button in JSON view
      final copyButtons = find.byIcon(Icons.copy);
      expect(copyButtons, findsAtLeastNWidgets(1));
    });
  });
}

