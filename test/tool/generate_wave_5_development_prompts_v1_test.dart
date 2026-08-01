import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_5_development_prompts_v1.dart';

void main() {
  test('Wave 5 generator resolves exact scope and deterministic artifacts', () {
    expect(wave5AgentIds, hasLength(60));
    expect(
      wave5AgentIds.where((id) => id.startsWith('AG-DEV-')),
      hasLength(60),
    );
    final first = generateWave5DevelopmentPromptArtifacts();
    final second = generateWave5DevelopmentPromptArtifacts();
    expect(first, second);
    expect(first, hasLength(137));
    expect(
      first.keys.where((path) => path.contains('/evaluations/')),
      hasLength(60),
    );
    expect(
      first.keys.where(
        (path) =>
            !path.contains('/evaluations/') &&
            RegExp(r'/AG-DEV-\d{4}_').hasMatch(path),
      ),
      hasLength(60),
    );
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
