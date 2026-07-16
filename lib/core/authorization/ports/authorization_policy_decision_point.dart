import 'package:stasisly/core/authorization/domain/authorization_context.dart';
import 'package:stasisly/core/authorization/domain/authorization_decision.dart';

// A single-operation port keeps policy evaluation replaceable and testable.
// ignore: one_member_abstracts
abstract interface class AuthorizationPolicyDecisionPoint {
  Future<AuthorizationDecision> evaluate(AuthorizationContext context);
}
