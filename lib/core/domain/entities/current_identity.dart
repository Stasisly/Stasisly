import 'package:equatable/equatable.dart';

/// Origin of the identity currently used by the application.
enum IdentitySource { demo, authenticated }

/// Minimal identity contract. It deliberately contains no profile or permissions.
class CurrentIdentity extends Equatable {
  const CurrentIdentity({required this.id, required this.source, this.email});

  const CurrentIdentity.demo()
    : id = demoId,
      source = IdentitySource.demo,
      email = null;

  const CurrentIdentity.authenticated({
    required this.id,
    required String this.email,
  }) : source = IdentitySource.authenticated;

  static const String demoId = 'demo-user';

  final String id;
  final IdentitySource source;
  final String? email;

  bool get isDemo => source == IdentitySource.demo;

  @override
  List<Object?> get props => [id, source, email];
}
