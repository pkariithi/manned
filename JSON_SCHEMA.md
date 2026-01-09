# Command JSON Schema Documentation

This document defines the structure and schema for command JSON files in the Manned Pages application.

## File Location

All command JSON files are located in: `assets/data/<command_name>.json`

## Top-Level Structure

Each command JSON file must follow this structure:

```json
{
  "metadata": { ... },
  "installation": { ... },
  "overview": { ... },
  "syntax": { ... },
  "options": [ ... ],
  "examples": [ ... ],
  "misconceptions": [ ... ],           // Optional
  "common_pitfalls": [ ... ],          // Optional
  "related_commands": [ ... ],         // Optional
  "best_practices": [ ... ],           // Optional
  "performance_tips": [ ... ],         // Optional
  "additional_notes": { ... }          // Optional
}
```

## Required Sections

### 1. `metadata` (Object, Required)

Contains command identification and categorization information.

```json
{
  "name": "string",              // Required: Command name (e.g., "ls")
  "displayName": "string",       // Required: Human-readable name (e.g., "ls - List directory contents")
  "category": "string",          // Required: Category name (e.g., "File & Directory Operations")
  "tags": ["string"],            // Required: Array of tags (e.g., ["files", "directory", "basic"])
  "description": "string",       // Required: Short description
  "popularity": 0-10,            // Required: Integer 0-10 (10 = most popular)
  "difficulty": "string",       // Required: "beginner", "intermediate", or "advanced"
  "version": "string"            // Required: Version info (e.g., "GNU coreutils 8.32+")
}
```

**Example:**
```json
{
  "name": "ls",
  "displayName": "ls - List directory contents",
  "category": "File & Directory Operations",
  "tags": ["files", "directory", "listing", "navigation", "basic"],
  "description": "List directory contents",
  "popularity": 10,
  "difficulty": "beginner",
  "version": "GNU coreutils 8.32+"
}
```

### 2. `installation` (Object, Required)

Describes installation requirements and instructions.

```json
{
  "required": boolean,           // Required: true if installation needed, false if built-in
  "status": "string",            // Required: "built_in" or "installable" or "not_installed_by_default"
  "package": { ... },            // Optional: Installation package details (only if required=true)
  "note": "string"              // Optional: Additional installation notes
}
```

**Package Object (when `required: true`):**
```json
{
  "name": "string",              // Required: Package name
  "manager": "string",           // Required: Package manager (e.g., "apt", "snap")
  "command": "string"            // Required: Installation command (e.g., "sudo apt install htop")
}
```

**Example (Built-in):**
```json
{
  "required": false,
  "status": "built_in",
  "note": "ls is a built-in command available on all Linux systems by default"
}
```

**Example (Requires Installation):**
```json
{
  "required": true,
  "status": "installable",
  "package": {
    "name": "htop",
    "manager": "apt",
    "command": "sudo apt install htop"
  },
  "note": "htop is not installed by default on most Linux distributions"
}
```

### 3. `overview` (Object, Required)

Provides command overview and use cases.

```json
{
  "summary": "string",           // Required: Detailed summary of the command
  "when_to_use": ["string"]      // Required: Array of use case scenarios
}
```

**Example:**
```json
{
  "summary": "The ls command lists files and directories in the current directory or a specified path.",
  "when_to_use": [
    "View files and directories in a folder",
    "Check if a file exists in a directory",
    "See file permissions, sizes, and timestamps"
  ]
}
```

### 4. `syntax` (Object, Required)

Describes command syntax and usage patterns.

```json
{
  "basic": "string",             // Required: Basic syntax (e.g., "ls [OPTIONS] [FILE]")
  "description": "string",        // Optional: Additional syntax description
  "examples": ["string"]          // Optional: Array of syntax examples
}
```

**Example:**
```json
{
  "basic": "ls [OPTIONS] [FILE/DIRECTORY]",
  "description": "If no file or directory is specified, ls lists the contents of the current directory.",
  "examples": [
    "ls",
    "ls /home/user",
    "ls -l"
  ]
}
```

### 5. `options` (Array, Required)

Array of command option/flag objects. Can be empty array `[]` if command has no options.

```json
[
  {
    "flag": "string",            // Required: Flag representation (e.g., "-a, --all" or "-l")
    "short": "string",           // Optional: Short flag (e.g., "-a")
    "long": "string",            // Optional: Long flag (e.g., "--all") or null
    "description": "string",      // Required: Description of what the flag does
    "category": "string",        // Optional: Category (e.g., "display", "sorting", "filtering")
    "example": "string",         // Optional: Example usage
    "use_case": "string"         // Optional: When to use this flag
  }
]
```

