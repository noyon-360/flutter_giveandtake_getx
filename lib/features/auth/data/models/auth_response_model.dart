import 'user_model.dart';

class AuthResponseData {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponseData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseData.fromJson(Map<String, dynamic> json) {
    // API returns user data directly in the data object, not nested under 'user'
    return AuthResponseData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(
        json,
      ), // Pass the whole json as it contains user fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}
