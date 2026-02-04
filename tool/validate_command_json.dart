// Run from project root: dart run tool/validate_command_json.dart
// Validates all assets/data/*.json files match the schema expected by Command.fromJson.

import 'dart:convert';
import 'dart:io';

void main() {
  final dataDir = Directory('assets/data');
  if (!dataDir.existsSync()) {
    print('Error: assets/data directory not found. Run from project root.');
    exit(1);
  }

  final jsonFiles = dataDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (jsonFiles.isEmpty) {
    print('No JSON files found in assets/data');
    exit(0);
  }

  int errors = 0;
  for (final file in jsonFiles) {
    final name = file.uri.pathSegments.last;
    try {
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Required top-level keys
      for (final key in ['metadata', 'installation', 'overview', 'syntax', 'options', 'examples']) {
        if (!json.containsKey(key)) {
          print('$name: missing required key "$key"');
          errors++;
        }
      }

      // options must be List
      if (json.containsKey('options')) {
        if (json['options'] is! List) {
          print('$name: "options" must be an array (List), got ${json['options'].runtimeType}');
          errors++;
        }
      }

      // examples must be List
      if (json.containsKey('examples')) {
        if (json['examples'] is! List) {
          print('$name: "examples" must be an array (List), got ${json['examples'].runtimeType}');
          errors++;
        }
      }

      // Optional array fields must be List when present
      for (final key in ['misconceptions', 'common_pitfalls', 'related_commands', 'best_practices', 'performance_tips']) {
        if (json[key] != null && json[key] is! List) {
          print('$name: "$key" must be an array (List) when present, got ${json[key].runtimeType}');
          errors++;
        }
      }

      // additional_notes must be Map when present
      if (json['additional_notes'] != null && json['additional_notes'] is! Map) {
        print('$name: "additional_notes" must be an object (Map) when present, got ${json['additional_notes'].runtimeType}');
        errors++;
      }
    } catch (e, st) {
      print('$name: parse/validate error: $e');
      if (e is FormatException) print('  (invalid JSON)');
      errors++;
    }
  }

  if (errors > 0) {
    print('\nTotal: $errors error(s) in ${jsonFiles.length} file(s).');
    exit(1);
  }
  print('OK: All ${jsonFiles.length} command JSON files passed validation.');
}
