import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_2_governance_prompts_v1.dart';

void main() {
  test('Wave 2 generator resolves exact scope and deterministic artifacts', () {
    expect(wave2AgentIds, hasLength(18));
    expect(wave2AgentIds, {
      for (var index = 2; index <= 19; index++)
        'AG-TRV-${index.toString().padLeft(4, '0')}',
    });
    final first = generateWave2GovernancePromptArtifacts();
    final second = generateWave2GovernancePromptArtifacts();
    expect(first, second);
    expect(first, hasLength(45));
    expect(
      first.keys.where((path) => path.contains('/evaluations/')),
      hasLength(18),
    );
    expect(
      first.keys.where(
        (path) =>
            !path.contains('/evaluations/') &&
            RegExp(r'/AG-TRV-\d{4}_').hasMatch(path),
      ),
      hasLength(18),
    );
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
