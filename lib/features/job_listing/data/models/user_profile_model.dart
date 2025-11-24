class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phoneNum;
  final String role;
  final String address;
  final String? avatarUrl;
  final String? title;
  final DateTime? dateOfBirth;
  final bool deactivate;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Social media links
  final String? linkedinUrl;
  final String? githubUrl;
  final String? websiteUrl;
  final String? instagramUrl;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.role,
    required this.address,
    this.avatarUrl,
    this.title,
    this.dateOfBirth,
    required this.deactivate,
    required this.createdAt,
    required this.updatedAt,
    this.linkedinUrl,
    this.githubUrl,
    this.websiteUrl,
    this.instagramUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNum: json['phoneNum'] ?? '',
      role: json['role'] ?? '',
      address: json['address'] ?? '',
      avatarUrl: json['avatar']?['url']?.isNotEmpty == true
          ? json['avatar']['url']
          : null,
      title: json['title'],
      dateOfBirth: json['dateOfbirth'] != null
          ? DateTime.tryParse(json['dateOfbirth'])
          : null,
      deactivate: json['deactivate'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      linkedinUrl: json['socialLinks']?['linkedin'],
      githubUrl: json['socialLinks']?['github'],
      websiteUrl: json['socialLinks']?['website'],
      instagramUrl: json['socialLinks']?['instagram'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phoneNum': phoneNum,
      'role': role,
      'address': address,
      'avatar': avatarUrl != null ? {'url': avatarUrl} : null,
      'title': title,
      'dateOfbirth': dateOfBirth?.toIso8601String(),
      'deactivate': deactivate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'socialLinks': {
        'linkedin': linkedinUrl,
        'github': githubUrl,
        'website': websiteUrl,
        'instagram': instagramUrl,
      },
    };
  }
}
