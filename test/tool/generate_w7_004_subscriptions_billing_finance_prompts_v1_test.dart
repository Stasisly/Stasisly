import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_w7_004_subscriptions_billing_finance_prompts_v1.dart';

void main() {
  test('W7-004 generation is deterministic and synchronized', () {
    final first = generateW7004SubscriptionsBillingFinancePromptArtifacts();
    final second = generateW7004SubscriptionsBillingFinancePromptArtifacts();
    expect(first, second);
    expect(first, hasLength(109));
    expect(first.keys.where((p) => p.contains('/identities/')), hasLength(22));
    expect(
      first.keys.where((p) => p.contains('/effective_prompts/')),
      hasLength(22),
    );
    expect(first.keys.where((p) => p.contains('/manifests/')), hasLength(22));
    expect(first.keys.where((p) => p.contains('/evaluations/')), hasLength(22));
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}
