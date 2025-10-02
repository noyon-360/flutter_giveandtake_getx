class RegisterResponseModel {
  final String profileImage; // 🔹 now required & non-nullable
  final String role;
  final bool isVerified;
  final String? otp;
  final String? otpExpiry;
  final String? refreshToken;
  final String id;
  final String createdAt;
  final String? updatedAt;
  final int v;

  RegisterResponseModel({
    required this.profileImage,
    required this.role,
    required this.isVerified,
    this.otp,
    this.otpExpiry,
    this.refreshToken,
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.v,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      profileImage: json['profileImage'] ?? "", // fallback to empty string if null
      role: json['role'] ?? "",
      isVerified: json['isVerified'] ?? false,
      otp: json['otp'],
      otpExpiry: json['otpExpiry'],
      refreshToken: json['refreshToken'],
      id: json['_id'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'],
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileImage': profileImage,
      'role': role,
      'isVerified': isVerified,
      'otp': otp,
      'otpExpiry': otpExpiry,
      'refreshToken': refreshToken,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
