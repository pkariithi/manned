import 'package:manned_pages/models/command.dart';

/// Helper class to create test Command objects for testing
class TestCommandBuilder {
  static Command createSimpleCommand({
    String name = 'test',
    String category = 'Test Category',
    String description = 'Test description',
    bool requiresInstallation = false,
  }) {
    return Command(
      metadata: Metadata(
        name: name,
        displayName: '$name - Test command',
        category: category,
        tags: ['test'],
        description: description,
        popularity: 5,
        difficulty: 'beginner',
        version: '1.0.0',
      ),
      installation: Installation(
        required: requiresInstallation,
        status: requiresInstallation ? 'installable' : 'built_in',
        note: requiresInstallation ? 'Requires installation' : 'Built-in command',
        package: requiresInstallation
            ? InstallationPackage(
                name: name,
                manager: 'apt',
                command: 'sudo apt install $name',
              )
            : null,
      ),
      overview: Overview(
        summary: 'Test command summary',
        whenToUse: ['Test use case'],
      ),
      syntax: Syntax(
        basic: '$name [OPTIONS]',
        description: 'Test syntax description',
        examples: ['$name --help'],
      ),
      options: [
        Option(
          flag: '--help',
          short: '-h',
          long: '--help',
          description: 'Show help',
          category: 'display',
          example: '$name --help',
          useCase: 'Display help information',
        ),
      ],
      examples: [
        Example(
          title: 'Basic usage',
          command: name,
          description: 'Basic test example',
          output: 'test output',
          outputExplanation: {
            'format': 'text',
            'elements': [
              {
                'element': 'output',
                'meaning': 'Test output',
              },
            ],
            'notes': 'Test notes',
          },
          useCase: 'Test use case',
        ),
      ],
    );
  }

  static Command createCommandWithAllFields({
    String name = 'fulltest',
    String category = 'Full Test Category',
  }) {
    return Command(
      metadata: Metadata(
        name: name,
        displayName: '$name - Full test command',
        category: category,
        tags: ['test', 'full'],
        description: 'Full test command with all fields',
        popularity: 10,
        difficulty: 'intermediate',
        version: '2.0.0',
      ),
      installation: Installation(
        required: true,
        status: 'installable',
        note: 'Requires installation',
        package: InstallationPackage(
          name: name,
          manager: 'apt',
          command: 'sudo apt install $name',
        ),
      ),
      overview: Overview(
        summary: 'Full test command summary with all fields populated',
        whenToUse: [
          'Use case 1',
          'Use case 2',
          'Use case 3',
        ],
      ),
      syntax: Syntax(
        basic: '$name [OPTIONS] [FILE]',
        description: 'Full syntax description',
        examples: [
          '$name --help',
          '$name file.txt',
        ],
      ),
      options: [
        Option(
          flag: '--help',
          short: '-h',
          long: '--help',
          description: 'Show help',
          category: 'display',
          example: '$name --help',
          useCase: 'Display help information',
        ),
        Option(
          flag: '--version',
          short: '-v',
          long: '--version',
          description: 'Show version',
          category: 'display',
          example: '$name --version',
          useCase: 'Display version information',
        ),
      ],
      examples: [
        Example(
          title: 'Example 1',
          command: '$name --help',
          description: 'First example',
          output: 'Help output',
          outputExplanation: {
            'format': 'text',
            'elements': [
              {
                'element': 'help',
                'meaning': 'Help text',
              },
            ],
            'notes': 'Example notes',
          },
          useCase: 'Get help',
        ),
      ],
      misconceptions: [
        Misconception(
          title: 'Test misconception',
          misconception: 'Wrong understanding',
          reality: 'Correct understanding',
          tip: 'Helpful tip',
        ),
      ],
      commonPitfalls: [
        Pitfall(
          issue: 'Test pitfall',
          description: 'Pitfall description',
          solution: 'Pitfall solution',
        ),
      ],
      relatedCommands: [
        RelatedCommand(
          command: 'related',
          relationship: 'Related to this command',
          description: 'Related command description',
        ),
      ],
      bestPractices: [
        'Best practice 1',
        'Best practice 2',
      ],
      performanceTips: [
        'Performance tip 1',
        'Performance tip 2',
      ],
      additionalNotes: {
        'note1': 'Note value 1',
        'note2': 'Note value 2',
      },
    );
  }
}

