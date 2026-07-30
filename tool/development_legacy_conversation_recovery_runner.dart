import 'dart:io';

import 'development_legacy_conversation_recovery_contracts.dart';

const _manifestPath =
    'docs/stasisly_foundation/development/'
    'development_v4_legacy_conversation_recovery_manifest.json';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1 || arguments.single != '--validate-contract') {
    stderr.writeln('LEGACY_CONVERSATION_RECOVERY_REMOTE_EXECUTION_BLOCKED');
    exitCode = 65;
    return;
  }
  final manifest = LegacyConversationRecoveryManifest.read(File(_manifestPath));
  final findings = manifest.validate();
  if (findings.isNotEmpty) {
    stderr.writeln('LEGACY_CONVERSATION_RECOVERY_CONTRACT_BLOCKED');
    exitCode = 1;
    return;
  }
  stdout
    ..writeln('LEGACY_HISTORICAL_EVIDENCE_INVENTORY_PASS')
    ..writeln('LEGACY_IDENTITY_CANDIDATE_MATRIX_PASS')
    ..writeln('LEGACY_BROAD_LOOKUPS_BLOCKED_PASS')
    ..writeln('LEGACY_EXACT_PROOF_CONTRACTS_PASS')
    ..writeln('LEGACY_REQUEST_BUDGET_ZERO_PASS')
    ..writeln('LEGACY_DIAGNOSTIC_ONLY_DELETE_DISABLED_PASS')
    ..writeln(legacyConversationRecoveryResultUnavailable);
}
