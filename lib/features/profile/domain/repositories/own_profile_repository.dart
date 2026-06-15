import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';

abstract class OwnProfileRepository {
  Future<OwnProfileResult> readOwnProfile();

  Future<UpdateOwnDisplayNameResult> updateOwnDisplayName(String displayName);
}
