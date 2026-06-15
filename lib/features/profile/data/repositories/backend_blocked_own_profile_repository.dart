import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';
import 'package:stasisly/features/profile/domain/repositories/own_profile_repository.dart';
import 'package:stasisly/features/profile/domain/validation/display_name_validator.dart';

/// Explicit gate used until backend activation receives separate approval.
class BackendBlockedOwnProfileRepository implements OwnProfileRepository {
  const BackendBlockedOwnProfileRepository();

  @override
  Future<OwnProfileResult> readOwnProfile() async {
    return const OwnProfileBackendBlocked();
  }

  @override
  Future<UpdateOwnDisplayNameResult> updateOwnDisplayName(
    String displayName,
  ) async {
    final validation = DisplayNameValidator.validate(displayName);
    if (!validation.isValid) {
      return UpdateOwnDisplayNameInvalid(validation.reason!);
    }
    return const UpdateOwnDisplayNameBackendBlocked();
  }
}
