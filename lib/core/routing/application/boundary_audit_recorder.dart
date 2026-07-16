import 'package:stasisly/core/authorization/domain/authorization_audit_event.dart';
import 'package:stasisly/core/authorization/domain/authorization_decision.dart';
import 'package:stasisly/core/authorization/ports/authorization_audit_sink.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';

class BoundaryAuditRecorder {
  const BoundaryAuditRecorder(this._sink);

  final AuthorizationAuditSink _sink;

  Future<void> recordIfRequired(
    EntryPointContext context,
    BoundaryDecision decision,
  ) async {
    if (!decision.auditRequired) return;

    await _sink.record(
      AuthorizationAuditEvent(
        subjectId: null,
        identityType: null,
        action: null,
        resourceType: null,
        surface: context.surface,
        environment: context.environment,
        decision: decision.isAllowed
            ? AuthorizationDecisionType.allow
            : AuthorizationDecisionType.deny,
        reasonCode: _authorizationReason(decision.reasonCode),
        policyReference: 'foundation-010/entry-point-boundary-v1',
        correlationId: context.correlationId,
        entryPointReference: context.entryPointId.name,
        legacyStateReference: context.legacyState.name,
      ),
    );
  }

  AuthorizationReasonCode _authorizationReason(BoundaryReasonCode reason) {
    return switch (reason) {
      BoundaryReasonCode.authenticationRequired =>
        AuthorizationReasonCode.unauthenticated,
      BoundaryReasonCode.unknownSurface || BoundaryReasonCode.surfaceMismatch =>
        AuthorizationReasonCode.surfaceMismatch,
      BoundaryReasonCode.unknownEnvironment ||
      BoundaryReasonCode.environmentMismatch =>
        AuthorizationReasonCode.environmentMismatch,
      BoundaryReasonCode.missingMetadata =>
        AuthorizationReasonCode.missingContext,
      BoundaryReasonCode.policyDenied => AuthorizationReasonCode.explicitDeny,
      _ => AuthorizationReasonCode.explicitDeny,
    };
  }
}
