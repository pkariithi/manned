import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import '../models/command.dart';
import '../services/command_service.dart';

class CommandDetails extends StatefulWidget {
  final Command command;
  final bool showJsonView;

  const CommandDetails({
    super.key,
    required this.command,
    this.showJsonView = false,
  });

  @override
  State<CommandDetails> createState() => _CommandDetailsState();
}

class _CommandDetailsState extends State<CommandDetails> {
  late final ScrollController _scrollController;
  final CommandService _commandService = CommandService();
  String? _jsonString;
  bool _isLoadingJson = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Load JSON when widget is initialized if JSON view is enabled
    if (widget.showJsonView) {
      _loadJson();
    }
  }

  Future<void> _loadJson() async {
    if (_isLoadingJson || _jsonString != null) return;

    setState(() {
      _isLoadingJson = true;
    });

    try {
      final json = await _commandService.getCommandJson(widget.command.name);
      if (mounted) {
        setState(() {
          _jsonString = json;
          _isLoadingJson = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingJson = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(CommandDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If command changed, scroll to top
    if (oldWidget.command != widget.command) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
    // Reload JSON if command changed or JSON view was toggled
    if (widget.showJsonView &&
        (oldWidget.command.name != widget.command.name ||
            oldWidget.showJsonView != widget.showJsonView)) {
      _jsonString = null;
      _loadJson();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Copied to clipboard'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Map<String, TextStyle> _getHighlightTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseTextStyle = const TextStyle(
      fontFamily: 'Ubuntu Mono',
      fontSize: 13,
    );

    if (isDark) {
      return {
        'root': baseTextStyle.copyWith(
          color: const Color(0xFFd4d4d4),
          backgroundColor: const Color(0xFF1e1e1e),
        ),
        'comment': baseTextStyle.copyWith(color: const Color(0xFF6a9955)),
        'quote': baseTextStyle.copyWith(color: const Color(0xFF6a9955)),
        'variable': baseTextStyle.copyWith(color: const Color(0xFF9cdcfe)),
        'template-variable': baseTextStyle.copyWith(
          color: const Color(0xFF9cdcfe),
        ),
        'tag': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'name': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'selector-id': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'selector-class': baseTextStyle.copyWith(
          color: const Color(0xFF569cd6),
        ),
        'regexp': baseTextStyle.copyWith(color: const Color(0xFFd16969)),
        'deletion': baseTextStyle.copyWith(color: const Color(0xFFce9178)),
        'number': baseTextStyle.copyWith(color: const Color(0xFFb5cea8)),
        'built_in': baseTextStyle.copyWith(color: const Color(0xFF4ec9b0)),
        'builtin-name': baseTextStyle.copyWith(color: const Color(0xFF4ec9b0)),
        'literal': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'type': baseTextStyle.copyWith(color: const Color(0xFF4ec9b0)),
        'params': baseTextStyle.copyWith(color: const Color(0xFFd4d4d4)),
        'meta': baseTextStyle.copyWith(color: const Color(0xFFd4d4d4)),
        'link': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'attribute': baseTextStyle.copyWith(color: const Color(0xFF9cdcfe)),
        'string': baseTextStyle.copyWith(color: const Color(0xFFce9178)),
        'symbol': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'bullet': baseTextStyle.copyWith(color: const Color(0xFFd4d4d4)),
        'addition': baseTextStyle.copyWith(color: const Color(0xFFb5cea8)),
        'title': baseTextStyle.copyWith(color: const Color(0xFFd7ba7d)),
        'section': baseTextStyle.copyWith(color: const Color(0xFFd7ba7d)),
        'keyword': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'selector-tag': baseTextStyle.copyWith(color: const Color(0xFF569cd6)),
        'function': baseTextStyle.copyWith(color: const Color(0xFFdcdcaa)),
        'punctuation': baseTextStyle.copyWith(color: const Color(0xFFd4d4d4)),
      };
    } else {
      return {
        'root': baseTextStyle.copyWith(
          color: const Color(0xFF24292e),
          backgroundColor: const Color(0xFFf6f8fa),
        ),
        'comment': baseTextStyle.copyWith(color: const Color(0xFF6a737d)),
        'quote': baseTextStyle.copyWith(color: const Color(0xFF6a737d)),
        'variable': baseTextStyle.copyWith(color: const Color(0xFFe36209)),
        'template-variable': baseTextStyle.copyWith(
          color: const Color(0xFFe36209),
        ),
        'tag': baseTextStyle.copyWith(color: const Color(0xFF22863a)),
        'name': baseTextStyle.copyWith(color: const Color(0xFF22863a)),
        'selector-id': baseTextStyle.copyWith(color: const Color(0xFF22863a)),
        'selector-class': baseTextStyle.copyWith(
          color: const Color(0xFF22863a),
        ),
        'regexp': baseTextStyle.copyWith(color: const Color(0xFF032f62)),
        'deletion': baseTextStyle.copyWith(color: const Color(0xFFb31d28)),
        'number': baseTextStyle.copyWith(color: const Color(0xFF005cc5)),
        'built_in': baseTextStyle.copyWith(color: const Color(0xFF005cc5)),
        'builtin-name': baseTextStyle.copyWith(color: const Color(0xFF005cc5)),
        'literal': baseTextStyle.copyWith(color: const Color(0xFF005cc5)),
        'type': baseTextStyle.copyWith(color: const Color(0xFF005cc5)),
        'params': baseTextStyle.copyWith(color: const Color(0xFF24292e)),
        'meta': baseTextStyle.copyWith(color: const Color(0xFF24292e)),
        'link': baseTextStyle.copyWith(color: const Color(0xFF032f62)),
        'attribute': baseTextStyle.copyWith(color: const Color(0xFFe36209)),
        'string': baseTextStyle.copyWith(color: const Color(0xFF032f62)),
        'symbol': baseTextStyle.copyWith(color: const Color(0xFF005cc5)),
        'bullet': baseTextStyle.copyWith(color: const Color(0xFF24292e)),
        'addition': baseTextStyle.copyWith(color: const Color(0xFF22863a)),
        'title': baseTextStyle.copyWith(color: const Color(0xFF6f42c1)),
        'section': baseTextStyle.copyWith(color: const Color(0xFF6f42c1)),
        'keyword': baseTextStyle.copyWith(color: const Color(0xFFd73a49)),
        'selector-tag': baseTextStyle.copyWith(color: const Color(0xFF22863a)),
        'function': baseTextStyle.copyWith(color: const Color(0xFF6f42c1)),
        'punctuation': baseTextStyle.copyWith(color: const Color(0xFF24292e)),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    // If JSON view is enabled, show raw JSON
    if (widget.showJsonView) {
      // Load JSON string if not already loaded
      if (_jsonString == null && !_isLoadingJson) {
        _isLoadingJson = true;
        _commandService
            .getCommandJson(widget.command.name)
            .then((json) {
              if (mounted) {
                setState(() {
                  _jsonString = json;
                  _isLoadingJson = false;
                });
              }
            })
            .catchError((e) {
              if (mounted) {
                setState(() {
                  _isLoadingJson = false;
                });
              }
            });
      }

      // Show loading or error state
      if (_jsonString == null) {
        return Center(
          child: _isLoadingJson
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading JSON',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
        );
      }

      return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.code,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Raw JSON View',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy JSON',
                    onPressed: () => _copyToClipboard(context, _jsonString!),
                  ),
                ],
              ),
              const Divider(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1e1e1e)
                      : const Color(0xFFf6f8fa),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: HighlightView(
                      _jsonString!,
                      language: 'json',
                      theme: _getHighlightTheme(context),
                      padding: const EdgeInsets.all(16),
                      textStyle: const TextStyle(
                        fontFamily: 'Ubuntu Mono',
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Get overview summary (using overview.summary instead of overview property)
    final overviewText = widget.command.overview.summary;

    // Get syntax (using syntax.basic instead of syntax property)
    final syntaxText = widget.command.syntax.basic;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with improved styling
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.command.name[0].toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.command.displayName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.command.category,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ...widget.command.tags
                                .take(4)
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                            if (widget.command.requiresInstallation)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      size: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onErrorContainer,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Install Required',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onErrorContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Installation Instructions (if required)
          if (widget.command.requiresInstallation) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.install_desktop_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Installation Required',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.command.installation.note ??
                        'This command needs to be installed before use.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            widget.command.installationCommand ?? '',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: () => _copyToClipboard(
                            context,
                            widget.command.installationCommand ?? '',
                          ),
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('Copy'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Overview
          _SectionTitle(title: 'Overview', icon: Icons.info_outline),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overviewText,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  if (widget.command.overview.whenToUse.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'When to use:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.command.overview.whenToUse.map(
                      (use) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                use,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Syntax
          _SectionTitle(title: 'Syntax', icon: Icons.code),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    syntaxText,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: () => _copyToClipboard(context, syntaxText),
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy syntax',
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Common Options
          _SectionTitle(title: 'Common Options', icon: Icons.tune),
          const SizedBox(height: 12),
          ...widget.command.options.map(
            (option) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    option.flag,
                    style: TextStyle(
                      fontFamily: 'Ubuntu Mono',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    option.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  if (option.useCase != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              option.useCase!,
                              style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Examples
          _SectionTitle(title: 'Examples', icon: Icons.lightbulb_outline),
          const SizedBox(height: 12),
          ...widget.command.examples.asMap().entries.map((entry) {
            final index = entry.key;
            final example = entry.value;
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Example ${index + 1}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            example.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      example.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SelectableText(
                              example.command,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filled(
                            onPressed: () =>
                                _copyToClipboard(context, example.command),
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: 'Copy command',
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (example.output != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Output:',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                        child: SelectableText(
                          example.output!,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                    if (example.outputExplanation != null) ...[
                      const SizedBox(height: 16),
                      ExpansionTile(
                        title: Text(
                          'Output Explanation',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        initiallyExpanded: false,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildOutputExplanation(
                              example.outputExplanation!,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (example.useCase != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.help_outline,
                              size: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Use case: ${example.useCase!}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 32),

          // Misconceptions
          if (widget.command.misconceptions != null &&
              widget.command.misconceptions!.isNotEmpty) ...[
            _SectionTitle(
              title: 'Common Misconceptions',
              icon: Icons.error_outline,
            ),
            const SizedBox(height: 12),
            ...widget.command.misconceptions!.map(
              (misconception) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        misconception.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.close,
                            size: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Misconception: ${misconception.misconception}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Reality: ${misconception.reality}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      if (misconception.tip != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 18,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tip: ${misconception.tip!}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Common Pitfalls
          if (widget.command.commonPitfalls != null &&
              widget.command.commonPitfalls!.isNotEmpty) ...[
            _SectionTitle(
              title: 'Common Pitfalls',
              icon: Icons.warning_amber_rounded,
            ),
            const SizedBox(height: 12),
            ...widget.command.commonPitfalls!.map(
              (pitfall) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            size: 20,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              pitfall.issue,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        pitfall.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Solution: ${pitfall.solution}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Best Practices
          if (widget.command.bestPractices != null &&
              widget.command.bestPractices!.isNotEmpty) ...[
            _SectionTitle(title: 'Best Practices', icon: Icons.star_outline),
            const SizedBox(height: 12),
            ...widget.command.bestPractices!.map(
              (practice) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          practice,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Performance Tips
          if (widget.command.performanceTips != null &&
              widget.command.performanceTips!.isNotEmpty) ...[
            _SectionTitle(title: 'Performance Tips', icon: Icons.speed),
            const SizedBox(height: 12),
            ...widget.command.performanceTips!.map(
              (tip) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tip,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Additional Notes
          if (widget.command.additionalNotes != null &&
              widget.command.additionalNotes!.isNotEmpty) ...[
            _SectionTitle(title: 'Additional Notes', icon: Icons.note_outlined),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.command.additionalNotes!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key
                                  .replaceAll('_', ' ')
                                  .split(' ')
                                  .map(
                                    (word) => word.isEmpty
                                        ? word
                                        : word[0].toUpperCase() +
                                              word.substring(1),
                                  )
                                  .join(' '),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              entry.value.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Related Commands
          if (widget.command.relatedCommands != null &&
              widget.command.relatedCommands!.isNotEmpty) ...[
            _SectionTitle(title: 'Related Commands', icon: Icons.link),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...widget.command.relatedCommands!.map(
                  (related) => Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.code,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                related.command,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            related.relationship,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            related.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOutputExplanation(
    Map<String, dynamic> explanation,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (explanation['format'] != null) ...[
          Text(
            'Format:',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            explanation['format'].toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
        ],
        if (explanation['elements'] != null) ...[
          Text(
            'Elements:',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...(explanation['elements'] as List<dynamic>).map((element) {
            final elem = element as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (elem['element'] != null)
                    Text(
                      elem['element'].toString(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  if (elem['meaning'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '→ ${elem['meaning']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
        if (explanation['notes'] != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              explanation['notes'].toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
