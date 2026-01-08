// Command models matching JSON structure
class Command {
  final Metadata metadata;
  final Installation installation;
  final Overview overview;
  final Syntax syntax;
  final List<Option> options;
  final List<Example> examples;
  final List<Misconception>? misconceptions;
  final List<Pitfall>? commonPitfalls;
  final List<RelatedCommand>? relatedCommands;
  final List<String>? bestPractices;
  final List<String>? performanceTips;
  final Map<String, dynamic>? additionalNotes;

  Command({
    required this.metadata,
    required this.installation,
    required this.overview,
    required this.syntax,
    required this.options,
    required this.examples,
    this.misconceptions,
    this.commonPitfalls,
    this.relatedCommands,
    this.bestPractices,
    this.performanceTips,
    this.additionalNotes,
  });

  // Convenience getters for backward compatibility
  String get name => metadata.name;
  String get displayName => metadata.displayName;
  String get category => metadata.category;
  List<String> get tags => metadata.tags;
  String get description => metadata.description;
  bool get requiresInstallation => installation.required;
  String? get installationCommand => installation.package?.command;

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      installation: Installation.fromJson(
        json['installation'] as Map<String, dynamic>,
      ),
      overview: Overview.fromJson(json['overview'] as Map<String, dynamic>),
      syntax: Syntax.fromJson(json['syntax'] as Map<String, dynamic>),
      options: (json['options'] as List<dynamic>)
          .map((opt) => Option.fromJson(opt as Map<String, dynamic>))
          .toList(),
      examples: (json['examples'] as List<dynamic>)
          .map((ex) => Example.fromJson(ex as Map<String, dynamic>))
          .toList(),
      misconceptions: json['misconceptions'] != null
          ? (json['misconceptions'] as List<dynamic>)
                .map((m) => Misconception.fromJson(m as Map<String, dynamic>))
                .toList()
          : null,
      commonPitfalls: json['common_pitfalls'] != null
          ? (json['common_pitfalls'] as List<dynamic>)
                .map((p) => Pitfall.fromJson(p as Map<String, dynamic>))
                .toList()
          : null,
      relatedCommands: json['related_commands'] != null
          ? (json['related_commands'] as List<dynamic>)
                .map((r) => RelatedCommand.fromJson(r as Map<String, dynamic>))
                .toList()
          : null,
      bestPractices: json['best_practices'] != null
          ? (json['best_practices'] as List<dynamic>)
                .map((p) => p as String)
                .toList()
          : null,
      performanceTips: json['performance_tips'] != null
          ? (json['performance_tips'] as List<dynamic>)
                .map((t) => t as String)
                .toList()
          : null,
      additionalNotes: json['additional_notes'] != null
          ? json['additional_notes'] as Map<String, dynamic>
          : null,
    );
  }
}

class Metadata {
  final String name;
  final String displayName;
  final String category;
  final List<String> tags;
  final String description;
  final int popularity;
  final String difficulty;
  final String version;

  Metadata({
    required this.name,
    required this.displayName,
    required this.category,
    required this.tags,
    required this.description,
    required this.popularity,
    required this.difficulty,
    required this.version,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      category: json['category'] as String,
      tags: (json['tags'] as List<dynamic>).map((t) => t as String).toList(),
      description: json['description'] as String,
      popularity: json['popularity'] as int,
      difficulty: json['difficulty'] as String,
      version: json['version'] as String,
    );
  }
}

class Installation {
  final bool required;
  final String status;
  final InstallationPackage? package;
  final String? note;

  Installation({
    required this.required,
    required this.status,
    this.package,
    this.note,
  });

  factory Installation.fromJson(Map<String, dynamic> json) {
    return Installation(
      required: json['required'] as bool,
      status: json['status'] as String,
      package: json['package'] != null
          ? InstallationPackage.fromJson(
              json['package'] as Map<String, dynamic>,
            )
          : null,
      note: json['note'] as String?,
    );
  }
}

class InstallationPackage {
  final String name;
  final String manager;
  final String command;

  InstallationPackage({
    required this.name,
    required this.manager,
    required this.command,
  });

  factory InstallationPackage.fromJson(Map<String, dynamic> json) {
    return InstallationPackage(
      name: json['name'] as String,
      manager: json['manager'] as String,
      command: json['command'] as String,
    );
  }
}

class Overview {
  final String summary;
  final List<String> whenToUse;

  Overview({required this.summary, required this.whenToUse});

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      summary: json['summary'] as String,
      whenToUse: (json['when_to_use'] as List<dynamic>)
          .map((u) => u as String)
          .toList(),
    );
  }
}

class Syntax {
  final String basic;
  final String? description;
  final List<String>? examples;

  Syntax({required this.basic, this.description, this.examples});

  factory Syntax.fromJson(Map<String, dynamic> json) {
    return Syntax(
      basic: json['basic'] as String,
      description: json['description'] as String?,
      examples: json['examples'] != null
          ? (json['examples'] as List<dynamic>).map((e) => e as String).toList()
          : null,
    );
  }
}

class Option {
  final String flag;
  final String? short;
  final String? long;
  final String description;
  final String? category;
  final String? example;
  final String? useCase;

  Option({
    required this.flag,
    this.short,
    this.long,
    required this.description,
    this.category,
    this.example,
    this.useCase,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      flag: json['flag'] as String,
      short: json['short'] as String?,
      long: json['long'] as String?,
      description: json['description'] as String,
      category: json['category'] as String?,
      example: json['example'] as String?,
      useCase: json['use_case'] as String?,
    );
  }

  // Format for display
  String get displayText {
    if (short != null && long != null) {
      return '$flag: $description';
    }
    return '$flag: $description';
  }
}

class Example {
  final String title;
  final String command;
  final String description;
  final String? output;
  final Map<String, dynamic>? outputExplanation;
  final String? useCase;

  Example({
    required this.title,
    required this.command,
    required this.description,
    this.output,
    this.outputExplanation,
    this.useCase,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      title: json['title'] as String,
      command: json['command'] as String,
      description: json['description'] as String,
      output: json['output'] as String?,
      outputExplanation: json['output_explanation'] as Map<String, dynamic>?,
      useCase: json['use_case'] as String?,
    );
  }
}

class Misconception {
  final String title;
  final String misconception;
  final String reality;
  final String? tip;

  Misconception({
    required this.title,
    required this.misconception,
    required this.reality,
    this.tip,
  });

  factory Misconception.fromJson(Map<String, dynamic> json) {
    return Misconception(
      title: json['title'] as String,
      misconception: json['misconception'] as String,
      reality: json['reality'] as String,
      tip: json['tip'] as String?,
    );
  }
}

class Pitfall {
  final String issue;
  final String description;
  final String solution;

  Pitfall({
    required this.issue,
    required this.description,
    required this.solution,
  });

  factory Pitfall.fromJson(Map<String, dynamic> json) {
    return Pitfall(
      issue: json['issue'] as String,
      description: json['description'] as String,
      solution: json['solution'] as String,
    );
  }
}

class RelatedCommand {
  final String command;
  final String relationship;
  final String description;

  RelatedCommand({
    required this.command,
    required this.relationship,
    required this.description,
  });

  factory RelatedCommand.fromJson(Map<String, dynamic> json) {
    return RelatedCommand(
      command: json['command'] as String,
      relationship: json['relationship'] as String,
      description: json['description'] as String,
    );
  }
}
