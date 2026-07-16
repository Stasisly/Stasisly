import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/conversations/application/idempotency/operation_attempt_id_factory.dart';

void main() {
  test(
    'secure operation attempts are opaque, bounded and unique per intent',
    () {
      const factory = SecureOperationAttemptIdFactory();
      final first = factory.create();
      final second = factory.create();

      expect(first, matches(RegExp(r'^op_[0-9a-f]{32}$')));
      expect(second, matches(RegExp(r'^op_[0-9a-f]{32}$')));
      expect(first, isNot(second));
      expect(first.length, inInclusiveRange(16, 128));
    },
  );
}
