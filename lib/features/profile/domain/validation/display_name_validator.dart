import 'package:equatable/equatable.dart';

import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';

class DisplayNameValidation extends Equatable {
  const DisplayNameValidation.valid(this.value) : reason = null;

  const DisplayNameValidation.invalid(this.reason) : value = null;

  final String? value;
  final DisplayNameInvalidReason? reason;

  bool get isValid => reason == null;

  @override
  List<Object?> get props => [value, reason];
}

abstract final class DisplayNameValidator {
  static final RegExp _lineBreak = RegExp(r'[\r\n]');
  static final RegExp _controlCharacter = RegExp(
    r'[\u0000-\u001F\u007F-\u009F]',
  );

  static DisplayNameValidation validate(String input) {
    final value = input.trim();
    if (value.isEmpty) {
      return const DisplayNameValidation.invalid(
        DisplayNameInvalidReason.empty,
      );
    }
    if (_lineBreak.hasMatch(value)) {
      return const DisplayNameValidation.invalid(
        DisplayNameInvalidReason.lineBreak,
      );
    }
    if (_controlCharacter.hasMatch(value)) {
      return const DisplayNameValidation.invalid(
        DisplayNameInvalidReason.controlCharacter,
      );
    }

    final visibleLength = value.runes.length;
    if (visibleLength < 2) {
      return const DisplayNameValidation.invalid(
        DisplayNameInvalidReason.tooShort,
      );
    }
    if (visibleLength > 40) {
      return const DisplayNameValidation.invalid(
        DisplayNameInvalidReason.tooLong,
      );
    }

    return DisplayNameValidation.valid(value);
  }
}
