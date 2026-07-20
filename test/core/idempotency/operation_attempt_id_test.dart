import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/idempotency/operation_attempt_id.dart';

void main() {
  group('OperationAttemptId', () {
    test('accepts the backend-safe bounded contract', () {
      final attempt = OperationAttemptId('test_attempt_00000001');

      expect(attempt.value, 'test_attempt_00000001');
      expect(attempt.toString(), 'OperationAttemptId([redacted])');
    });

    test(
      'rejects empty, short, long and unsafe values without echoing them',
      () {
        for (final value in [
          '',
          'too-short',
          'a' * 129,
          'unsafe value/secret',
        ]) {
          expect(
            () => OperationAttemptId(value),
            throwsA(
              isA<ArgumentError>().having(
                (error) => error.toString(),
                'safe error',
                isNot(contains(value.isEmpty ? 'never-match-empty' : value)),
              ),
            ),
          );
        }
      },
    );

    test('uses value equality while keeping display redacted', () {
      final first = OperationAttemptId('test_attempt_00000001');
      final same = OperationAttemptId('test_attempt_00000001');
      final other = OperationAttemptId('test_attempt_00000002');

      expect(first, same);
      expect(first.hashCode, same.hashCode);
      expect(first, isNot(other));
      expect('$first', isNot(contains(first.value)));
    });
  });

  test('secure factory creates valid distinct IDs only when requested', () {
    const factory = SecureOperationAttemptIdFactory();
    final first = factory.create();
    final second = factory.create();

    expect(first.value, matches(RegExp(r'^op_[0-9a-f]{32}$')));
    expect(second.value, matches(RegExp(r'^op_[0-9a-f]{32}$')));
    expect(first, isNot(second));
    expect(first.value.length, inInclusiveRange(16, 128));
  });
}
