import 'package:stasisly/core/authorization/domain/authorization_audit_event.dart';

// A single-operation port keeps audit persistence outside the policy domain.
// ignore: one_member_abstracts
abstract interface class AuthorizationAuditSink {
  Future<void> record(AuthorizationAuditEvent event);
}
