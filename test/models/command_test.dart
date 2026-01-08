import 'package:flutter_test/flutter_test.dart';
import 'package:manned_pages/models/command.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Command Model Tests', () {
    test('Command convenience getters work correctly', () {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'testcmd',
        category: 'Test Category',
        description: 'Test description',
        requiresInstallation: true,
      );

      expect(command.name, equals('testcmd'));
      expect(command.displayName, equals('testcmd - Test command'));
      expect(command.category, equals('Test Category'));
      expect(command.description, equals('Test description'));
      expect(command.requiresInstallation, isTrue);
      expect(command.installationCommand, equals('sudo apt install testcmd'));
    });

    test('Command fromJson parses complete JSON structure', () {
      final json = {
        'metadata': {
          'name': 'test',
          'displayName': 'test - Test command',
          'category': 'Test',
          'tags': ['test'],
          'description': 'Test description',
          'popularity': 5,
          'difficulty': 'beginner',
          'version': '1.0.0',
        },
        'installation': {
          'required': false,
          'status': 'built_in',
          'note': 'Built-in command',
        },
        'overview': {
          'summary': 'Test summary',
          'when_to_use': ['Use case 1'],
        },
        'syntax': {
          'basic': 'test [OPTIONS]',
          'description': 'Test syntax',
          'examples': ['test --help'],
        },
        'options': [
          {
            'flag': '--help',
            'short': '-h',
            'long': '--help',
            'description': 'Show help',
            'category': 'display',
            'example': 'test --help',
            'use_case': 'Display help',
          },
        ],
        'examples': [
          {
            'title': 'Basic usage',
            'command': 'test',
            'description': 'Basic example',
            'output': 'test output',
            'output_explanation': {
              'format': 'text',
              'elements': [
                {'element': 'output', 'meaning': 'Test output'},
              ],
              'notes': 'Test notes',
            },
            'use_case': 'Test use case',
          },
        ],
      };

      final command = Command.fromJson(json);

      expect(command.name, equals('test'));
      expect(command.displayName, equals('test - Test command'));
      expect(command.category, equals('Test'));
      expect(command.requiresInstallation, isFalse);
      expect(command.options.length, equals(1));
      expect(command.examples.length, equals(1));
    });

    test('Command fromJson handles optional fields', () {
      final json = {
        'metadata': {
          'name': 'test',
          'displayName': 'test - Test',
          'category': 'Test',
          'tags': ['test'],
          'description': 'Test',
          'popularity': 5,
          'difficulty': 'beginner',
          'version': '1.0.0',
        },
        'installation': {
          'required': false,
          'status': 'built_in',
        },
        'overview': {
          'summary': 'Test',
          'when_to_use': [],
        },
        'syntax': {
          'basic': 'test',
        },
        'options': [],
        'examples': [],
      };

      final command = Command.fromJson(json);

      expect(command.misconceptions, isNull);
      expect(command.commonPitfalls, isNull);
      expect(command.relatedCommands, isNull);
      expect(command.bestPractices, isNull);
      expect(command.performanceTips, isNull);
      expect(command.additionalNotes, isNull);
    });

    test('Command fromJson parses optional fields when present', () {
      final json = {
        'metadata': {
          'name': 'test',
          'displayName': 'test - Test',
          'category': 'Test',
          'tags': ['test'],
          'description': 'Test',
          'popularity': 5,
          'difficulty': 'beginner',
          'version': '1.0.0',
        },
        'installation': {
          'required': false,
          'status': 'built_in',
        },
        'overview': {
          'summary': 'Test',
          'when_to_use': [],
        },
        'syntax': {
          'basic': 'test',
        },
        'options': [],
        'examples': [],
        'misconceptions': [
          {
            'title': 'Test misconception',
            'misconception': 'Wrong',
            'reality': 'Correct',
            'tip': 'Tip',
          },
        ],
        'common_pitfalls': [
          {
            'issue': 'Pitfall',
            'description': 'Description',
            'solution': 'Solution',
          },
        ],
        'related_commands': [
          {
            'command': 'related',
            'relationship': 'Related',
            'description': 'Description',
          },
        ],
        'best_practices': ['Practice 1', 'Practice 2'],
        'performance_tips': ['Tip 1', 'Tip 2'],
        'additional_notes': {
          'note1': 'Value 1',
          'note2': 'Value 2',
        },
      };

      final command = Command.fromJson(json);

      expect(command.misconceptions, isNotNull);
      expect(command.misconceptions!.length, equals(1));
      expect(command.commonPitfalls, isNotNull);
      expect(command.commonPitfalls!.length, equals(1));
      expect(command.relatedCommands, isNotNull);
      expect(command.relatedCommands!.length, equals(1));
      expect(command.bestPractices, isNotNull);
      expect(command.bestPractices!.length, equals(2));
      expect(command.performanceTips, isNotNull);
      expect(command.performanceTips!.length, equals(2));
      expect(command.additionalNotes, isNotNull);
      expect(command.additionalNotes!['note1'], equals('Value 1'));
    });

    test('Command installationCommand returns null when not required', () {
      final command = TestCommandBuilder.createSimpleCommand(
        requiresInstallation: false,
      );

      expect(command.requiresInstallation, isFalse);
      expect(command.installationCommand, isNull);
    });

    test('Command installationCommand returns command when required', () {
      final command = TestCommandBuilder.createSimpleCommand(
        name: 'testpkg',
        requiresInstallation: true,
      );

      expect(command.requiresInstallation, isTrue);
      expect(command.installationCommand, equals('sudo apt install testpkg'));
    });
  });

  group('Metadata Tests', () {
    test('Metadata fromJson parses all fields', () {
      final json = {
        'name': 'test',
        'displayName': 'test - Test',
        'category': 'Test',
        'tags': ['tag1', 'tag2'],
        'description': 'Description',
        'popularity': 10,
        'difficulty': 'advanced',
        'version': '2.0.0',
      };

      final metadata = Metadata.fromJson(json);

      expect(metadata.name, equals('test'));
      expect(metadata.displayName, equals('test - Test'));
      expect(metadata.category, equals('Test'));
      expect(metadata.tags, equals(['tag1', 'tag2']));
      expect(metadata.description, equals('Description'));
      expect(metadata.popularity, equals(10));
      expect(metadata.difficulty, equals('advanced'));
      expect(metadata.version, equals('2.0.0'));
    });
  });

  group('Installation Tests', () {
    test('Installation fromJson parses with package', () {
      final json = {
        'required': true,
        'status': 'installable',
        'package': {
          'name': 'testpkg',
          'manager': 'apt',
          'command': 'sudo apt install testpkg',
        },
        'note': 'Requires installation',
      };

      final installation = Installation.fromJson(json);

      expect(installation.required, isTrue);
      expect(installation.status, equals('installable'));
      expect(installation.package, isNotNull);
      expect(installation.package!.name, equals('testpkg'));
      expect(installation.package!.command, equals('sudo apt install testpkg'));
      expect(installation.note, equals('Requires installation'));
    });

    test('Installation fromJson parses without package', () {
      final json = {
        'required': false,
        'status': 'built_in',
        'note': 'Built-in',
      };

      final installation = Installation.fromJson(json);

      expect(installation.required, isFalse);
      expect(installation.status, equals('built_in'));
      expect(installation.package, isNull);
      expect(installation.note, equals('Built-in'));
    });
  });

  group('Option Tests', () {
    test('Option fromJson parses all fields', () {
      final json = {
        'flag': '--help',
        'short': '-h',
        'long': '--help',
        'description': 'Show help',
        'category': 'display',
        'example': 'cmd --help',
        'use_case': 'Display help information',
      };

      final option = Option.fromJson(json);

      expect(option.flag, equals('--help'));
      expect(option.short, equals('-h'));
      expect(option.long, equals('--help'));
      expect(option.description, equals('Show help'));
      expect(option.category, equals('display'));
      expect(option.example, equals('cmd --help'));
      expect(option.useCase, equals('Display help information'));
    });

    test('Option fromJson handles optional fields', () {
      final json = {
        'flag': '--verbose',
        'description': 'Verbose output',
      };

      final option = Option.fromJson(json);

      expect(option.flag, equals('--verbose'));
      expect(option.description, equals('Verbose output'));
      expect(option.short, isNull);
      expect(option.long, isNull);
      expect(option.category, isNull);
      expect(option.example, isNull);
      expect(option.useCase, isNull);
    });
  });

  group('Example Tests', () {
    test('Example fromJson parses all fields', () {
      final json = {
        'title': 'Basic usage',
        'command': 'ls',
        'description': 'List files',
        'output': 'file1.txt\nfile2.txt',
        'output_explanation': {
          'format': 'text',
          'elements': [
            {'element': 'file1.txt', 'meaning': 'First file'},
          ],
          'notes': 'Output notes',
        },
        'use_case': 'List directory contents',
      };

      final example = Example.fromJson(json);

      expect(example.title, equals('Basic usage'));
      expect(example.command, equals('ls'));
      expect(example.description, equals('List files'));
      expect(example.output, equals('file1.txt\nfile2.txt'));
      expect(example.outputExplanation, isNotNull);
      expect(example.useCase, equals('List directory contents'));
    });

    test('Example fromJson handles optional fields', () {
      final json = {
        'title': 'Basic',
        'command': 'cmd',
        'description': 'Description',
      };

      final example = Example.fromJson(json);

      expect(example.title, equals('Basic'));
      expect(example.command, equals('cmd'));
      expect(example.description, equals('Description'));
      expect(example.output, isNull);
      expect(example.outputExplanation, isNull);
      expect(example.useCase, isNull);
    });
  });
}

