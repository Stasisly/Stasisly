import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_7_specialized_prompt_strategy_v1.dart';

void main() {
  test('Wave 7 strategy generator is deterministic and synchronized', () {
    final first = generateWave7SpecializedPromptStrategyArtifacts();
    final second = generateWave7SpecializedPromptStrategyArtifacts();

    expect(first, second);
    expect(first, hasLength(31));
    expect(first.keys.where((path) => path.endsWith('.csv')), hasLength(6));
    expect(first.keys.where((path) => path.endsWith('.json')), hasLength(7));
    expect(first.keys.where((path) => path.endsWith('.md')), hasLength(18));
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });

  test(
    'synthetic composition fixture cannot be mistaken for an agent prompt',
    () {
      final fixture = syntheticWave7CompositionFixture();
      expect(fixture, contains('SYNTHETIC_TEST_FIXTURE'));
      expect(fixture, contains('NOT_AN_AGENT_PROMPT'));
      expect(fixture, contains('NOT_APPROVED'));
      expect(fixture, contains('MOST_RESTRICTIVE_WINS'));
    },
  );
}
