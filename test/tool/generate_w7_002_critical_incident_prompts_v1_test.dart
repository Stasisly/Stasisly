import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_w7_002_critical_incident_prompts_v1.dart';

void main() {
  test('W7-002 generation is deterministic and synchronized', () {
    final first = generateW7002CriticalIncidentPromptArtifacts();
    final second = generateW7002CriticalIncidentPromptArtifacts();
    expect(first, second);
    expect(first, hasLength(108));
    expect(first.keys.where((p) => p.contains('/identities/')), hasLength(20));
    expect(
      first.keys.where((p) => p.contains('/effective_prompts/')),
      hasLength(20),
    );
    expect(first.keys.where((p) => p.contains('/manifests/')), hasLength(20));
    expect(first.keys.where((p) => p.contains('/evaluations/')), hasLength(20));
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
