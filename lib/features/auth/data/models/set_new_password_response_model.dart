class SetNewPasswordResponseModel {
  final bool success;
  final String message;

  SetNewPasswordResponseModel({required this.success, required this.message});

  factory SetNewPasswordResponseModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return SetNewPasswordResponseModel(success: true, message: 'Success');
    }
    return SetNewPasswordResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
