import 'package:stasisly/features/profile/domain/entities/own_profile.dart';

class OwnProfileModel {
  const OwnProfileModel({required this.id, required this.displayName});

  factory OwnProfileModel.fromJson(Map<String, dynamic> json) {
    if (json.keys.toSet().difference(allowedColumns).isNotEmpty ||
        !json.keys.toSet().containsAll(allowedColumns)) {
      throw const FormatException('Unexpected own profile columns.');
    }

    final id = json['id'];
    final displayName = json['display_name'];
    if (id is! String || displayName is! String) {
      throw const FormatException('Invalid own profile field types.');
    }

    return OwnProfileModel(id: id, displayName: displayName);
  }

  static const Set<String> allowedColumns = {'id', 'display_name'};

  final String id;
  final String displayName;

  OwnProfile toEntity({required bool isDemo}) {
    return OwnProfile(id: id, displayName: displayName, isDemo: isDemo);
  }
}
