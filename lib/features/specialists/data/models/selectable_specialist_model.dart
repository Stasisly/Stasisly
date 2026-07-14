import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

class SelectableSpecialistModel {
  const SelectableSpecialistModel({
    required this.id,
    required this.displayName,
    required this.area,
    required this.shortDescription,
    required this.accessState,
    required this.isDemo,
  });

  factory SelectableSpecialistModel.fromBackendJson(Map<String, dynamic> json) {
    final keys = json.keys.toSet();
    if (keys.difference(allowedBackendFields).isNotEmpty ||
        !keys.containsAll(allowedBackendFields)) {
      throw const FormatException('Unexpected specialist catalog fields.');
    }

    final id = _nonEmptyString(json['id'], 'id');
    final displayName = _nonEmptyString(json['displayName'], 'displayName');
    final shortDescription = _nonEmptyString(
      json['shortDescription'],
      'shortDescription',
    );
    final area = _parseArea(json['area']);
    final accessState = _parseAccessState(json['accessState']);
    final isDemo = json['isDemo'];
    if (isDemo is! bool) {
      throw const FormatException('Invalid specialist isDemo.');
    }
    if (isDemo || accessState == SelectableSpecialistAccessState.demoOnly) {
      throw const FormatException('Backend catalog cannot claim demo data.');
    }

    return SelectableSpecialistModel(
      id: id,
      displayName: displayName,
      area: area,
      shortDescription: shortDescription,
      accessState: accessState,
      isDemo: isDemo,
    );
  }

  static const Set<String> allowedBackendFields = {
    'id',
    'displayName',
    'area',
    'shortDescription',
    'accessState',
    'isDemo',
  };

  final String id;
  final String displayName;
  final SelectableSpecialistArea area;
  final String shortDescription;
  final SelectableSpecialistAccessState accessState;
  final bool isDemo;

  SelectableSpecialist toEntity() {
    return SelectableSpecialist(
      id: id,
      displayName: displayName,
      area: area,
      shortDescription: shortDescription,
      accessState: accessState,
      isDemo: isDemo,
    );
  }

  static String _nonEmptyString(Object? value, String field) {
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Invalid specialist $field.');
    }
    return value;
  }

  static SelectableSpecialistArea _parseArea(Object? value) {
    if (value is! String) {
      throw const FormatException('Invalid specialist area.');
    }
    return switch (value) {
      'stasis' => SelectableSpecialistArea.stasis,
      'health' => SelectableSpecialistArea.health,
      'nutrition' => SelectableSpecialistArea.nutrition,
      'training' => SelectableSpecialistArea.training,
      'wellness' => SelectableSpecialistArea.wellness,
      _ => throw const FormatException('Unknown specialist area.'),
    };
  }

  static SelectableSpecialistAccessState _parseAccessState(Object? value) {
    if (value is! String) {
      throw const FormatException('Invalid specialist accessState.');
    }
    return switch (value) {
      'available' => SelectableSpecialistAccessState.available,
      'lockedPro' => SelectableSpecialistAccessState.lockedPro,
      'unavailable' => SelectableSpecialistAccessState.unavailable,
      'demoOnly' => SelectableSpecialistAccessState.demoOnly,
      _ => throw const FormatException('Unknown specialist accessState.'),
    };
  }
}
