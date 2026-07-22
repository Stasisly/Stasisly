import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

class SelectableSpecialistModel {
  const SelectableSpecialistModel({
    required this.selectableSpecialistId,
    required this.displayName,
    required this.publicArea,
    required this.publicDescription,
    required this.accessState,
  });

  factory SelectableSpecialistModel.fromBackendJson(Map<String, dynamic> json) {
    final keys = json.keys.toSet();
    if (keys.difference(allowedBackendFields).isNotEmpty ||
        !keys.containsAll(allowedBackendFields)) {
      throw const FormatException('Unexpected specialist catalog fields.');
    }

    final selectableSpecialistId = _nonEmptyString(
      json['selectableSpecialistId'],
      'selectableSpecialistId',
    );
    final displayName = _nonEmptyString(json['displayName'], 'displayName');
    final publicDescription = _nonEmptyString(
      json['publicDescription'],
      'publicDescription',
    );
    final publicArea = _parseArea(json['publicArea']);
    final accessState = _parseAccessState(json['accessState']);
    if (accessState == SelectableSpecialistAccessState.demoOnly) {
      throw const FormatException('Backend catalog cannot claim demo data.');
    }

    return SelectableSpecialistModel(
      selectableSpecialistId: selectableSpecialistId,
      displayName: displayName,
      publicArea: publicArea,
      publicDescription: publicDescription,
      accessState: accessState,
    );
  }

  static const Set<String> allowedBackendFields = {
    'selectableSpecialistId',
    'displayName',
    'publicArea',
    'publicDescription',
    'accessState',
  };

  final String selectableSpecialistId;
  final String displayName;
  final SelectableSpecialistArea publicArea;
  final String publicDescription;
  final SelectableSpecialistAccessState accessState;

  SelectableSpecialist toEntity() {
    return SelectableSpecialist(
      selectableSpecialistId: selectableSpecialistId,
      displayName: displayName,
      publicArea: publicArea,
      publicDescription: publicDescription,
      accessState: accessState,
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
