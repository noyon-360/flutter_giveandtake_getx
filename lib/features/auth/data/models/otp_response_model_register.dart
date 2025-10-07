class OtpResponseModelRegister {
  final bool success;
  final String message;
  final String? data;

  OtpResponseModelRegister({
    required this.success,
    required this.message,
    this.data,
  });

  /// Factory that handles both Map input and null/empty input
  factory OtpResponseModelRegister.fromJson(dynamic json) {
    // If json is null or empty string, return a default instance
    if (json == null || (json is String && json.isEmpty)) {
      return OtpResponseModelRegister(
        success: true,
        message: 'Verified',
        data: null,
      );
    }

    // If json is a Map, parse it normally
    if (json is Map<String, dynamic>) {
      return OtpResponseModelRegister(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data']?.toString(),
      );
    }

    // Fallback for other types
    return OtpResponseModelRegister(
      success: true,
      message: 'Verified',
      data: json?.toString(),
    );
  }
}
