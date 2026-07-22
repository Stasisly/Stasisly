import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_supabase_remote_context.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('stasisly-remote-context-');
  });

  tearDown(() {
    root.deleteSync(recursive: true);
  });

  test('clean root passes', () {
    expect(SupabaseRemoteContextScanner(root).scan(), isEmpty);
  });

  test('project ref fails without exposing its content', () {
    const secretFixture = 'fake-project-reference-never-print';
    _write(root, 'supabase/.temp/project-ref', secretFixture);

    final findings = SupabaseRemoteContextScanner(root).scan();

    expect(findings, hasLength(1));
    expect(findings.single.kind, RemoteContextFindingKind.linkedMetadata);
    expect(findings.single.safeDescription, isNot(contains(secretFixture)));
    expect(
      File('${root.path}/supabase/.temp/project-ref').readAsStringSync(),
      secretFixture,
      reason: 'The read-only guard must not remove link metadata.',
    );
  });

  test('pooler metadata also fails closed', () {
    _write(root, 'supabase/.temp/pooler-url', 'not-a-real-host');

    final findings = SupabaseRemoteContextScanner(root).scan();

    expect(findings.single.kind, RemoteContextFindingKind.linkedMetadata);
  });

  for (final path in const [
    'scripts/unsafe.sh',
    '.github/workflows/unsafe.yml',
  ]) {
    test('linked command in $path fails', () {
      _write(root, path, 'supabase link --project-ref fake\n');

      final findings = SupabaseRemoteContextScanner(root).scan();

      expect(findings.single.kind, RemoteContextFindingKind.dangerousCommand);
    });
  }

  test('documented prohibited command is not executable tooling', () {
    _write(
      root,
      'docs/stasisly_foundation/safety.md',
      'Do not run: supabase db push',
    );

    expect(SupabaseRemoteContextScanner(root).scan(), isEmpty);
  });

  test('explicit local database reset passes', () {
    _write(
      root,
      'scripts/validate.sh',
      'supabase db reset --local --no-seed\n',
    );

    expect(SupabaseRemoteContextScanner(root).scan(), isEmpty);
  });

  test('ambiguous database reset fails', () {
    _write(root, 'scripts/validate.sh', 'supabase db reset --no-seed\n');

    final findings = SupabaseRemoteContextScanner(root).scan();

    expect(
      findings.single.kind,
      RemoteContextFindingKind.ambiguousLocalCommand,
    );
  });

  test('remote URL in a versionable example fails without printing value', () {
    const value =
        'https://not-real.example'
        '.supabase.co';
    _write(root, '.env.example', 'SUPABASE_URL=$value\n');

    final findings = SupabaseRemoteContextScanner(root).scan();

    expect(findings.single.kind, RemoteContextFindingKind.remoteConfiguration);
    expect(findings.single.safeDescription, isNot(contains(value)));
  });

  test('placeholder project reference in documentation passes', () {
    _write(
      root,
      'docs/stasisly_foundation/safety.md',
      'supabase link --project-ref <DEV_PROJECT_REF>',
    );

    expect(SupabaseRemoteContextScanner(root).scan(), isEmpty);
  });

  test('concrete project reference in documentation fails', () {
    const value = 'fake-concrete-reference';
    _write(
      root,
      'docs/stasisly_foundation/safety.md',
      'SUPABASE_'
          'PROJECT_REF=$value',
    );

    final findings = SupabaseRemoteContextScanner(root).scan();

    expect(
      findings.single.kind,
      RemoteContextFindingKind.committedProjectReference,
    );
    expect(findings.single.safeDescription, isNot(contains(value)));
  });
}

void _write(Directory root, String relativePath, String content) {
  final file = File('${root.path}/$relativePath');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}
