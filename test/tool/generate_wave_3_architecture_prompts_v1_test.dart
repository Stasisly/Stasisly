import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_3_architecture_prompts_v1.dart';

void main() {
  test('Wave 3 generator resolves exact scope and deterministic artifacts', () {
    expect(wave3AgentIds, hasLength(40));
    expect(
      wave3AgentIds.where((id) => id.startsWith('AG-DEV-')),
      hasLength(40),
    );
    final first = generateWave3ArchitecturePromptArtifacts();
    final second = generateWave3ArchitecturePromptArtifacts();
    expect(first, second);
    expect(first, hasLength(93));
    expect(
      first.keys.where((path) => path.contains('/evaluations/')),
      hasLength(40),
    );
    expect(
      first.keys.where(
        (path) =>
            !path.contains('/evaluations/') &&
            RegExp(r'/AG-DEV-\d{4}_').hasMatch(path),
      ),
      hasLength(40),
    );
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
