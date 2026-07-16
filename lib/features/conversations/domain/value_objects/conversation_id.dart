import 'package:equatable/equatable.dart';

class ConversationId extends Equatable {
  ConversationId(String value) : value = _requireValid(value);

  const ConversationId._(this.value);

  static const int maxLength = 200;

  final String value;

  static ConversationId? tryParse(String candidate) {
    final normalized = _normalize(candidate);
    return normalized == null ? null : ConversationId._(normalized);
  }

  static String _requireValid(String candidate) {
    final normalized = _normalize(candidate);
    if (normalized == null) {
      throw ArgumentError.value(candidate, 'value', 'Invalid ConversationId.');
    }
    return normalized;
  }

  static String? _normalize(String candidate) {
    final normalized = candidate.trim();
    if (normalized.isEmpty ||
        normalized.length > maxLength ||
        normalized.codeUnits.any((unit) => unit < 0x20 || unit == 0x7f)) {
      return null;
    }
    return normalized;
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
