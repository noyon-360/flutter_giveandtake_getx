class CreateRecruiterResponseModel {
  final String userId;
  final String bio;
  final String banner;
  final String photo;
  final String title;
  final String firstName;
  final String sureName;
  final String country;
  final String city;
  final String zipCode;
  final String emailAddress;
  final String phoneNumber;
  final List<SocialLink> sLink;
  final String id;
  final String createdAt;
  final String updatedAt;

  CreateRecruiterResponseModel({
    required this.userId,
    required this.bio,
    required this.banner,
    required this.photo,
    required this.title,
    required this.firstName,
    required this.sureName,
    required this.country,
    required this.city,
    required this.zipCode,
    required this.emailAddress,
    required this.phoneNumber,
    required this.sLink,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateRecruiterResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateRecruiterResponseModel(
      userId: json['userId'] ?? '',
      bio: json['bio'] ?? '',
      banner: json['banner'] ?? '',
      photo: json['photo'] ?? '',
      title: json['title'] ?? '',
      firstName: json['firstName'] ?? '',
      sureName: json['sureName'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      sLink: (json['sLink'] as List<dynamic>?)
          ?.map((e) => SocialLink.fromJson(e))
          .toList() ??
          [],
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bio': bio,
      'banner': banner,
      'photo': photo,
      'title': title,
      'firstName': firstName,
      'sureName': sureName,
      'country': country,
      'city': city,
      'zipCode': zipCode,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'sLink': sLink.map((e) => e.toJson()).toList(),
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SocialLink {
  final String label;
  final String? url;
  final String id;

  SocialLink({
    required this.label,
    this.url,
    required this.id,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json['label'] ?? '',
      url: json['url'],
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'url': url,
      '_id': id,
    };
  }
}
