import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_w7_008_product_health_mixed_risk_prompts_v1.dart';

void main() {
  test('W7-008 generation is deterministic and synchronized', () {
    final first = generateW7008ProductHealthMixedRiskPromptArtifacts();
    final second = generateW7008ProductHealthMixedRiskPromptArtifacts();
    expect(first, second);
    expect(first, hasLength(391));
    expect(first.keys.where((p) => p.contains('/identities/')), hasLength(90));
    expect(
      first.keys.where((p) => p.contains('/effective_prompts/')),
      hasLength(90),
    );
    expect(first.keys.where((p) => p.contains('/manifests/')), hasLength(90));
    expect(first.keys.where((p) => p.contains('/evaluations/')), hasLength(90));
    for (final path in first.keys.where((p) => p.contains('/identities/'))) {
      expect(first[path], contains('prompt_strategy: FULL_INDIVIDUAL_PROMPT'));
      expect(first[path], contains('subwave_id: W7-008'));
    }
    for (final path in first.keys.where((p) => p.contains('/manifests/'))) {
      expect(
        first[path],
        contains('"prompt_strategy": "FULL_INDIVIDUAL_PROMPT"'),
      );
      expect(first[path], contains('"subwave_id": "W7-008"'));
      expect(first[path], contains('"deterministic_build_metadata":'));
    }
    for (final path in first.keys.where((p) => p.contains('/evaluations/'))) {
      expect(
        RegExp(
          r'- case_id: AG-PRO-\d{4}-ADV-\d{2}',
        ).allMatches(first[path]!).length,
        10,
      );
      expect(
        RegExp('- domain-specific threat:').allMatches(first[path]!).length,
        10,
      );
      expect(RegExp('- data boundary:').allMatches(first[path]!).length, 10);
      expect(RegExp('- tool boundary:').allMatches(first[path]!).length, 10);
      expect(RegExp('- memory boundary:').allMatches(first[path]!).length, 10);
      expect(
        RegExp('- human review requirement:').allMatches(first[path]!).length,
        10,
      );
      expect(
        RegExp(
          '- Founder escalation when applicable:',
        ).allMatches(first[path]!).length,
        10,
      );
    }
    for (final path in first.keys.where((p) => p.contains('/composable/'))) {
      expect(first[path], contains('artifact_type:'));
      expect(first[path], contains('risk_compatibility: HIGH;CRITICAL'));
      expect(first[path], contains('dependencies:'));
      expect(first[path], contains('incompatible_with:'));
      expect(first[path], contains('supersedes: NONE'));
    }
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
