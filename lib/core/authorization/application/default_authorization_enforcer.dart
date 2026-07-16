import 'package:stasisly/core/authorization/domain/authorization_audit_event.dart';
import 'package:stasisly/core/authorization/domain/authorization_context.dart';
import 'package:stasisly/core/authorization/domain/authorization_decision.dart';
import 'package:stasisly/core/authorization/ports/authorization_audit_sink.dart';
import 'package:stasisly/core/authorization/ports/authorization_enforcer.dart';
import 'package:stasisly/core/authorization/ports/authorization_policy_decision_point.dart';

class DefaultAuthorizationEnforcer implements AuthorizationEnforcer {
  const DefaultAuthorizationEnforcer({
    required AuthorizationPolicyDecisionPoint decisionPoint,
    required AuthorizationAuditSink auditSink,
  }) : _decisionPoint = decisionPoint,
       _auditSink = auditSink;

  static const _enforcerPolicy = 'foundation-009/enforcer-v1';

  final AuthorizationPolicyDecisionPoint _decisionPoint;
  final AuthorizationAuditSink _auditSink;

  @override
  Future<AuthorizationDecision> enforce(AuthorizationContext context) async {
    AuthorizationDecision decision;
    try {
      decision = await _decisionPoint.evaluate(context);
    } on Object {
      decision = const AuthorizationDecision(
        type: AuthorizationDecisionType.deny,
        reasonCode: AuthorizationReasonCode.policyError,
        policyReference: _enforcerPolicy,
        auditRequired: true,
        obligations: {AuthorizationObligation.recordAudit},
      );
    }

    if (!decision.auditRequired) return decision;

    try {
      await _auditSink.record(
        AuthorizationAuditEvent(
          subjectId: context.identity?.subjectId,
          identityType: context.identity?.identityType,
          action: context.action,
          resourceType: context.resource?.type,
          surface: context.surface,
          environment: context.environment,
          decision: decision.type,
          reasonCode: decision.reasonCode,
          policyReference: decision.policyReference,
          correlationId: context.correlationId,
        ),
      );
      return decision;
    } on Object {
      return const AuthorizationDecision(
        type: AuthorizationDecisionType.deny,
        reasonCode: AuthorizationReasonCode.policyError,
        policyReference: _enforcerPolicy,
        auditRequired: true,
        obligations: {AuthorizationObligation.recordAudit},
      );
    }
  }
}
