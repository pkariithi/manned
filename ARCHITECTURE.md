# Data Architecture & Search Strategy

## Overview

This document explains how the application handles JSON data files and performs search operations across command documentation.

## Data Loading Strategy

### Approach: In-Memory Loading

**Strategy**: Load all JSON files into memory at application startup
- **Why**: With ~100 commands, total data size is manageable (estimated 3-5MB)
- **Benefits**:
  - Fast, instant searches (no file I/O during search)
  - Simple implementation
  - Works offline (data bundled with app)
- **Memory Impact**: Minimal (~3-5MB for 100 commands)

### Loading Process

1. **Asset Configuration** (pubspec.yaml):
   ```yaml
   flutter:
     assets:
       - assets/data/
   ```

2. **Load all JSON files at startup**:
   - Discover all `.json` files in `assets/data/`
   - Parse each JSON file into Dart objects
   - Store in an in-memory collection (List<Command>)
   - Index for fast searching (optional optimization)

## Data Models

### Command Model Structure

```dart
class Command {
  final String name;                    // "ls", "htop", etc.
  final String displayName;             // "ls - List directory contents"
  final String category;                // "File & Directory Operations"
  final List<String> tags;              // ["files", "directory", "basic"]
  final InstallationInfo installation;
  final OverviewInfo overview;
  final SyntaxInfo syntax;
  final List<Option> options;
  final List<Example> examples;
  final List<Misconception> misconceptions;
  final List<Pitfall> commonPitfalls;
  final List<RelatedCommand> relatedCommands;
  // ... other fields
}
```

### Searchable Fields

For full-text search, we'll search across these fields:
- `name` (command name)
- `displayName`
- `category`
- `tags` (all tags)
- `description`
- `overview.summary`
- `overview.when_to_use` (all items)
- `syntax.basic`
- `options[].description`
- `examples[].title`
- `examples[].description`
- `misconceptions[].title`
- `misconceptions[].reality`

## Search Implementation

### Full-Text Search Strategy

**Option 1: Simple String Matching (Recommended for MVP)**
```dart
List<Command> searchCommands(String query) {
  final lowerQuery = query.toLowerCase();
  return allCommands.where((command) {
    // Search in multiple fields
    return
      command.name.toLowerCase().contains(lowerQuery) ||
      command.displayName.toLowerCase().contains(lowerQuery) ||
      command.category.toLowerCase().contains(lowerQuery) ||
      command.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
      command.overview.summary.toLowerCase().contains(lowerQuery) ||
      command.options.any((opt) => opt.description.toLowerCase().contains(lowerQuery)) ||
      // ... more fields
      false;
  }).toList();
}
```

**Option 2: Weighted Search (Better UX)**
- Weight matches differently based on field:
  - `name` match: 10 points (highest priority)
  - `displayName` match: 8 points
  - `category` match: 5 points
  - `tags` match: 6 points
  - `description` match: 4 points
  - `examples` match: 3 points
  - Other fields: 2 points
- Sort results by relevance score

**Option 3: Search Index (Optimization for large datasets)**
- Build an inverted index at startup
- Map keywords to commands
- Fast lookups for exact matches
- Combine with fuzzy matching for partial matches

### Search Types

1. **Name/Command Search**:
   - Exact match on command name: `query == "ls"`
   - Case-insensitive partial: `"htop".contains("top")`

2. **Category Filter**:
   - Filter by category: `commands.where((c) => c.category == selectedCategory)`

3. **Tag Filter**:
   - Filter by tags: `commands.where((c) => c.tags.contains(tag))`

4. **Full-Text Search**:
   - Search across all searchable fields
   - Case-insensitive
   - Supports partial matches

5. **Combined Search**:
   - Combine filters: `category + tag + text search`
   - Example: "File Operations" + "files" tag + "search" query

## Architecture

### Service Layer Structure

```
lib/
├── models/
│   ├── command.dart              # Command data model
│   ├── installation_info.dart    # Installation data model
│   ├── option.dart               # Option data model
│   ├── example.dart              # Example data model
│   └── ...
├── services/
│   ├── command_service.dart      # Loads and manages commands
│   └── search_service.dart       # Handles search logic
├── repositories/
│   └── command_repository.dart   # Data access layer
└── ...
```

### Command Service

```dart
class CommandService {
  List<Command> _allCommands = [];
  bool _isLoaded = false;

  Future<void> loadCommands() async {
    if (_isLoaded) return;

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter JSON files in assets/data/
    final dataFiles = manifestMap.keys
        .where((String key) => key.contains('assets/data/') && key.endsWith('.json'))
        .toList();

    // Load and parse each file
    for (final file in dataFiles) {
      final jsonString = await rootBundle.loadString(file);
      final jsonData = json.decode(jsonString);
      _allCommands.add(Command.fromJson(jsonData));
    }

    _isLoaded = true;
  }

  List<Command> getAllCommands() => _allCommands;
  List<Command> getCommandsByCategory(String category) {
    return _allCommands.where((c) => c.category == category).toList();
  }
  Command? getCommandByName(String name) {
    return _allCommands.firstWhere(
      (c) => c.name == name,
      orElse: () => null,
    );
  }
}
```

### Search Service

