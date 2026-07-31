import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_1_coordinator_prompts_v1.dart';

void main() {
  test('Wave 1 generation is deterministic and exact', () {
    final first = generateWave1CoordinatorPromptArtifacts();
    final second = generateWave1CoordinatorPromptArtifacts();
    expect(first, second);
    expect(first, hasLength(11));
    expect(
      first.keys.where(
        (path) => RegExp('/AG-(TRV|PRO|DEV|ADM)-').hasMatch(path),
      ),
      hasLength(8),
    );
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
