import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_w7_003_privacy_compliance_prompts_v1.dart';

void main() {
  test('W7-003 generation is deterministic and synchronized', () {
    final first = generateW7003PrivacyCompliancePromptArtifacts();
    final second = generateW7003PrivacyCompliancePromptArtifacts();
    expect(first, second);
    expect(first, hasLength(211));
    expect(first.keys.where((p) => p.contains('/identities/')), hasLength(45));
    expect(
      first.keys.where((p) => p.contains('/effective_prompts/')),
      hasLength(45),
    );
    expect(first.keys.where((p) => p.contains('/manifests/')), hasLength(45));
    expect(first.keys.where((p) => p.contains('/evaluations/')), hasLength(45));
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
