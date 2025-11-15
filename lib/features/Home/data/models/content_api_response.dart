// Wrapper model to handle the different response format from content API
class ContentApiResponse {
  final String status;
  final String message;
  final Map<String, dynamic>? data;

  ContentApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ContentApiResponse.fromJson(Map<String, dynamic> json) {
    return ContentApiResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  // Convert to the expected BaseResponse format
  Map<String, dynamic> toBaseResponseFormat() {
    return {
      'success': status == 'success',
      'message': message,
      'data': data,
    };
  }
}