import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_6_administration_prompts_v1.dart';

void main() {
  test('Wave 6 generator resolves exact scope and deterministic artifacts', () {
    expect(wave6AgentIds, hasLength(50));
    expect(
      wave6AgentIds.where((id) => id.startsWith('AG-ADM-')),
      hasLength(50),
    );
    final first = generateWave6AdministrationPromptArtifacts();
    final second = generateWave6AdministrationPromptArtifacts();
    expect(first, second);
    expect(first, hasLength(117));
    expect(
      first.keys.where((path) => path.contains('/evaluations/')),
      hasLength(50),
    );
    expect(
      first.keys.where(
        (path) =>
            !path.contains('/evaluations/') &&
            RegExp(r'/AG-ADM-\d{4}_').hasMatch(path),
      ),
      hasLength(50),
    );
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
