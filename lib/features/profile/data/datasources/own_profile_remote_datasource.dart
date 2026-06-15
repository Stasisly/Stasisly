class OwnProfileRemoteResponse {
  const OwnProfileRemoteResponse({
    required this.statusCode,
    this.rows = const [],
    this.errorCode,
  });

  final int statusCode;
  final List<Map<String, dynamic>> rows;
  final String? errorCode;
}

abstract class OwnProfileRemoteDataSource {
  /// Must request exactly `id,display_name`; `select=*` is forbidden.
  Future<OwnProfileRemoteResponse> readOwnProfile();

  /// Must send only `display_name` and request `id,display_name` back.
  Future<OwnProfileRemoteResponse> updateOwnDisplayName(String displayName);
}
