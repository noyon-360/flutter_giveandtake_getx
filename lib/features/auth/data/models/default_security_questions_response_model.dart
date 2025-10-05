class DefaultSecurityQuestionsResponseModel {
  final bool success;
  final String message;
  final List<String>
  date; // API uses "date" instead of "data" (typo in backend)

  DefaultSecurityQuestionsResponseModel({
    required this.success,
    required this.message,
    required this.date,
  });

  factory DefaultSecurityQuestionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DefaultSecurityQuestionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      date:
          (json['date'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}
