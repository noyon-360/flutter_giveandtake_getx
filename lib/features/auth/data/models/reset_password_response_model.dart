class ResetPasswordResponseModel {
  final bool success;
  final String message;

  ResetPasswordResponseModel({required this.success, required this.message});

  factory ResetPasswordResponseModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return ResetPasswordResponseModel(success: true, message: 'Success');
    }
    return ResetPasswordResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
