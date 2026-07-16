import 'package:stasisly/core/authorization/domain/authorization_context.dart';
import 'package:stasisly/core/authorization/domain/authorization_decision.dart';

// A single-operation port gives callers one fail-closed enforcement boundary.
// ignore: one_member_abstracts
abstract interface class AuthorizationEnforcer {
  Future<AuthorizationDecision> enforce(AuthorizationContext context);
}
