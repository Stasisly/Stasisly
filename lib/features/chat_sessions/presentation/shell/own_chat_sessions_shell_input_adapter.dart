class OwnChatSessionsShellInput {
  const OwnChatSessionsShellInput({
    this.sessionId,
    this.selectableSpecialistId,
  });

  final String? sessionId;
  final String? selectableSpecialistId;

  bool get hasInput => sessionId != null || selectableSpecialistId != null;
}

class OwnChatSessionsShellInputAdapter {
  const OwnChatSessionsShellInputAdapter();

  OwnChatSessionsShellInput? from(Map<String, String?> values) {
    final sessionId = _safeUuid(values['sessionId']);
    final selectableSpecialistId = _safeUuid(values['selectableSpecialistId']);
    if (sessionId == null && selectableSpecialistId == null) return null;
    return OwnChatSessionsShellInput(
      sessionId: sessionId,
      selectableSpecialistId: selectableSpecialistId,
    );
  }

  String? sessionIdFrom(Map<String, String?> values) {
    return _safeUuid(values['sessionId']);
  }

  String? selectableSpecialistIdFrom(Map<String, String?> values) {
    return _safeUuid(values['selectableSpecialistId']);
  }
}

String? _safeUuid(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  if (!_uuidPattern.hasMatch(normalized)) return null;
  return normalized;
}

final _uuidPattern = RegExp(
  r'^[\da-fA-F]{8}-[\da-fA-F]{4}-[1-5][\da-fA-F]{3}-[89abAB][\da-fA-F]{3}-[\da-fA-F]{12}$',
);
