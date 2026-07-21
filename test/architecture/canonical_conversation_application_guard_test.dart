import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final application = Directory('lib/features/conversations/application');
  final widgetFiles = [
    File(
      'lib/features/conversations/composition/inactive_conversation_feature_host.dart',
    ),
    ...Directory('lib/features/conversations/presentation/widgets')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart')),
  ];

  test('canonical application is provider and transport neutral', () {
    for (final file
        in application
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('package:dio/')), reason: file.path);
      expect(source, isNot(contains('supabase_flutter')), reason: file.path);
      expect(source, isNot(contains('dart:io')), reason: file.path);
      expect(source, isNot(contains('features/chat/')), reason: file.path);
      expect(source, isNot(contains('flutter_riverpod')), reason: file.path);
      expect(source, isNot(contains('BuildContext')), reason: file.path);
    }
  });

  test('widgets do not call repositories or generate operation attempts', () {
    for (final file in widgetFiles) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains('ConversationRepository')),
        reason: file.path,
      );
      expect(
        source,
        isNot(contains('SecureOperationAttemptIdFactory')),
        reason: file.path,
      );
      expect(source, isNot(contains('features/chat/')), reason: file.path);
    }
  });

  test('inactive host has no routing, transport, owner or hidden activation', () {
    final host = File(
      'lib/features/conversations/composition/inactive_conversation_feature_host.dart',
    ).readAsStringSync();
    expect(host, isNot(contains("import 'package:stasisly/core/routing")));
    expect(host, isNot(contains('go_router')));
    expect(host, isNot(contains('Navigator')));
    expect(host, isNot(contains('ownerSubjectId')));
    expect(host, isNot(contains('http')));
    expect(host, isNot(contains('supabase')));

    final activeComposition = [
      File('lib/app.dart'),
      File('lib/main.dart'),
      ...Directory(
        'lib/core/routing',
      ).listSync(recursive: true).whereType<File>(),
    ];
    for (final file in activeComposition.where((file) => file.existsSync())) {
      expect(
        file.readAsStringSync(),
        isNot(contains('InactiveConversationFeatureHost')),
        reason: file.path,
      );
    }
  });

  test('public send input remains content-only and ownership-free', () {
    final source = File(
      'lib/features/conversations/application/inputs/conversation_inputs.dart',
    ).readAsStringSync();
    expect(source, isNot(contains('ownerSubjectId')));
    expect(source, isNot(contains('userId')));
    expect(source, isNot(contains('agentId')));
    expect(source, isNot(contains('author')));
    expect(source, isNot(contains('provenance')));
    expect(source, isNot(contains('visibility')));
  });

  test('composer state does not expose operation attempt in debug text', () {
    final source = File(
      'lib/features/conversations/application/state/conversation_application_states.dart',
    ).readAsStringSync();
    expect(source, isNot(contains('OperationAttemptId')));
    expect(source, isNot(contains('token')));
    expect(source, isNot(contains('JWT')));
  });
}
