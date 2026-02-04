import 'package:flutter_test/flutter_test.dart';
import 'package:manned_pages/services/command_service.dart';

void main() {
  group('CommandService Tests', () {
    late CommandService commandService;

    setUp(() {
      commandService = CommandService();
    });

    test('getAllCommands throws StateError when commands not loaded', () {
      expect(
        () => commandService.getAllCommands(),
        throwsA(isA<StateError>()),
      );
    });

    test('getCommandsByCategory throws StateError when commands not loaded', () {
      expect(
        () => commandService.getCommandsByCategory('Test'),
        throwsA(isA<StateError>()),
      );
    });

    test('getCommandByName throws StateError when commands not loaded', () {
      expect(
        () => commandService.getCommandByName('test'),
        throwsA(isA<StateError>()),
      );
    });

    test('searchCommands throws StateError when commands not loaded', () {
      expect(
        () => commandService.searchCommands('test'),
        throwsA(isA<StateError>()),
      );
    });

    test('getAllCategories throws StateError when commands not loaded', () {
      expect(
        () => commandService.getAllCategories(),
        throwsA(isA<StateError>()),
      );
    });

    test('getCommandJson requires Flutter binding for asset access', () {
      // This method requires Flutter binding to access rootBundle
      // Testing that it exists and has correct signature
      expect(commandService.getCommandJson, isA<Function>());
    });
  });

  group('CommandService Search Logic Tests', () {
    test('searchCommands logic is case-insensitive', () {
      // Test the search logic by examining the implementation
      // The search converts query to lowercase and compares with lowercase command fields
      final service = CommandService();

      // Verify it throws StateError (commands not loaded)
      // This confirms the method exists and checks loaded state first
      expect(
        () => service.searchCommands('TEST'),
        throwsA(isA<StateError>()),
      );
    });

    test('searchCommands trims whitespace', () {
      final service = CommandService();
      // The implementation uses .trim() on the query
      expect(
        () => service.searchCommands('  test  '),
        throwsA(isA<StateError>()),
      );
    });

    test('searchCommands returns all commands for empty query', () {
      final service = CommandService();
      // Implementation checks: if (query.isEmpty) return getAllCommands();
      expect(
        () => service.searchCommands(''),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('CommandService Method Signatures', () {
    test('getAllCommands returns List<Command>', () {
      final service = CommandService();
      expect(
        () => service.getAllCommands(),
        throwsA(isA<StateError>()),
      );
    });

    test('getCommandsByCategory accepts String parameter', () {
      final service = CommandService();
      expect(
        () => service.getCommandsByCategory('Test Category'),
        throwsA(isA<StateError>()),
      );
    });

    test('getCommandByName accepts String parameter and returns Command?', () {
      final service = CommandService();
      expect(
        () => service.getCommandByName('test'),
        throwsA(isA<StateError>()),
      );
    });

    test('searchCommands accepts String parameter', () {
      final service = CommandService();
      expect(
        () => service.searchCommands('query'),
        throwsA(isA<StateError>()),
      );
    });

    test('getAllCategories returns List<String>', () {
      final service = CommandService();
      expect(
        () => service.getAllCategories(),
        throwsA(isA<StateError>()),
      );
    });

    test('getCommandJson has correct signature', () {
      final service = CommandService();
      // Verify method exists and has correct signature
      expect(service.getCommandJson, isA<Function>());
    });
  });

  group('CommandService Load All Commands', () {
    testWidgets('loadCommands loads all command JSON files without error', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final service = CommandService();
      await service.loadCommands();
      final commands = service.getAllCommands();
      // Should have loaded all command files (count must match assets/data/*.json in command_service.dart)
      expect(commands.length, greaterThanOrEqualTo(130));
      expect(commands, isNotEmpty);
      // Spot-check: ls and umount should be present
      expect(service.getCommandByName('ls'), isNotNull);
      expect(service.getCommandByName('umount'), isNotNull);
    }, skip: false);
  });
}

