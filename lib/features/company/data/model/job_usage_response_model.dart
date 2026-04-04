class JobUsageResponseModel {
  final bool paywallEnabled;
  final bool allowed;
  final String role;
  final Usage usage;

  JobUsageResponseModel({
    required this.paywallEnabled,
    required this.allowed,
    required this.role,
    required this.usage,
  });

  factory JobUsageResponseModel.fromJson(Map<String, dynamic> json) {
    return JobUsageResponseModel(
      paywallEnabled: json['paywallEnabled'] ?? false,
      allowed: json['allowed'] ?? false,
      role: json['role'] ?? '',
      usage: Usage.fromJson(json['usage'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paywallEnabled': paywallEnabled,
      'allowed': allowed,
      'role': role,
      'usage': usage.toJson(),
    };
  }
}

class Usage {
  final int monthlyUsed;
  final int annualUsed;

  Usage({
    required this.monthlyUsed,
    required this.annualUsed,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      monthlyUsed: json['monthlyUsed'] ?? 0,
      annualUsed: json['annualUsed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthlyUsed': monthlyUsed,
      'annualUsed': annualUsed,
    };
  }
}