```dart
class SearchService {
  final CommandService _commandService;

  SearchService(this._commandService);

  List<Command> search(String query, {
    String? category,
    String? tag,
  }) {
    var results = _commandService.getAllCommands();

    // Apply category filter
    if (category != null) {
      results = results.where((c) => c.category == category).toList();
    }

    // Apply tag filter
    if (tag != null) {
      results = results.where((c) => c.tags.contains(tag)).toList();
    }

    // Apply text search
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase().trim();
      results = results.where((command) {
        return _matchesQuery(command, lowerQuery);
      }).toList();
    }

    return results;
  }

  bool _matchesQuery(Command command, String query) {
    // Search across multiple fields
    return
      command.name.toLowerCase().contains(query) ||
      command.displayName.toLowerCase().contains(query) ||
      command.category.toLowerCase().contains(query) ||
      command.tags.any((tag) => tag.toLowerCase().contains(query)) ||
      command.overview.summary.toLowerCase().contains(query) ||
      command.options.any((opt) =>
        opt.description.toLowerCase().contains(query) ||
        opt.flag.toLowerCase().contains(query)
      ) ||
      command.examples.any((ex) =>
        ex.title.toLowerCase().contains(query) ||
        ex.description.toLowerCase().contains(query)
      ) ||
      command.misconceptions.any((m) =>
        m.title.toLowerCase().contains(query) ||
        m.reality.toLowerCase().contains(query)
      );
  }

  // Weighted search for better relevance
  List<Command> searchWeighted(String query) {
    final lowerQuery = query.toLowerCase().trim();
    final scoredCommands = _commandService.getAllCommands().map((command) {
      int score = _calculateRelevance(command, lowerQuery);
      return MapEntry(command, score);
    }).where((entry) => entry.value > 0).toList();

    scoredCommands.sort((a, b) => b.value.compareTo(a.value));
    return scoredCommands.map((entry) => entry.key).toList();
  }

  int _calculateRelevance(Command command, String query) {
    int score = 0;

    if (command.name.toLowerCase() == query) score += 100; // Exact match
    if (command.name.toLowerCase().contains(query)) score += 50;
    if (command.displayName.toLowerCase().contains(query)) score += 30;
    if (command.category.toLowerCase().contains(query)) score += 20;
    if (command.tags.any((tag) => tag.toLowerCase().contains(query))) score += 25;
    if (command.overview.summary.toLowerCase().contains(query)) score += 15;
    // ... more scoring

    return score;
  }
}
```

## Performance Optimizations

### Startup Performance
1. **Lazy Loading** (if needed):
   - Load command list first (metadata only)
   - Load full command details on demand
   - Currently not needed for 100 commands

2. **Async Loading**:
   - Load commands asynchronously during app initialization
   - Show loading indicator
   - Prevent UI blocking

### Search Performance
1. **Debouncing**:
   - Wait for user to stop typing (300-500ms)
   - Prevents excessive searches while typing
   ```dart
   Timer? _debounceTimer;

   void onSearchChanged(String query) {
     _debounceTimer?.cancel();
     _debounceTimer = Timer(Duration(milliseconds: 400), () {
       performSearch(query);
     });
   }
   ```

2. **Caching**:
   - Cache recent searches
   - Cache category/tag filtered results
   - Clear cache on app update

3. **Indexing** (Future Optimization):
   - Build keyword index at startup
   - Map keywords to command IDs
   - Fast lookup for common searches

### Memory Optimization
1. **String Interning**: Dart handles this automatically
2. **Lazy Parsing**: Only parse fields needed for display
3. **Pagination**: If list grows beyond 1000 items, implement pagination

## Implementation Steps

### Phase 1: Basic Loading & Display
1. ✅ Create JSON data files (done)
2. ⏳ Add assets to pubspec.yaml
3. ⏳ Create Dart models (Command, Option, Example, etc.)
4. ⏳ Implement CommandService to load JSON files
5. ⏳ Display command list in UI

### Phase 2: Basic Search
1. ⏳ Implement simple string matching search
2. ⏳ Add search UI (text field + results)
3. ⏳ Filter by category
4. ⏳ Filter by tag

### Phase 3: Enhanced Search
1. ⏳ Implement weighted/relevance search
2. ⏳ Add debouncing
3. ⏳ Highlight search terms in results
4. ⏳ Search history/suggestions

### Phase 4: Optimization (Future)
1. ⏳ Build search index
2. ⏳ Implement fuzzy matching
3. ⏳ Add search analytics
4. ⏳ Optimize for large datasets

## Alternative Approaches Considered

### 1. SQLite Database
- **Pros**: Powerful queries, indexing, relationships
- **Cons**: Overkill for 100 commands, adds complexity, need migrations
- **Decision**: Not needed for current scale

### 2. Hive/Isar (Local NoSQL)
- **Pros**: Fast, type-safe, query capabilities
- **Cons**: Additional dependency, learning curve
- **Decision**: Consider for future if search becomes complex

### 3. Static Code Generation (json_serializable)
- **Pros**: Type-safe, compile-time checking
- **Cons**: Build-time complexity, regeneration needed
- **Decision**: Use for production, manual parsing for MVP

### 4. Remote API
- **Pros**: Easy updates, centralized data
- **Cons**: Requires internet, goes against offline-first goal
- **Decision**: Not suitable for this project

## Current Recommendation

**Start with**: In-memory loading + simple string matching search
- Simple to implement
- Fast enough for 100 commands
- Easy to maintain
- Can optimize later if needed

**Upgrade path**: If we scale beyond 1000 commands or search becomes slow:
- Add search index
- Implement weighted scoring
- Consider Hive for structured queries

