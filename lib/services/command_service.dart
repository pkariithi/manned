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
        'assets/data/stat.json',
        'assets/data/free.json',
        'assets/data/ip.json',
        'assets/data/journalctl.json',
        'assets/data/crontab.json',
        'assets/data/file.json',
        'assets/data/tee.json',
        'assets/data/tr.json',
        'assets/data/watch.json',
        'assets/data/date.json',
        'assets/data/basename.json',
        'assets/data/dirname.json',
        'assets/data/gzip.json',
        'assets/data/gunzip.json',
        'assets/data/unzip.json',
        'assets/data/xargs.json',
        'assets/data/uptime.json',
        'assets/data/id.json',
        'assets/data/hostname.json',
        'assets/data/cal.json',
        'assets/data/more.json',
        'assets/data/mount.json',
        'assets/data/lsblk.json',
        'assets/data/blkid.json',
        'assets/data/locate.json',
        'assets/data/updatedb.json',
        'assets/data/split.json',
        'assets/data/patch.json',
        'assets/data/join.json',
        'assets/data/paste.json',
        'assets/data/nl.json',
        'assets/data/killall.json',
        'assets/data/groups.json',
        'assets/data/netstat.json',
        'assets/data/ss.json',
        'assets/data/bg.json',
        'assets/data/fg.json',
        'assets/data/jobs.json',
        'assets/data/nice.json',
        'assets/data/traceroute.json',
        'assets/data/dig.json',
        'assets/data/chgrp.json',
        'assets/data/whereis.json',
        'assets/data/lscpu.json',
        'assets/data/lsof.json',
        'assets/data/sync.json',
        'assets/data/bzip2.json',
        'assets/data/vmstat.json',
        'assets/data/lsmem.json',
        'assets/data/lsusb.json',
        'assets/data/lspci.json',
        'assets/data/su.json',
        'assets/data/passwd.json',
        'assets/data/useradd.json',
        'assets/data/usermod.json',
        'assets/data/userdel.json',
        'assets/data/groupadd.json',
        'assets/data/groupdel.json',
        'assets/data/groupmod.json',
        'assets/data/ifconfig.json',
        'assets/data/host.json',
        'assets/data/nslookup.json',
        'assets/data/apt-cache.json',
        'assets/data/7z.json',
        'assets/data/bunzip2.json',
        'assets/data/bash.json',
        'assets/data/sh.json',
        'assets/data/export.json',
        'assets/data/alias.json',
        'assets/data/info.json',
        'assets/data/time.json',
        'assets/data/yes.json',
        'assets/data/exit.json',
        'assets/data/iostat.json',
        'assets/data/sar.json',
        'assets/data/fdisk.json',
        'assets/data/parted.json',
        'assets/data/mkfs.json',
        'assets/data/fsck.json',
        'assets/data/dd.json',
        'assets/data/systemd-analyze.json',
        'assets/data/logrotate.json',
        'assets/data/at.json',
        'assets/data/atq.json',
        'assets/data/atrm.json',
        'assets/data/apt-get.json',
        'assets/data/xz.json',
        'assets/data/env.json',
        'assets/data/umount.json',
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
