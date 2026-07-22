import 'dart:io';

enum RemoteContextFindingKind {
  linkedMetadata,
  dangerousCommand,
  ambiguousLocalCommand,
  remoteConfiguration,
  committedProjectReference,
}

final class RemoteContextFinding {
  const RemoteContextFinding({required this.kind, required this.path});

  final RemoteContextFindingKind kind;
  final String path;

  String get safeDescription => switch (kind) {
    RemoteContextFindingKind.linkedMetadata =>
      'Remote Supabase CLI context detected.',
    RemoteContextFindingKind.dangerousCommand =>
      'Remote-capable Supabase command detected in local tooling.',
    RemoteContextFindingKind.ambiguousLocalCommand =>
      'Supabase local command has no explicit local target.',
    RemoteContextFindingKind.remoteConfiguration =>
      'Remote Supabase configuration detected in a versionable example.',
    RemoteContextFindingKind.committedProjectReference =>
      'Concrete Supabase project reference detected in documentation.',
  };
}

final class SupabaseRemoteContextScanner {
  SupabaseRemoteContextScanner(this.root);

  final Directory root;

  static const _linkedMetadataPaths = <String>[
    'supabase/.temp/project-ref',
    'supabase/.temp/pooler-url',
    '.supabase/project-ref',
    '.supabase/pooler-url',
  ];

  static final _dangerousCommands = <RegExp>[
    RegExp(r'\bsupabase\s+link\b'),
    RegExp(r'\bsupabase\s+db\s+(?:push|pull|dump)\b'),
    RegExp(r'\bsupabase\s+functions\s+deploy\b'),
    RegExp(r'\bsupabase\s+secrets(?:\s|$)'),
    RegExp(r'\bsupabase\s+migration\s+repair\b'),
    RegExp(r'\bsupabase\s+branches(?:\s|$)'),
  ];

  static final _localDatabaseCommand = RegExp(
    r'\bsupabase\s+(?:db\s+reset|test\s+db)\b',
  );
  static final _remoteSupabaseUrl = RegExp(
    r'https://[^\s/]+\.supabase\.(?:co|com)(?:[/\s]|$)',
    caseSensitive: false,
  );
  static final _projectRefAssignment = RegExp(
    r'(?:SUPABASE_PROJECT_REF\s*=|--project-ref\s+)([^\s`]+)',
  );

  List<RemoteContextFinding> scan() {
    final findings = <RemoteContextFinding>[];
    _scanLinkMetadata(findings);
    _scanExecutableTooling(findings);
    _scanVersionableExamples(findings);
    _scanDocumentationProjectReferences(findings);
    return findings;
  }

  void _scanLinkMetadata(List<RemoteContextFinding> findings) {
    for (final relativePath in _linkedMetadataPaths) {
      if (File(_resolve(relativePath)).existsSync()) {
        findings.add(
          RemoteContextFinding(
            kind: RemoteContextFindingKind.linkedMetadata,
            path: relativePath,
          ),
        );
      }
    }
  }

  void _scanExecutableTooling(List<RemoteContextFinding> findings) {
    for (final directoryName in const ['scripts', 'tool', '.github']) {
      final directory = Directory(_resolve(directoryName));
      if (!directory.existsSync()) continue;

      for (final entity in directory.listSync(recursive: true)) {
        if (entity is! File || !_isExecutableTooling(entity.path)) continue;
        final relativePath = _relative(entity.path);
        if (relativePath == 'tool/check_supabase_remote_context.dart') continue;

        final content = entity.readAsStringSync();
        for (final line in content.split('\n')) {
          final candidate = line.trimLeft();
          if (candidate.startsWith('#') || candidate.startsWith('//')) continue;

          if (_dangerousCommands.any(
            (pattern) => pattern.hasMatch(candidate),
          )) {
            findings.add(
              RemoteContextFinding(
                kind: RemoteContextFindingKind.dangerousCommand,
                path: relativePath,
              ),
            );
            break;
          }
          if (_localDatabaseCommand.hasMatch(candidate) &&
              !RegExp(r'(?:^|\s)--local(?:\s|$)').hasMatch(candidate)) {
            findings.add(
              RemoteContextFinding(
                kind: RemoteContextFindingKind.ambiguousLocalCommand,
                path: relativePath,
              ),
            );
            break;
          }
        }
      }
    }
  }

