import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/profile/application/own_profile_read_authorization_gate.dart';
import 'package:stasisly/features/profile/data/datasources/own_profile_remote_datasource.dart';
import 'package:stasisly/features/profile/data/models/own_profile_model.dart';
import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';
import 'package:stasisly/features/profile/domain/repositories/own_profile_repository.dart';
import 'package:stasisly/features/profile/domain/validation/display_name_validator.dart';

class OwnProfileRepositoryImpl implements OwnProfileRepository {
  const OwnProfileRepositoryImpl({
    required OwnProfileRemoteDataSource dataSource,
    required StasislyIdentity currentIdentity,
    required AuthorizationEnvironment authorizationEnvironment,
    required OwnProfileReadAuthorizationGate readAuthorizationGate,
  }) : _dataSource = dataSource,
       _currentIdentity = currentIdentity,
       _authorizationEnvironment = authorizationEnvironment,
       _readAuthorizationGate = readAuthorizationGate;

  final OwnProfileRemoteDataSource _dataSource;
  final StasislyIdentity _currentIdentity;
  final AuthorizationEnvironment _authorizationEnvironment;
  final OwnProfileReadAuthorizationGate _readAuthorizationGate;

  @override
  Future<OwnProfileResult> readOwnProfile() async {
    try {
      final response = await _dataSource.readOwnProfile();
      final error = _mapReadError(response);
      if (error != null) return error;

      if (response.rows.isEmpty) return const OwnProfileMissing();
      if (response.rows.length != 1) {
        return const OwnProfileContractViolation();
      }

      final profile = OwnProfileModel.fromJson(response.rows.single);
      if (profile.id != _currentIdentity.subjectId) {
        return const OwnProfileContractViolation();
      }
      final decision = await _readAuthorizationGate.authorize(
        identity: _currentIdentity,
        trustedProfileSubjectId: profile.id,
        environment: _authorizationEnvironment,
        correlationId: 'profile-read:${profile.id}',
      );
      if (!decision.isAllowed) return const OwnProfilePermissionDenied();
      return OwnProfileSuccess(profile.toEntity(isDemo: false));
    } on NetworkException {
      return const OwnProfileNetworkError();
    } on FormatException {
      return const OwnProfileContractViolation();
    } on Exception {
      return const OwnProfileUnexpectedError();
    }
  }

  @override
  Future<UpdateOwnDisplayNameResult> updateOwnDisplayName(
    String displayName,
  ) async {
    final validation = DisplayNameValidator.validate(displayName);
    if (!validation.isValid) {
      return UpdateOwnDisplayNameInvalid(validation.reason!);
    }

    try {
      final response = await _dataSource.updateOwnDisplayName(
        validation.value!,
      );
      final error = _mapUpdateError(response);
      if (error != null) return error;

      if (response.rows.isEmpty) {
        return const UpdateOwnDisplayNameProfileMissing();
      }
      if (response.rows.length != 1) {
        return const UpdateOwnDisplayNameContractViolation();
      }

      final profile = OwnProfileModel.fromJson(response.rows.single);
      if (profile.id != _currentIdentity.subjectId ||
          profile.displayName != validation.value) {
        return const UpdateOwnDisplayNameContractViolation();
      }
      return UpdateOwnDisplayNameSuccess(profile.toEntity(isDemo: false));
    } on NetworkException {
      return const UpdateOwnDisplayNameNetworkError();
    } on FormatException {
      return const UpdateOwnDisplayNameContractViolation();
    } on Exception {
      return const UpdateOwnDisplayNameUnexpectedError();
    }
  }

  OwnProfileResult? _mapReadError(OwnProfileRemoteResponse response) {
    if (response.statusCode == 401) return const OwnProfileUnauthenticated();
    if (response.statusCode == 403 || response.errorCode == '42501') {
      return const OwnProfilePermissionDenied();
    }
    if (response.statusCode != 200) return const OwnProfileUnexpectedError();
    return null;
  }

  UpdateOwnDisplayNameResult? _mapUpdateError(
    OwnProfileRemoteResponse response,
  ) {
    if (response.statusCode == 204) {
      return const UpdateOwnDisplayNameUnconfirmed();
    }
    if (response.statusCode == 401) {
      return const UpdateOwnDisplayNameUnauthenticated();
    }
    if (response.statusCode == 403 || response.errorCode == '42501') {
      return const UpdateOwnDisplayNamePermissionDenied();
    }
    if (response.statusCode != 200) {
      return const UpdateOwnDisplayNameUnexpectedError();
    }
    return null;
  }
}
