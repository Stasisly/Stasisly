import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';
import 'package:stasisly/features/profile/domain/validation/display_name_validator.dart';

void main() {
  group('DisplayNameValidator', () {
    test('accepts approved names and trims outer whitespace', () {
      final result = DisplayNameValidator.validate('  Raúl_Martínez-2.0  ');

      expect(result.isValid, isTrue);
      expect(result.value, 'Raúl_Martínez-2.0');
    });

    test('does not add an unapproved emoji-specific ban', () {
      final result = DisplayNameValidator.validate('Ana 🙂');

      expect(result.isValid, isTrue);
    });

    test('rejects empty and one visible character', () {
      expect(
        DisplayNameValidator.validate('   ').reason,
        DisplayNameInvalidReason.empty,
      );
      expect(
        DisplayNameValidator.validate('A').reason,
        DisplayNameInvalidReason.tooShort,
      );
    });

    test('rejects more than 40 visible code points', () {
      final result = DisplayNameValidator.validate('a' * 41);

      expect(result.reason, DisplayNameInvalidReason.tooLong);
    });

    test('rejects line breaks and control characters', () {
      expect(
        DisplayNameValidator.validate('Ana\nMaría').reason,
        DisplayNameInvalidReason.lineBreak,
      );
      expect(
        DisplayNameValidator.validate('Ana\u0007María').reason,
        DisplayNameInvalidReason.controlCharacter,
      );
    });
  });
}
