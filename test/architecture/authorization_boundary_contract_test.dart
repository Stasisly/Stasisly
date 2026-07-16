import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final authorizationRoot = Directory('lib/core/authorization');

  Iterable<File> dartFiles(Directory root) {
    return root
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
  }

  test('authorization domain is provider and UI neutral', () {
    for (final file in dartFiles(authorizationRoot)) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'Supabase',
        'BuildContext',
        'Widget',
        'flutter/material.dart',
        'accessToken',
        'refreshToken',
        'service_role',
        'prompt',
        'Map<',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('identity remains free of authorization authority', () {
    final source = File(
      'lib/core/identity/domain/stasisly_identity.dart',
    ).readAsStringSync();

    for (final forbidden in [
      'role',
      'permission',
      'entitlement',
      'surface',
      'owner',
      'elevation',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
  });

  test('policy never uses commercial plan as direct permission', () {
    final policy = File(
      'lib/core/authorization/infrastructure/'
      'local_foundation_policy_decision_point.dart',
    ).readAsStringSync();

    expect(policy, isNot(contains('.plan')));
    expect(policy, contains('satisfiesRequirement'));
  });

  test('ownership enters profile gate only from trusted response', () {
    final gate = File(
      'lib/features/profile/application/'
      'own_profile_read_authorization_gate.dart',
    ).readAsStringSync();
    final repository = File(
      'lib/features/profile/data/repositories/'
      'own_profile_repository_impl.dart',
    ).readAsStringSync();

    expect(gate, contains('TrustedOwnerReference.fromTrustedBoundary'));
    expect(gate, contains('trustedProfileSubjectId'));
    expect(gate, isNot(contains('agentId')));
    expect(repository, contains('profile.id'));
    expect(repository, isNot(contains('ownerUserId')));
  });

  test('widgets and shells contain no authorization decisions', () {
    final presentationRoots = [
      Directory('lib/features/profile/presentation'),
      Directory('lib/features/chat_sessions/presentation'),
      Directory('lib/features/chat_messages/presentation'),
    ];

    for (final file in presentationRoots.expand(dartFiles)) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains('AuthorizationDecisionType')),
        reason: file.path,
      );
      expect(
        source,
        isNot(contains('AuthorizationPolicyDecisionPoint')),
        reason: file.path,
      );
    }
  });

  test('unknown and policy failures are explicit deny paths', () {
    final policy = File(
      'lib/core/authorization/infrastructure/'
      'local_foundation_policy_decision_point.dart',
    ).readAsStringSync();
    final enforcer = File(
      'lib/core/authorization/application/default_authorization_enforcer.dart',
    ).readAsStringSync();

    expect(policy, contains('AuthorizationSurface.unknown'));
    expect(policy, contains('AuthorizationEnvironment.unknown'));
    expect(policy, contains('AuthorizationAction.unknown'));
    expect(policy, contains('AuthorizationResourceType.unknown'));
    expect(enforcer, contains('AuthorizationReasonCode.policyError'));
    expect(enforcer, isNot(contains('catch (_)')));
  });
}
