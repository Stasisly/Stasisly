import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

class SelectableSpecialistsRemoteResponse {
  const SelectableSpecialistsRemoteResponse({
    required this.statusCode,
    this.body,
    this.errorCode,
  });

  final int statusCode;
  final Map<String, dynamic>? body;
  final String? errorCode;
}

/// Future backend contract only. No executable network adapter is registered.
// ignore: one_member_abstracts
abstract class SelectableSpecialistsRemoteDataSource {
  Future<SelectableSpecialistsRemoteResponse> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  });
}
