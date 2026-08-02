import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_w7_001_fraud_risk_prompts_v1.dart';

void main() {
  test('W7-001 generation is deterministic and synchronized', () {
    final first = generateW7001FraudRiskPromptArtifacts();
    final second = generateW7001FraudRiskPromptArtifacts();
    expect(first, second);
    expect(first, hasLength(189));
    expect(first.keys.where((p) => p.contains('/identities/')), hasLength(40));
    expect(
      first.keys.where((p) => p.contains('/effective_prompts/')),
      hasLength(40),
    );
    expect(first.keys.where((p) => p.contains('/manifests/')), hasLength(40));
    expect(first.keys.where((p) => p.contains('/evaluations/')), hasLength(40));
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
