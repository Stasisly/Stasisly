import 'dart:math';

// One operation keeps one key across any retries performed by its transport.
// ignore: one_member_abstracts
abstract interface class OperationAttemptIdFactory {
  String create();
}

class SecureOperationAttemptIdFactory implements OperationAttemptIdFactory {
  const SecureOperationAttemptIdFactory();

  @override
  String create() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    final encoded = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return 'op_$encoded';
  }
}
