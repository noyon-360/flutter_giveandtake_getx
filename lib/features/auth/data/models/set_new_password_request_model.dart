class SetNewPasswordRequestModel {
  final String oldPassword;
  final String newPassword;

  SetNewPasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'oldPassword': oldPassword, 'newPassword': newPassword};
  }
}