  void _scanVersionableExamples(List<RemoteContextFinding> findings) {
    for (final entity in root.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final relativePath = _relative(entity.path);
      if (!_isVersionableExample(relativePath)) continue;

      final content = entity.readAsStringSync();
      if (_remoteSupabaseUrl.hasMatch(content)) {
        findings.add(
          RemoteContextFinding(
            kind: RemoteContextFindingKind.remoteConfiguration,
            path: relativePath,
          ),
        );
      }
    }
  }

  void _scanDocumentationProjectReferences(
    List<RemoteContextFinding> findings,
  ) {
    final candidates = <File>[];
    for (final name in const ['README.md', 'README']) {
      final file = File(_resolve(name));
      if (file.existsSync()) candidates.add(file);
    }
    final docs = Directory(_resolve('docs/stasisly_foundation'));
    if (docs.existsSync()) {
      candidates.addAll(
        docs
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((file) => file.path.endsWith('.md')),
      );
    }

    for (final file in candidates) {
      final content = file.readAsStringSync();
      for (final match in _projectRefAssignment.allMatches(content)) {
        final value = match.group(1)!;
        if (_isPlaceholder(value)) continue;
        findings.add(
          RemoteContextFinding(
            kind: RemoteContextFindingKind.committedProjectReference,
            path: _relative(file.path),
          ),
        );
        break;
      }
    }
  }

  bool _isExecutableTooling(String path) {
    const extensions = [
      '.dart',
      '.sh',
      '.bash',
      '.zsh',
      '.py',
      '.yaml',
      '.yml',
    ];
    return extensions.any(path.endsWith);
  }

  bool _isVersionableExample(String path) {
    if (_isIgnoredTraversalPath(path)) return false;
    final name = path.split('/').last;
    return name == '.env.example' || name.endsWith('.example');
  }

  bool _isIgnoredTraversalPath(String path) {
    const ignored = ['.dart_tool/', '.git/', 'build/', 'supabase/.temp/'];
    return ignored.any(path.startsWith);
  }

  bool _isPlaceholder(String value) {
    final normalized = value.toLowerCase();
    return value.isEmpty ||
        value.startsWith('<') ||
        value.startsWith(r'${') ||
        normalized.contains('example') ||
        normalized.contains('placeholder') ||
        normalized.contains('your_') ||
        normalized.contains('dev_project_ref');
  }

  String _resolve(String relativePath) =>
      '${root.path}${Platform.pathSeparator}$relativePath';

  String _relative(String path) {
    final prefix = '${root.absolute.path}${Platform.pathSeparator}';
    final absolute = File(path).absolute.path;
    return absolute.startsWith(prefix)
        ? absolute.substring(prefix.length).replaceAll(r'\', '/')
        : absolute.replaceAll(r'\', '/');
  }
}

void main(List<String> arguments) {
  final root = _rootFromArguments(arguments);
  if (root == null) {
    stderr.writeln('Usage: dart run tool/check_supabase_remote_context.dart');
    exitCode = 64;
    return;
  }

  final findings = SupabaseRemoteContextScanner(root).scan();
  if (findings.isEmpty) {
    stdout.writeln('Supabase CLI remote-context preflight: SAFE.');
    return;
  }

  stderr
    ..writeln('Remote Supabase CLI context detected.')
    ..writeln(
      'Local Foundation tasks are blocked until the context is isolated.',
    );
  for (final finding in findings) {
    stderr.writeln('${finding.safeDescription} Path: ${finding.path}');
  }
  exitCode = 1;
}

Directory? _rootFromArguments(List<String> arguments) {
  if (arguments.isEmpty) return Directory.current;
  if (arguments.length == 2 && arguments.first == '--root') {
    return Directory(arguments.last).absolute;
  }
  return null;
}
