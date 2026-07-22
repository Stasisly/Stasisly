import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_remote_execution_contracts.dart';

void main() {
  test('repository remote preparation is fail closed pending exact CORS', () {
    final validator = DevelopmentRemotePreparationValidator(Directory.current);
    expect(validator.validateContracts(), isEmpty);
    expect(
      validator.status(),
      DevelopmentRemotePreparationStatus.blockedMissingCorsOrigin,
    );
  });

  group('fixture manifest separation', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('remote-contracts-');
      for (final path in <String>[
        DevelopmentRemotePreparationValidator.localManifestPath,
        DevelopmentRemotePreparationValidator.remoteManifestPath,
        DevelopmentRemotePreparationValidator.skipGatePath,
      ]) {
        final target = File('${root.path}/$path');
        target.parent.createSync(recursive: true);
        File(path).copySync(target.path);
      }
    });

    tearDown(() => root.deleteSync(recursive: true));

    test('rejects a local fixture promoted to remote mode', () {
      _mutate(root, DevelopmentRemotePreparationValidator.localManifestPath, (
        value,
      ) {
        final cleanup = value['cleanupContract'];
        if (cleanup is Map<String, Object?>) cleanup['localOnly'] = false;
      });
      expect(
        DevelopmentRemotePreparationValidator(root).validateContracts(),
        isNotEmpty,
      );
    });

    test('rejects staging, production and permissive cleanup', () {
      for (final environment in ['staging', 'production']) {
        _mutate(
          root,
          DevelopmentRemotePreparationValidator.remoteManifestPath,
          (value) => value['environment'] = environment,
        );
        expect(
          DevelopmentRemotePreparationValidator(root).validateContracts(),
          isNotEmpty,
        );
        File(DevelopmentRemotePreparationValidator.remoteManifestPath).copySync(
          '${root.path}/'
          '${DevelopmentRemotePreparationValidator.remoteManifestPath}',
        );
      }
      _mutate(root, DevelopmentRemotePreparationValidator.remoteManifestPath, (
        value,
      ) {
        value['cleanupOnFailure'] = 'OPTIONAL';
        value['wildcardsAllowed'] = true;
      });
      expect(
        DevelopmentRemotePreparationValidator(root).validateContracts(),
        isNotEmpty,
      );
    });

    test('rejects committed remote identifiers and origins', () {
      _mutate(
        root,
        DevelopmentRemotePreparationValidator.remoteManifestPath,
        (value) => value['projectResolution'] = 'https://dev.example.test',
      );
      expect(
        DevelopmentRemotePreparationValidator(root).validateContracts(),
        isNotEmpty,
      );
    });
  });

  group('Development CORS origin', () {
    const validator = DevelopmentCorsOriginValidator();

    test('accepts one exact synthetic HTTPS origin', () {
      expect(validator.isValid('https://dev.example.test'), isTrue);
      expect(validator.isValid('https://dev.example.test:8443'), isTrue);
    });

    test('rejects unsafe, ambiguous and non-Development origins', () {
      for (final value in <String>[
        '',
        '*',
        'UNASSIGNED',
        'https://placeholder.example.test',
        'http://dev.example.test',
        'https://localhost',
        'https://dev.example.test/path',
        'https://dev.example.test?q=1',
        'https://dev.example.test#part',
        'https://user:pass@dev.example.test',
        'https://dev.example.test,https://two.example.test',
        'https://staging.example.test',
        'https://production.example.test',
      ]) {
        expect(validator.isValid(value), isFalse, reason: value);
      }
    });
  });

  group('multi-factor remote gate', () {
    final ready = <String, String>{
      'BACKEND_TARGET_ENVIRONMENT': 'development',
      'REMOTE_CONTEXT_AUTHORIZATION_MODE': 'FOUNDER_AUTHORIZED',
      'REMOTE_PROJECT_CONFIRMED': 'CONFIRMED',
      'DEVELOPMENT_OPERATOR_CONFIRMED': 'CONFIRMED',
      'FOUNDER_AUTHORIZATION_REFERENCE': 'synthetic-approval-reference',
      'AUTHORIZED_COMMIT_MATCHES_HEAD': 'CONFIRMED',
      'DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL': 'APPROVED',
      'REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL': 'APPROVED',
      'REMOTE_CLEANUP_PREFLIGHT': 'PASS',
      'DEVELOPMENT_ALLOWED_WEB_ORIGIN': 'https://dev.example.test',
      'REMOTE_REQUIRED_CONFIGURATION': 'CONFIRMED',
      'REMOTE_SECRET_NAMES_ACKNOWLEDGED': 'CONFIRMED',
    };

    test('all independent synthetic inputs make the contract ready', () {
      final gate = DevelopmentRemoteGateInput.fromEnvironment(ready);
      expect(gate.isReady, isTrue);
      expect(gate.missingConditions, isEmpty);
    });

    test('each missing input closes the gate', () {
      for (final key in ready.keys) {
        final input = Map<String, String>.from(ready)..remove(key);
        expect(
          DevelopmentRemoteGateInput.fromEnvironment(input).isReady,
          isFalse,
          reason: key,
        );
      }
    });

    test('one boolean cannot enable remote tests', () {
      final gate = DevelopmentRemoteGateInput.fromEnvironment({
        'BACKEND_TARGET_ENVIRONMENT': 'development',
        'RUN_REMOTE_TESTS': 'true',
      });
      expect(gate.isReady, isFalse);
    });
  });

  group('cleanup lifecycle', () {
    const alias = 'remote-run-0001';
    const contract = DevelopmentRemoteCleanupContract(
      environment: 'development',
      projectConfirmed: true,
      expectedRunAlias: alias,
    );

    test('requires exact bounded namespace and project', () {
      expect(contract.acceptsRun(alias), isTrue);
      expect(contract.acceptsRun(''), isFalse);
      expect(contract.acceptsRun('*'), isFalse);
      expect(contract.acceptsRun('remote-run-0002'), isFalse);
      expect(
        const DevelopmentRemoteCleanupContract(
          environment: 'staging',
          projectConfirmed: true,
          expectedRunAlias: alias,
        ).acceptsRun(alias),
        isFalse,
      );
      expect(
        const DevelopmentRemoteCleanupContract(
          environment: 'production',
          projectConfirmed: true,
          expectedRunAlias: alias,
        ).acceptsRun(alias),
        isFalse,
      );
      expect(
        const DevelopmentRemoteCleanupContract(
          environment: 'development',
          projectConfirmed: false,
          expectedRunAlias: alias,
        ).acceptsRun(alias),
        isFalse,
      );
    });

    test('classifies clean pass, clean failure and dirty failure', () {
      expect(
        contract.classify(flowPassed: true, cleanupPassed: true),
        RemoteLifecycleClassification.passedClean,
      );
      expect(
        contract.classify(flowPassed: false, cleanupPassed: true),
        RemoteLifecycleClassification.failedClean,
      );
      expect(
        contract.classify(flowPassed: true, cleanupPassed: false),
        RemoteLifecycleClassification.failedDirtyBlocking,
      );
    });

    test(
      'finally cleanup handles partial setup and repeated cleanup',
      () async {
        var residue = 0;
        Future<List<int>> cleanup() async {
          residue = 0;
          return List<int>.filled(7, 0);
        }

        const lifecycle = DevelopmentRemoteFixtureLifecycle(contract);
        for (var cycle = 0; cycle < 2; cycle++) {
          final result = await lifecycle.run(
            runAlias: alias,
            setup: () async => residue = 3,
            flow: () async => throw StateError('controlled synthetic failure'),
            cleanup: cleanup,
          );
          expect(result, RemoteLifecycleClassification.failedClean);
          expect(residue, 0);
          expect(await cleanup(), List<int>.filled(7, 0));
        }
      },
    );

    test('safe evidence contains only a redacted alias and seven counts', () {
      final evidence = contract.safeEvidence(
        runAlias: alias,
        cleanupCounts: List<int>.filled(7, 0),
      );
      expect(evidence.keys, {'fixtureNamespaceReference', 'cleanupCounts'});
      expect(jsonEncode(evidence), isNot(contains(alias)));
    });
  });
}

void _mutate(
  Directory root,
  String path,
  void Function(Map<String, Object?> value) mutation,
) {
  final file = File('${root.path}/$path');
  final value = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  mutation(value);
  file.writeAsStringSync(jsonEncode(value));
}
