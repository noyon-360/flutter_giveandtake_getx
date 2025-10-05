class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String phoneNum;
  final String address;
  final String role;
  final String? dateOfbirth;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNum,
    required this.address,
    this.role = 'candidate',
    this.dateOfbirth,
  });

  /// Convert Dart object → JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNum': phoneNum,
      'address': address,
      'role': role,
      'dateOfbirth': dateOfbirth ?? '',
    };
  }
}
