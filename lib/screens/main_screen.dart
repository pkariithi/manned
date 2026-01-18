import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';
import '../models/command.dart';
import '../services/command_service.dart';
import '../widgets/command_list.dart';
import '../widgets/command_details.dart';
import '../widgets/about_dialog.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;

  const MainScreen({super.key, this.onThemeToggle});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CommandService _commandService = CommandService();
  final TextEditingController _searchController = TextEditingController();

  List<Command> _filteredCommands = [];
  Command? _selectedCommand;
  bool _isLoading = true;
  String? _error;
  bool _showJsonView = false;
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _loadCommands();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCommands() async {
    try {
      await _commandService.loadCommands();
      final commands = _commandService.getAllCommands();

      setState(() {
        _filteredCommands = commands;
        _isLoading = false;
        // Select first command by default
        if (_filteredCommands.isNotEmpty) {
          _selectedCommand = _filteredCommands.first;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load commands: $e';
        _isLoading = false;
      });
    }
  }

  void _onCommandSelected(Command command) {
    setState(() {
      _selectedCommand = command;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredCommands = _commandService.searchCommands(query);
      // If current selection is not in filtered results, select first result
      if (_filteredCommands.isNotEmpty) {
        if (!_filteredCommands.contains(_selectedCommand)) {
          _selectedCommand = _filteredCommands.first;
        }
      } else {
        _selectedCommand = null;
      }
    });
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => const MannedPagesAboutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          tooltip: _showSearchBar ? 'Hide Search' : 'Show Search',
          onPressed: () {
            setState(() {
              _showSearchBar = !_showSearchBar;
            });
          },
        ),
        title: const Text('Manned Pages'),
        actions: [
          // JSON/UI View Toggle
          if (_selectedCommand != null)
            IconButton(
              icon: Icon(_showJsonView ? Icons.code_off : Icons.code),
              tooltip: _showJsonView ? 'Show UI View' : 'Show JSON View',
              onPressed: () {
                setState(() {
                  _showJsonView = !_showJsonView;
                });
              },
            ),
          // Theme Toggle
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: Theme.of(context).brightness == Brightness.dark
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
            onPressed: widget.onThemeToggle,
          ),
          // Menu button
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCommands,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                // Left pane - Command list
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: CommandList(
                    commands: _filteredCommands,
                    selectedCommand: _selectedCommand,
                    onCommandSelected: _onCommandSelected,
                    searchController: _searchController,
                    onSearchChanged: _onSearchChanged,
                    showSearchBar: _showSearchBar,
                  ),
                ),
                // Right pane - Command details
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: _filteredCommands.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No commands found',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search query',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : _selectedCommand != null
                        ? CommandDetails(
                            command: _selectedCommand!,
                            showJsonView: _showJsonView,
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 64,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Select a command to view details',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
