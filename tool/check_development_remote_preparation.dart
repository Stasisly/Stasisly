import 'dart:io';

import 'development_remote_execution_contracts.dart';

void main(List<String> arguments) {
  if (arguments.length > 1 ||
      (arguments.isNotEmpty && arguments.single != '--validate-cors')) {
    stderr.writeln(
      'Usage: dart run tool/check_development_remote_preparation.dart '
      '[--validate-cors]',
    );
    exitCode = 64;
    return;
  }
  if (arguments.singleOrNull == '--validate-cors') {
    final valid = const DevelopmentCorsOriginValidator().isValid(
      Platform.environment['DEVELOPMENT_ALLOWED_WEB_ORIGIN'] ?? '',
    );
    stdout.writeln(valid ? 'CORS_ORIGIN_VALID' : 'CORS_ORIGIN_INVALID');
    exitCode = valid ? 0 : 1;
    return;
  }
  final validator = DevelopmentRemotePreparationValidator(Directory.current);
  final findings = validator.validateContracts();
  if (findings.isNotEmpty) {
    stderr.writeln('Development remote preparation contract: BLOCKED.');
    for (final finding in findings) {
      stderr.writeln(finding);
    }
    exitCode = 1;
    return;
  }
  stdout
    ..writeln('Development remote preparation: BLOCKED_MISSING_CORS_ORIGIN.')
    ..writeln('Local contracts are safe for reauthorization preparation.');
}

extension<T> on List<T> {
  T? get singleOrNull => length == 1 ? single : null;
}
