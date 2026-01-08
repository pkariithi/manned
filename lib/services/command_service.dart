import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/command.dart';

class CommandService {
  final List<Command> _allCommands = [];
  bool _isLoaded = false;

  Future<void> loadCommands() async {
    if (_isLoaded) return;

    try {
      // List of JSON files in assets/data/
      // These are bundled with the app and specified in pubspec.yaml
      final dataFiles = [
        'assets/data/ls.json',
        'assets/data/htop.json',
        'assets/data/find.json',
        'assets/data/ps.json',
        'assets/data/cd.json',
        'assets/data/pwd.json',
        'assets/data/cp.json',
        'assets/data/mv.json',
        'assets/data/rm.json',
        'assets/data/mkdir.json',
        'assets/data/rmdir.json',
        'assets/data/cat.json',
        'assets/data/grep.json',
        'assets/data/tree.json',
        'assets/data/kill.json',
        'assets/data/whoami.json',
        'assets/data/apt.json',
        'assets/data/history.json',
        'assets/data/clear.json',
        'assets/data/man.json',
        'assets/data/which.json',
        'assets/data/sudo.json',
        'assets/data/chmod.json',
        'assets/data/tail.json',
        'assets/data/head.json',
        'assets/data/touch.json',
        'assets/data/df.json',
        'assets/data/du.json',
        'assets/data/less.json',
        'assets/data/tar.json',
        'assets/data/chown.json',
        'assets/data/wget.json',
        'assets/data/curl.json',
        'assets/data/ssh.json',
        'assets/data/nano.json',
        'assets/data/sed.json',
        'assets/data/awk.json',
        'assets/data/ln.json',
        'assets/data/systemctl.json',
        'assets/data/ping.json',
        'assets/data/scp.json',
        'assets/data/rsync.json',
        'assets/data/uname.json',
        'assets/data/top.json',
        'assets/data/sort.json',
        'assets/data/uniq.json',
        'assets/data/wc.json',
        'assets/data/cut.json',
        'assets/data/diff.json',
        'assets/data/zip.json',
      ];

      // Load and parse each file
      for (final file in dataFiles) {
        try {
          final jsonString = await rootBundle.loadString(file);
          final jsonData = json.decode(jsonString) as Map<String, dynamic>;
          final command = Command.fromJson(jsonData);
          _allCommands.add(command);
        } catch (e) {
          // Log error but continue loading other files
          debugPrint('Error loading command from $file: $e');
        }
      }

      // Sort commands by popularity (highest first)
      _allCommands.sort(
        (a, b) => b.metadata.popularity.compareTo(a.metadata.popularity),
      );

      _isLoaded = true;
    } catch (e) {
      debugPrint('Error loading commands: $e');
      rethrow;
    }
  }

  List<Command> getAllCommands() {
    if (!_isLoaded) {
      throw StateError('Commands not loaded. Call loadCommands() first.');
    }
    return List.unmodifiable(_allCommands);
  }

  List<Command> getCommandsByCategory(String category) {
    return getAllCommands().where((c) => c.category == category).toList();
  }

  Command? getCommandByName(String name) {
    try {
      return getAllCommands().firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Command> searchCommands(String query) {
    if (query.isEmpty) return getAllCommands();

    final lowerQuery = query.toLowerCase().trim();
    return getAllCommands().where((command) {
      // Search in multiple fields
      return command.name.toLowerCase().contains(lowerQuery) ||
          command.displayName.toLowerCase().contains(lowerQuery) ||
          command.category.toLowerCase().contains(lowerQuery) ||
          command.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          command.description.toLowerCase().contains(lowerQuery) ||
          command.overview.summary.toLowerCase().contains(lowerQuery) ||
          command.syntax.basic.toLowerCase().contains(lowerQuery) ||
          command.options.any(
            (opt) =>
                opt.description.toLowerCase().contains(lowerQuery) ||
                opt.flag.toLowerCase().contains(lowerQuery),
          ) ||
          command.examples.any(
            (ex) =>
                ex.title.toLowerCase().contains(lowerQuery) ||
                ex.description.toLowerCase().contains(lowerQuery) ||
                ex.command.toLowerCase().contains(lowerQuery),
          ) ||
          false;
    }).toList();
  }

  List<String> getAllCategories() {
    final categories = getAllCommands().map((c) => c.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Get the raw JSON string for a command by reading the original asset file
  Future<String> getCommandJson(String commandName) async {
    try {
      final filePath = 'assets/data/$commandName.json';
      final jsonString = await rootBundle.loadString(filePath);
      return jsonString;
    } catch (e) {
      debugPrint('Error loading JSON for $commandName: $e');
      rethrow;
    }
  }
}
