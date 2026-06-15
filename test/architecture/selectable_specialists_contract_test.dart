import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('catalog model contains only the approved six backend fields', () {
    final model = File(
      'lib/features/specialists/data/models/selectable_specialist_model.dart',
    ).readAsStringSync();

    for (final field in [
      "'id'",
      "'displayName'",
      "'area'",
      "'shortDescription'",
      "'accessState'",
      "'isDemo'",
    ]) {
      expect(model, contains(field));
    }
    for (final forbidden in [
      "'specialist_id'",
      "'specialistId'",
      "'internalSpecialistId'",
      "'prompt'",
      "'prompt_template'",
      "'promptTemplate'",
      "'systemPrompt'",
      "'branch_id'",
      "'chief_id'",
      "'access_tier'",
      "'availability_status'",
      "'is_published'",
      "'created_at'",
      "'updated_at'",
      "'role'",
      "'roles'",
      "'permissions'",
      "'instructions'",
      "'sessionId'",
    ]) {
      expect(model, isNot(contains(forbidden)));
    }
  });

  test('specialists feature has no executable backend or chat coupling', () {
    final files = Directory('lib/features/specialists')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in files) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'Supabase.instance',
        'functions.invoke',
        'chat_sessions',
        'createChatSession',
        'service_role',
        'EdgeFunctionSelectable',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('runtime provider keeps every non-demo mode blocked', () {
    final providers = File(
      'lib/features/specialists/presentation/providers/'
      'selectable_specialists_providers.dart',
    ).readAsStringSync();

    expect(providers, contains('DemoSelectableSpecialistsRepository'));
    expect(
      providers,
      contains('BackendBlockedSelectableSpecialistsRepository'),
    );
    expect(providers, isNot(contains('SelectableSpecialistsRepositoryImpl')));
  });
}
