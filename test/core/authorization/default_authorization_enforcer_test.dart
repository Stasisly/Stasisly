import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/authorization.dart';

void main() {
  final context = AuthorizationContext(correlationId: 'correlation-1');

  test('policy unavailable remains a typed deny', () async {
    final enforcer = DefaultAuthorizationEnforcer(
      decisionPoint: const _UnavailablePolicy(),
      auditSink: _RecordingAuditSink(),
    );

    final decision = await enforcer.enforce(context);

    expect(decision.type, AuthorizationDecisionType.deny);
    expect(decision.reasonCode, AuthorizationReasonCode.policyUnavailable);
  });

  test('policy exception fails closed as policyError', () async {
    final sink = _RecordingAuditSink();
    final enforcer = DefaultAuthorizationEnforcer(
      decisionPoint: const _ThrowingPolicy(),
      auditSink: sink,
    );

    final decision = await enforcer.enforce(context);

    expect(decision.type, AuthorizationDecisionType.deny);
    expect(decision.reasonCode, AuthorizationReasonCode.policyError);
    expect(decision.auditRequired, isTrue);
    expect(sink.events, hasLength(1));
    expect(sink.events.single.reasonCode, AuthorizationReasonCode.policyError);
  });

  test('audit-required decision records minimized event', () async {
    final sink = _RecordingAuditSink();
    final enforcer = DefaultAuthorizationEnforcer(
      decisionPoint: const _AuditedDenyPolicy(),
      auditSink: sink,
    );

    final decision = await enforcer.enforce(context);

    expect(decision.type, AuthorizationDecisionType.deny);
    expect(sink.events, hasLength(1));
    expect(sink.events.single.correlationId, 'correlation-1');
  });

  test('audit failure converts any decision to deny', () async {
    const enforcer = DefaultAuthorizationEnforcer(
      decisionPoint: _AuditedAllowPolicy(),
      auditSink: _FailingAuditSink(),
    );

    final decision = await enforcer.enforce(context);

    expect(decision.type, AuthorizationDecisionType.deny);
    expect(decision.reasonCode, AuthorizationReasonCode.policyError);
  });
}

class _UnavailablePolicy implements AuthorizationPolicyDecisionPoint {
  const _UnavailablePolicy();

  @override
  Future<AuthorizationDecision> evaluate(AuthorizationContext context) async {
    return const AuthorizationDecision(
      type: AuthorizationDecisionType.deny,
      reasonCode: AuthorizationReasonCode.policyUnavailable,
      policyReference: 'unavailable-test',
      auditRequired: false,
    );
  }
}

class _ThrowingPolicy implements AuthorizationPolicyDecisionPoint {
  const _ThrowingPolicy();

  @override
  Future<AuthorizationDecision> evaluate(AuthorizationContext context) {
    throw StateError('synthetic policy failure');
  }
}

class _AuditedDenyPolicy implements AuthorizationPolicyDecisionPoint {
  const _AuditedDenyPolicy();

  @override
  Future<AuthorizationDecision> evaluate(AuthorizationContext context) async {
    return const AuthorizationDecision(
      type: AuthorizationDecisionType.deny,
      reasonCode: AuthorizationReasonCode.explicitDeny,
      policyReference: 'audit-test',
      auditRequired: true,
      obligations: {AuthorizationObligation.recordAudit},
    );
  }
}

class _AuditedAllowPolicy implements AuthorizationPolicyDecisionPoint {
  const _AuditedAllowPolicy();

  @override
  Future<AuthorizationDecision> evaluate(AuthorizationContext context) async {
    return const AuthorizationDecision(
      type: AuthorizationDecisionType.allow,
      reasonCode: AuthorizationReasonCode.authenticated,
      policyReference: 'audit-test',
      auditRequired: true,
      obligations: {AuthorizationObligation.recordAudit},
    );
  }
}

class _RecordingAuditSink implements AuthorizationAuditSink {
  final events = <AuthorizationAuditEvent>[];

  @override
  Future<void> record(AuthorizationAuditEvent event) async {
    events.add(event);
  }
}

class _FailingAuditSink implements AuthorizationAuditSink {
  const _FailingAuditSink();

  @override
  Future<void> record(AuthorizationAuditEvent event) {
    throw StateError('synthetic audit failure');
  }
}
