class UserPlan {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> features;
  final String forRole;
  final String valid;

  UserPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.features,
    required this.forRole,
    required this.valid,
  });

  factory UserPlan.fromJson(Map<String, dynamic> json) {
    return UserPlan(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      forRole: json['for'] as String? ?? '',
      valid: json['valid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'features': features,
      'for': forRole,
      'valid': valid,
    };
  }
}

class UserModel {
  final String? otp;
  final String? otpExpiry;
  final String id;
  final String name;
  final String email;
  final String password;
  final String? profileImage;
  final String role;
  final String phoneNumber;
  final bool isVerified;
  final String? resetOtp;
  final String? resetOtpExpiry;
  final String refreshToken;
  final String createdAt;
  final String updatedAt;
  final int v;
  final UserPlan? plan;

  UserModel({
    this.otp,
    this.otpExpiry,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
    required this.role,
    required this.phoneNumber,
    required this.isVerified,
    this.resetOtp,
    this.resetOtpExpiry,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.plan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      otp: json['otp'] as String?,
      otpExpiry: json['otpExpiry'] as String?,
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      resetOtp: json['reset_otp'] as String?,
      resetOtpExpiry: json['reset_otpExpiry'] as String?,
      refreshToken: json['refreshToken'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      v: json['__v'] as int? ?? 0,
      plan: json['plan'] != null
          ? UserPlan.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'otpExpiry': otpExpiry,
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'role': role,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'reset_otp': resetOtp,
      'reset_otpExpiry': resetOtpExpiry,
      'refreshToken': refreshToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'plan': plan?.toJson(),
    };
  }
}
