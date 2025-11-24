class CompanyModel {
  final String id;
  final String userId;
  final String? clogo;
  final String? banner;
  final String? aboutUs;
  final String cname;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final List<SocialLinkModel> sLink;
  final String industry;
  final List<String> service;
  final List<String> employeesId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyModel({
    required this.id,
    required this.userId,
    this.clogo,
    this.banner,
    this.aboutUs,
    required this.cname,
    required this.country,
    required this.city,
    required this.zipcode,
    required this.cemail,
    required this.sLink,
    required this.industry,
    required this.service,
    required this.employeesId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      clogo: json['clogo'],
      banner: json['banner'],
      aboutUs: json['aboutUs'],
      cname: json['cname'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      cemail: json['cemail'] ?? '',
      sLink:
          (json['sLink'] as List<dynamic>?)
              ?.map((e) => SocialLinkModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      industry: json['industry'] ?? '',
      service:
          (json['service'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      employeesId:
          (json['employeesId'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'clogo': clogo,
      'banner': banner,
      'aboutUs': aboutUs,
      'cname': cname,
      'country': country,
      'city': city,
      'zipcode': zipcode,
      'cemail': cemail,
      'sLink': sLink.map((e) => e.toJson()).toList(),
      'industry': industry,
      'service': service,
      'employeesId': employeesId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SocialLinkModel {
  final String label;
  final String url;
  final String id;

  SocialLinkModel({required this.label, required this.url, required this.id});

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      label: json['label'] ?? '',
      url: json['url'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'url': url, '_id': id};
  }
}
