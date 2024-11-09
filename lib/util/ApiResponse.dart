class ApiResponse {
  final String? message;
  final dynamic data;
  final Map<String, String>? errors;
  final bool successful;

  ApiResponse({
    this.message,
    this.data,
    this.errors,
    required this.successful,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      data: json['data'],
      errors: json['errors'] != null ? Map<String, String>.from(json['errors']) : null,
      successful: json['successful'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'errors': errors,
      'successful': successful,
    };
  }
}
