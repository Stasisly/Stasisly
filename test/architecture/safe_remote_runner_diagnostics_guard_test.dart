import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final runner = File(
    'scripts/run_development_remote_fixture_test.sh',
  ).readAsStringSync();
  final sanitizer = File('tool/safe_http_diagnostic.dart').readAsStringSync();
  final httpContract = File(
    'scripts/lib/development_remote_http_contract.sh',
  ).readAsStringSync();

  test('remote runner keeps the exact focal request and 200 assertion', () {
    expect(
      runner,
      contains(
        'capture_http_channels POST '
        r'"$SUPABASE_URL/auth/v1/admin/users"',
      ),
    );
    expect(runner, contains(r'\"email_confirm\":true'));
    expect(runner, contains(r'test "$synthetic_user_status" = 200'));
    expect(runner, isNot(contains(r'test "$synthetic_user_status" -ge 200')));
    expect(runner, isNot(contains('2??')));
    expect(runner, isNot(contains('|| true # accept')));
  });

  test('diagnostic-only runner stops before downstream fixture setup', () {
    final stop = runner.indexOf(
      r'if [ "$REMOTE_RUNNER_EXECUTION_MODE" = diagnostic-only ]',
    );
    final nextSetup = runner.indexOf("request POST '/rest/v1/specialists'");
    expect(stop, greaterThan(0));
    expect(nextSetup, greaterThan(stop));
    expect(runner, contains('REMOTE_RUNNER_EXECUTION_MODE'));
    expect(
      runner,
      contains(
        r'if [ "$REMOTE_RUNNER_EXECUTION_MODE" = diagnostic-only ]; then',
      ),
    );
  });

  test(
    'runner preserves trap, idempotent cleanup and dirty classification',
    () {
      expect(runner, contains('trap finalize EXIT INT TERM'));
      expect(
        runner,
        contains('cleanup_remote_fixture && cleanup_remote_fixture'),
      );
      expect(runner, contains("'0|0|0|0|0|0|0'"));
      expect(runner, contains('FAILED_CLEAN'));
      expect(runner, contains('FAILED_DIRTY_BLOCKING'));
      expect(runner, contains(r'exit "${original_status:-1}"'));
      expect(runner, contains('delete_auth_user_exact'));
      expect(runner, contains('200|404'));
    },
  );

  test('diagnostic evidence is isolated from Dart build output', () {
    expect(runner, contains(r'--output-file "$diagnostic_output"'));
    expect(runner, contains(r'>"$diagnostic_build_stdout"'));
    expect(runner, contains(r'2>"$diagnostic_build_stderr"'));
    expect(
      runner,
      contains(
        r'test "$(head -n 1 "$diagnostic_output")" = '
        'SAFE_HTTP_DIAGNOSTIC_BEGIN',
      ),
    );
    expect(
      runner,
      contains(
        r'test "$(tail -n 1 "$diagnostic_output")" = '
        'SAFE_HTTP_DIAGNOSTIC_END',
      ),
    );
    expect(sanitizer, contains("options['output-file']"));
    expect(sanitizer, isNot(contains('stdout.writeln(diagnostic.toSafeBlock')));
  });

  test('runner prohibits shell and curl leakage patterns', () {
    expect(runner, isNot(contains('set -x')));
    expect(runner, isNot(contains('curl -v')));
    expect(runner, isNot(contains('curl --verbose')));
    expect(runner, isNot(contains('curl --trace')));
    expect(runner, isNot(contains(r'cat "$tmp_dir/auth-user.json"')));
    expect(runner, isNot(contains(r'echo "$synthetic_access_token"')));
    expect(runner, contains('capture_http_channels'));
    expect(runner, contains(r'rm -f "$synthetic_user_curl_error"'));
    expect(runner, contains(r'chmod 700 "$tmp_dir"'));
    expect(httpContract, contains(r'>"$metadata_file" 2>"$diagnostic_file"'));
    expect(httpContract, contains(r'>"$transport_file"'));
    expect(httpContract, isNot(contains('set -x')));
  });

  test(
    'transport, HTTP status, body and diagnostics use separate channels',
    () {
      expect(httpContract, contains('strict_transport_exit_from_file'));
      expect(httpContract, contains('strict_http_status_from_file'));
      expect(httpContract, contains('response_body_file'));
      expect(httpContract, contains('diagnostic_file'));
      expect(httpContract, contains('metadata_file'));
      expect(runner, contains(r'test "$synthetic_user_curl_status" = 0'));
      expect(runner, contains(r'test "$synthetic_user_status" = 200'));
    },
  );

  test('sanitizer contract is closed and never emits raw content', () {
    for (final field in <String>[
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
      expect(sanitizer, contains("'$field="), reason: field);
    }
    expect(sanitizer, contains('rawBodyLogged=false'));
    expect(sanitizer, contains('diagnosticSanitization='));
    expect(sanitizer, contains('bodyFile.deleteSync()'));
    expect(sanitizer, contains('take(_maximumFieldNames)'));
    expect(sanitizer, contains('const int _maximumFieldNames = 20'));
    expect(sanitizer, isNot(contains('stdout.writeln(body')));
    expect(sanitizer, isNot(contains('stderr.writeln(body')));
    expect(sanitizer, isNot(contains('decoded.values')));
  });

  test('diagnostic tooling contains no remote execution primitive', () {
    for (final forbidden in <String>[
      'supabase link',
      'supabase db push',
      'supabase functions deploy',
      'HttpClient',
      'Socket.connect',
      'Process.run',
      'Process.start',
    ]) {
      expect(sanitizer, isNot(contains(forbidden)), reason: forbidden);
    }
  });
}
