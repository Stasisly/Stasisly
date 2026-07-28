import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final shell = File(
    'scripts/run_development_remote_fixture_test.sh',
  ).readAsStringSync();
  final runner = File(
    'tool/development_complete_functional_runner.dart',
  ).readAsStringSync();
  final sanitizer = File('tool/safe_http_diagnostic.dart').readAsStringSync();
  final httpContract = File(
    'scripts/lib/development_remote_http_contract.sh',
  ).readAsStringSync();

  test('complete runner preserves exact synthetic Auth HTTP 200 assertion', () {
    expect(runner, contains("client.endpoint('/auth/v1/admin/users')"));
    expect(runner, contains("'email_confirm': true"));
    expect(runner, contains('result.status != 200'));
    expect(runner, isNot(contains('result.status >= 200')));
    expect(runner, isNot(contains('result.status ~/ 100')));
  });

  test('SafeHttpDiagnostic uses an isolated restricted output file', () {
    expect(runner, contains('tool/safe_http_diagnostic.dart'));
    expect(runner, contains("'--output-file'"));
    expect(runner, contains('SAFE_HTTP_DIAGNOSTIC_BEGIN'));
    expect(runner, contains('SAFE_HTTP_DIAGNOSTIC_END'));
    expect(runner, contains('Directory.systemTemp.createTemp'));
    expect(runner, contains('directory.deleteSync(recursive: true)'));
    expect(runner, isNot(contains('stdout.write(jsonEncode(result.body))')));
  });

  test('cleanup is finally driven and accepts exact Auth 200 or 404', () {
    expect(runner, contains('finally {\n      await _finish();'));
    expect(runner, contains('cleanupLedger'));
    expect(runner, contains('result.status == 200 || result.status == 404'));
    expect(runner, contains('validateAuthAbsence'));
    expect(runner, contains('validateResidueCounters'));
    expect(runner, contains('failedDirtyBlocking'));
  });

  test('shell isolates link metadata on success, failure and signals', () {
    expect(shell, contains('trap isolate_cli EXIT INT TERM'));
    expect(shell, contains('rm -f supabase/.temp/project-ref'));
    expect(shell, contains('supabase/.temp/pooler-url'));
    expect(shell, contains('check_supabase_remote_context.dart'));
    expect(shell, contains('--validate-contract'));
  });

  test('runner and shell prohibit leakage primitives', () {
    final combined = runner + shell;
    expect(combined, isNot(contains('set -x')));
    expect(combined, isNot(contains('curl --trace')));
    expect(combined, isNot(contains('print(context.ownerToken)')));
    expect(combined, isNot(contains('print(context.password)')));
    expect(combined, isNot(contains('print(context.ownerEmail)')));
    expect(combined, isNot(contains('print(context.conversationId)')));
    expect(shell, contains(r'>"$tmp_dir/link.stdout"'));
    expect(shell, contains(r'2>"$tmp_dir/link.stderr"'));
  });

  test('historical curl contract still separates all channels', () {
    expect(httpContract, contains('strict_transport_exit_from_file'));
    expect(httpContract, contains('strict_http_status_from_file'));
    expect(httpContract, contains('response_body_file'));
    expect(httpContract, contains('diagnostic_file'));
    expect(httpContract, contains('metadata_file'));
    expect(httpContract, contains(r'>"$metadata_file" 2>"$diagnostic_file"'));
  });

  test('sanitizer contract remains closed and bounded', () {
    for (final field in [
      'operation',
      'statusCode',
      'statusClass',
      'contentTypeCategory',
      'bodyPresence',
      'bodySizeBucket',
      'jsonParseStatus',
      'topLevelFieldNames',
      'safeErrorCategory',
      'durationBucket',
      'assertionOutcome',
      'cleanupRequired',
    ]) {
      expect(sanitizer, contains(field));
    }
    expect(sanitizer, contains('const int _maximumFieldNames = 20'));
    expect(sanitizer, contains('take(_maximumFieldNames)'));
    expect(sanitizer, isNot(contains('bodyFile.readAsStringSync')));
    expect(sanitizer, isNot(contains('Platform.environment')));
  });

  test('diagnostic tooling contains no remote execution primitive', () {
    expect(sanitizer, isNot(contains('HttpClient')));
    expect(sanitizer, isNot(contains('Process.run')));
    expect(sanitizer, isNot(contains('supabase')));
    expect(sanitizer, isNot(contains('curl')));
  });
}
