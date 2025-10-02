class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,

  });

  /// Convert Dart object → JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}
