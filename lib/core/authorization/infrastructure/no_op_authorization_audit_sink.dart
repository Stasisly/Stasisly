import 'package:stasisly/core/authorization/domain/authorization_audit_event.dart';
import 'package:stasisly/core/authorization/ports/authorization_audit_sink.dart';

/// Local contract-validation sink. It must never be selected for remote use.
class LocalNoOpAuthorizationAuditSink implements AuthorizationAuditSink {
  const LocalNoOpAuthorizationAuditSink();

  @override
  Future<void> record(AuthorizationAuditEvent event) async {}
}
