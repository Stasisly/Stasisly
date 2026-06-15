import 'package:stasisly/features/profile/domain/entities/own_profile.dart';
import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';
import 'package:stasisly/features/profile/domain/repositories/own_profile_repository.dart';
import 'package:stasisly/features/profile/domain/validation/display_name_validator.dart';

class DemoOwnProfileRepository implements OwnProfileRepository {
  DemoOwnProfileRepository({
    this.demoId = 'demo-user',
    String displayName = 'Usuario Demo',
  }) : _displayName = displayName;

  final String demoId;
  String _displayName;

  @override
  Future<OwnProfileResult> readOwnProfile() async {
    return OwnProfileSuccess(_profile);
  }

  @override
  Future<UpdateOwnDisplayNameResult> updateOwnDisplayName(
    String displayName,
  ) async {
    final validation = DisplayNameValidator.validate(displayName);
    if (!validation.isValid) {
      return UpdateOwnDisplayNameInvalid(validation.reason!);
    }
    _displayName = validation.value!;
    return UpdateOwnDisplayNameSuccess(_profile);
  }

  OwnProfile get _profile {
    return OwnProfile(id: demoId, displayName: _displayName, isDemo: true);
  }
}
