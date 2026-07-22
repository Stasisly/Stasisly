import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Product catalog and create flow retain safe identity boundaries', () {
    final specialistSources = Directory('lib/features/specialists')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => file.readAsStringSync())
        .join('\n');
    final stasis = File(
      'lib/features/conversations/product/presentation/stasis_page.dart',
    ).readAsStringSync();

    expect(specialistSources, contains('SelectableSpecialistCatalog'));
    expect(specialistSources, contains('selectableSpecialistId'));
    expect(specialistSources, isNot(contains('AgentEntity')));
    expect(specialistSources, isNot(contains('agent.id')));
    expect(stasis, contains('_selectedSpecialistId != null'));
    expect(stasis, isNot(contains('items.first')));
    expect(
      stasis,
      isNot(contains('demoSelectableSpecialistsRepositoryProvider')),
    );
    expect(stasis, isNot(contains('SUPABASE_SERVICE_ROLE_KEY')));
  });

  test('fixture cleanup is local, exact and remote skips stay disabled', () {
    final cleanup = File(
      'supabase/tests/'
      'foundation_019c_development_fixture_lifecycle_http_test.sh',
    ).readAsStringSync();
    final manifest = File(
      'docs/stasisly_foundation/development/development_deployment_manifest.json',
    ).readAsStringSync();

    expect(cleanup, contains('http://127.0.0.1:54321'));
    expect(cleanup, contains('run_cycle 1'));
    expect(cleanup, contains('run_cycle 2'));
    expect(cleanup, isNot(contains("like 'foundation_019c")));
    expect(cleanup, isNot(contains(' --linked')));
    expect(cleanup, isNot(contains('service-role maintenance')));
    expect(RegExp('CLASSIFIED_NOT_ENABLED').allMatches(manifest), hasLength(5));
  });
}