**Example:**
```json
[
  {
    "flag": "-a, --all",
    "short": "-a",
    "long": "--all",
    "description": "Show all files, including hidden files",
    "category": "display",
    "example": "ls -a",
    "use_case": "To see configuration files like .bashrc"
  },
  {
    "flag": "-l",
    "short": "-l",
    "long": null,
    "description": "Use long listing format",
    "category": "display",
    "example": "ls -l",
    "use_case": "To see detailed file information"
  }
]
```

### 6. `examples` (Array, Required)

Array of example usage objects. Must have at least one example.

```json
[
  {
    "title": "string",           // Required: Example title
    "command": "string",          // Required: Example command
    "description": "string",      // Required: What this example demonstrates
    "output": "string",          // Optional: Expected output
    "output_explanation": { ... }, // Optional: Detailed output breakdown
    "use_case": "string"         // Optional: When to use this example
  }
]
```

**Output Explanation Object (Optional):**
```json
{
  "format": "string",            // Description of output format
  "elements": [                   // Array of output element explanations
    {
      "element": "string",       // Element name or value
      "meaning": "string",       // What this element means
      "breakdown": { ... }        // Optional: Further breakdown (nested object)
    }
  ],
  "notes": "string"              // Optional: Additional notes about the output
}
```

**Example:**
```json
{
  "title": "Basic directory listing",
  "command": "ls",
  "description": "List all visible files and directories in the current folder",
  "output": "Documents  Downloads  Music  Pictures",
  "output_explanation": {
    "format": "Space-separated list of file and directory names",
    "elements": [
      {
        "element": "Documents",
        "meaning": "Directory name"
      }
    ],
    "notes": "Regular files and directories appear the same in basic ls"
  },
  "use_case": "Quick overview of directory contents"
}
```

## Optional Sections

### 7. `misconceptions` (Array, Optional)

Common misunderstandings about the command.

```json
[
  {
    "title": "string",           // Required: Misconception title
    "misconception": "string",   // Required: The wrong understanding
    "reality": "string",         // Required: The correct understanding
    "tip": "string"              // Optional: Helpful tip
  }
]
```

### 8. `common_pitfalls` (Array, Optional)

Common mistakes and how to avoid them.

```json
[
  {
    "issue": "string",           // Required: The problem
    "description": "string",     // Required: Description of the issue
    "solution": "string"         // Required: How to solve it
  }
]
```

### 9. `related_commands` (Array, Optional)

Commands related to this one.

```json
[
  {
    "command": "string",         // Required: Related command name
    "relationship": "string",    // Required: How it relates (e.g., "Alternative", "Complementary")
    "description": "string"      // Required: Description of the relationship
  }
]
```

### 10. `best_practices` (Array, Optional)

Recommended practices for using the command.

```json
[
  "string",                      // Array of practice strings
  "string"
]
```

### 11. `performance_tips` (Array, Optional)

Tips for optimizing command usage.

```json
[
  "string",                      // Array of tip strings
  "string"
]
```

### 12. `additional_notes` (Object, Optional)

Additional information as key-value pairs.

```json
{
  "key1": "value1",
  "key2": "value2"
}
```

## Complete Example

See `assets/data/ls.json` for a complete example with all sections populated.

## Validation Rules

1. **All required top-level keys must be present**: `metadata`, `installation`, `overview`, `syntax`, `options`, `examples`
2. **All required fields within each section must be present** (see section details above)
3. **Arrays can be empty** (`[]`) but must be present
4. **Optional fields can be omitted** or set to `null` (for object fields)
5. **JSON must be valid** - proper syntax, no trailing commas, matching brackets

## Field Naming Conventions

- Use `snake_case` for JSON keys: `when_to_use`, `output_explanation`, `use_case`, `common_pitfalls`, `related_commands`, `best_practices`, `performance_tips`, `additional_notes`
- Use `camelCase` for nested object keys within `output_explanation`: `breakdown` (if used)
- Boolean values: `true` or `false` (lowercase)
- Null values: `null` (lowercase, not `None` or empty string)

## Data Types

- **Strings**: Always use double quotes `"string"`
- **Numbers**: Integers for `popularity` (0-10), no quotes
- **Booleans**: `true` or `false`, no quotes
- **Arrays**: Square brackets `[]`
- **Objects**: Curly braces `{}`
- **Null**: Use `null` for optional fields that are not present

## Notes

- The `options` array can be empty `[]` for commands with no options
- The `examples` array should have at least one example
- All optional sections can be omitted entirely (don't include the key)
- The `package` object in `installation` is only needed when `required: true`
- The `note` field in `installation` can be a string or omitted

