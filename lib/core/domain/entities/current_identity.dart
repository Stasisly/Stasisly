import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

/// Origin of the identity currently used by the application.
enum IdentitySource { demo, authenticated }

/// Compatibility view over the Stasisly-owned identity contract.
@Deprecated('Use StasislyIdentity for new code.')
class CurrentIdentity extends StasislyIdentity {
  const CurrentIdentity({
    required String id,
    required this.source,
    String? email,
  }) : super(
         subjectId: id,
         identityType: IdentityType.humanUser,
         authenticationState: source == IdentitySource.authenticated
             ? AuthenticationState.authenticated
             : AuthenticationState.unauthenticated,
         email: email,
       );

  const CurrentIdentity.demo() : this(id: demoId, source: IdentitySource.demo);

  const CurrentIdentity.authenticated({
    required String id,
    required String email,
  }) : this(id: id, source: IdentitySource.authenticated, email: email);

  static const String demoId = 'demo-user';

  final IdentitySource source;

  String get id => subjectId;

  bool get isDemo => source == IdentitySource.demo;

  @override
  List<Object?> get props => [...super.props, source];
}
