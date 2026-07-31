import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_4_product_prompts_v1.dart';

void main() {
  test('Wave 4 generator resolves exact scope and deterministic artifacts', () {
    expect(wave4AgentIds, hasLength(50));
    expect(
      wave4AgentIds.where((id) => id.startsWith('AG-PRO-')),
      hasLength(50),
    );
    final first = generateWave4ProductPromptArtifacts();
    final second = generateWave4ProductPromptArtifacts();
    expect(first, second);
    expect(first, hasLength(115));
    expect(
      first.keys.where((path) => path.contains('/evaluations/')),
      hasLength(50),
    );
    expect(
      first.keys.where(
        (path) =>
            !path.contains('/evaluations/') &&
            RegExp(r'/AG-PRO-\d{4}_').hasMatch(path),
      ),
      hasLength(50),
    );
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
