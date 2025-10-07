class ResetPasswordWithTokenRequestModel {
  final String newPassword;

  ResetPasswordWithTokenRequestModel({required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'newPassword': newPassword};
  }
}
