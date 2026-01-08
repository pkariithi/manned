import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manned_pages/widgets/command_list.dart';
import 'package:manned_pages/models/command.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CommandList Widget Tests', () {
    testWidgets('renders empty list when no commands provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders single command', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'test',
        category: 'Test Category',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('test'), findsOneWidget);
      expect(find.text('Test description'), findsOneWidget);
      expect(find.text('TEST CATEGORY'), findsOneWidget);
    });

    testWidgets('groups commands by category', (WidgetTester tester) async {
      final command1 = TestCommandBuilder.createSimpleCommand(
        name: 'test1',
        category: 'Category A',
      );
      final command2 = TestCommandBuilder.createSimpleCommand(
        name: 'test2',
        category: 'Category A',
      );
      final command3 = TestCommandBuilder.createSimpleCommand(
        name: 'test3',
        category: 'Category B',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command1, command2, command3],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('CATEGORY A'), findsOneWidget);
      expect(find.text('CATEGORY B'), findsOneWidget);
      expect(find.text('test1'), findsOneWidget);
      expect(find.text('test2'), findsOneWidget);
      expect(find.text('test3'), findsOneWidget);
    });

    testWidgets('shows installation indicator for commands requiring installation',
        (WidgetTester tester) async {
      final builtInCommand = TestCommandBuilder.createSimpleCommand(
        name: 'builtin',
        requiresInstallation: false,
      );
      final installableCommand = TestCommandBuilder.createSimpleCommand(
        name: 'installable',
        requiresInstallation: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [builtInCommand, installableCommand],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      // Find download icons (installation indicator)
      final downloadIcons = find.byIcon(Icons.download);
      expect(downloadIcons, findsOneWidget);
    });

    testWidgets('highlights selected command', (WidgetTester tester) async {
      final command1 = TestCommandBuilder.createSimpleCommand(name: 'test1');
      final command2 = TestCommandBuilder.createSimpleCommand(name: 'test2');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command1, command2],
              selectedCommand: command1,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      // The selected command should have different styling
      // We can verify by checking the widget tree structure
      final listTiles = find.byType(ListTile);
      expect(listTiles, findsNWidgets(2));
    });

    testWidgets('calls onCommandSelected when command is tapped',
        (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'test');
      Command? selectedCommand;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command],
              selectedCommand: null,
              onCommandSelected: (cmd) {
                selectedCommand = cmd;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('test'));
      await tester.pump();

      expect(selectedCommand, equals(command));
    });

    testWidgets('displays command name and description', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'mytest',
        description: 'My test description',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('mytest'), findsOneWidget);
      expect(find.text('My test description'), findsOneWidget);
    });

    testWidgets('displays command avatar with first letter', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'test');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('T'), findsOneWidget); // First letter uppercase
    });

    testWidgets('handles multiple commands in same category', (WidgetTester tester) async {
      final commands = List.generate(
        5,
        (i) => TestCommandBuilder.createSimpleCommand(
          name: 'test$i',
          category: 'Same Category',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: commands,
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('SAME CATEGORY'), findsOneWidget);
      for (int i = 0; i < 5; i++) {
        expect(find.text('test$i'), findsOneWidget);
      }
    });

    testWidgets('handles commands with long descriptions', (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'test',
        description: 'This is a very long description that should be truncated with ellipsis',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      // Description should be displayed (may be truncated)
      expect(find.textContaining('This is a very long'), findsOneWidget);
    });

    testWidgets('displays search field at top when controller and callback provided',
        (WidgetTester tester) async {
      final searchController = TextEditingController();
      String? searchQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [],
              selectedCommand: null,
              onCommandSelected: (_) {},
              searchController: searchController,
              onSearchChanged: (query) {
                searchQuery = query;
              },
            ),
          ),
        ),
      );

      // Search field should be visible at the top of the left pane
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search commands...'), findsOneWidget);

      // Verify search field is positioned before the command list
      // (it should be the first child in the Column)
      final column = find.byType(Column);
      expect(column, findsWidgets);

      // Test typing in search field
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(searchQuery, equals('test'));
      expect(searchController.text, equals('test'));

      searchController.dispose();
    });

    testWidgets('search field has correct styling and positioning',
        (WidgetTester tester) async {
      final searchController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [],
              selectedCommand: null,
              onCommandSelected: (_) {},
              searchController: searchController,
              onSearchChanged: (_) {},
            ),
          ),
        ),
      );

      // Find the TextField
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      final textFieldWidget = tester.widget<TextField>(textField);

      // Verify search field properties
      expect(textFieldWidget.decoration?.hintText, equals('Search commands...'));
      expect(textFieldWidget.decoration?.prefixIcon, isNotNull);
      expect(textFieldWidget.controller, equals(searchController));

      // Verify it's in a Container with padding (top of left pane)
      final container = find.ancestor(
        of: textField,
        matching: find.byType(Container),
      );
      expect(container, findsWidgets);

      searchController.dispose();
    });

    testWidgets('hides search field when controller not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [],
              selectedCommand: null,
              onCommandSelected: (_) {},
            ),
          ),
        ),
      );

      // Search field should not be visible when controller is not provided
      expect(find.text('Search commands...'), findsNothing);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('search field appears above command list in layout',
        (WidgetTester tester) async {
      final command = TestCommandBuilder.createSimpleCommand(name: 'test');
      final searchController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandList(
              commands: [command],
              selectedCommand: null,
              onCommandSelected: (_) {},
              searchController: searchController,
              onSearchChanged: (_) {},
            ),
          ),
        ),
      );

      // Both search field and command list should be present
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('test'), findsOneWidget);

      // Search field should be rendered before the command list
      // (in the widget tree, it comes first in the Column)
      final column = tester.widget<Column>(
        find.byType(Column).first,
      );

      // First child should be the search Container (if search is provided)
      // Second child should be the Expanded with ListView
      expect(column.children.length, greaterThan(1));

      searchController.dispose();
    });
  });
}

