import 'dart:convert';

class ApiResponse {
  bool error;
  bool status;
  dynamic data;

  ApiResponse({
    required this.error,
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      error: map['error'] ?? false,
      status: map['status'] ?? false,
      data: map['data'],
    );
  }

  factory ApiResponse.fromJson(String source) =>
      ApiResponse.fromMap(json.decode(source));
}
