import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/domain/authorization_audit_event.dart';
import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/ports/authorization_audit_sink.dart';
import 'package:stasisly/core/routing/application/boundary_audit_recorder.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';

void main() {
  test('records only minimized typed boundary data when required', () async {
    final sink = _RecordingAuditSink();
    final recorder = BoundaryAuditRecorder(sink);

    await recorder.recordIfRequired(
      const EntryPointContext(
        surface: AuthorizationSurface.development,
        environment: AuthorizationEnvironment.production,
        entryPointId: EntryPointId.developmentChatSession,
        authenticationRequirement:
            EntryPointAuthenticationRequirement.authenticated,
        authorizationRequirement: EntryPointAuthorizationRequirement.none,
        legacyState: EntryPointLegacyState.developmentOnly,
        correlationId: 'boundary-test-1',
      ),
      const BoundaryDecision(
        type: BoundaryDecisionType.blockedByEnvironment,
        reasonCode: BoundaryReasonCode.environmentMismatch,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.environmentBlocked,
      ),
    );

    expect(sink.events, hasLength(1));
    final event = sink.events.single;
    expect(event.subjectId, isNull);
    expect(event.entryPointReference, 'developmentChatSession');
    expect(event.legacyStateReference, 'developmentOnly');
    expect(event.correlationId, 'boundary-test-1');
  });
}

class _RecordingAuditSink implements AuthorizationAuditSink {
  final events = <AuthorizationAuditEvent>[];

  @override
  Future<void> record(AuthorizationAuditEvent event) async {
    events.add(event);
  }
}
