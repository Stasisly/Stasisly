import 'dart:math';

import 'package:equatable/equatable.dart';

final class OperationAttemptId extends Equatable {
  OperationAttemptId(String value) : value = _validate(value);

  static final RegExp _safeValue = RegExp(r'^[A-Za-z0-9._~-]{16,128}$');

  final String value;

  static String _validate(String value) {
    if (!_safeValue.hasMatch(value)) {
      throw ArgumentError.value(
        '[redacted]',
        'value',
        'Must contain 16-128 transport-safe characters.',
      );
    }
    return value;
  }

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'OperationAttemptId([redacted])';
}

// One method is intentional: callers own when a new intent starts.
// ignore: one_member_abstracts
abstract interface class OperationAttemptIdFactory {
  OperationAttemptId create();
}

class SecureOperationAttemptIdFactory implements OperationAttemptIdFactory {
  const SecureOperationAttemptIdFactory();

  @override
  OperationAttemptId create() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    final encoded = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return OperationAttemptId('op_$encoded');
  }
}
