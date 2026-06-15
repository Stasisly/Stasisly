import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'profile contract exposes only approved fields and no executable adapter',
    () {
      final model = File(
        'lib/features/profile/data/models/own_profile_model.dart',
      ).readAsStringSync();
      final dataSource = File(
        'lib/features/profile/data/datasources/own_profile_remote_datasource.dart',
      ).readAsStringSync();
      final providers = File(
        'lib/features/profile/presentation/providers/own_profile_providers.dart',
      ).readAsStringSync();

      expect(model, contains("{'id', 'display_name'}"));
      expect(model, isNot(contains('role')));
      expect(dataSource, contains('select=*'));
      expect(dataSource, contains('Must send only `display_name`'));
      expect(providers, contains('BackendBlockedOwnProfileRepository'));
      expect(providers, isNot(contains('Supabase.instance')));
    },
  );

  test(
    'profile repository source never issues select star or extra payloads',
    () {
      final files = Directory('lib/features/profile')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));

      for (final file in files) {
        final source = file.readAsStringSync();
        if (file.path.endsWith('own_profile_remote_datasource.dart')) continue;

        expect(source, isNot(contains('select=*')), reason: file.path);
        expect(source, isNot(contains("'role':")), reason: file.path);
      }
    },
  );
}
