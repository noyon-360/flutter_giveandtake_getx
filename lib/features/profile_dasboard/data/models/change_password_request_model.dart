class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequestModel({required this.currentPassword, required this.newPassword});

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };
}
