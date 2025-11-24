class UpdateRecruiterResponseModel {
  final String id;
  final String userId;
  final String? bio;
  final String? banner;
  final String? photo;
  final String? title;
  final String? firstName;
  final String? sureName;
  final String? country;
  final String? city;
  final String? zipCode;
  final String? emailAddress;
  final String? phoneNumber;
  final List<SocialLink>? sLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UpdateRecruiterResponseModel({
    required this.id,
    required this.userId,
    this.bio,
    this.banner,
    this.photo,
    this.title,
    this.firstName,
    this.sureName,
    this.country,
    this.city,
    this.zipCode,
    this.emailAddress,
    this.phoneNumber,
    this.sLink,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateRecruiterResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateRecruiterResponseModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      bio: json['bio'],
      banner: json['banner'],
      photo: json['photo'],
      title: json['title'],
      firstName: json['firstName'],
      sureName: json['sureName'],
      country: json['country'],
      city: json['city'],
      zipCode: json['zipCode'],
      emailAddress: json['emailAddress'],
      phoneNumber: json['phoneNumber'],
      sLink: json['sLink'] != null
          ? (json['sLink'] as List)
          .map((e) => SocialLink.fromJson(e))
          .toList()
          : [],
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
      json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
      'sLink': sLink?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class SocialLink {
  final String? label;
  final String? url;
  final String? id;

  SocialLink({this.label, this.url, this.id});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json['label'],
      url: json['url'],
      id: json['_id'],
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
