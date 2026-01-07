class LeaveCompanyResponseModel {
  final String id;
  final String userId;
  final String clogo;
  final String banner;
  final String aboutUs;
  final String slug;
  final String cname;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final List<SocialLink> sLink;
  final String industry;
  final List<dynamic> service;
  final List<String> employeesId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  LeaveCompanyResponseModel({
    required this.id,
    required this.userId,
    required this.clogo,
    required this.banner,
    required this.aboutUs,
    required this.slug,
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
    required this.v,
  });

  factory LeaveCompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return LeaveCompanyResponseModel(
      id: json['_id'],
      userId: json['userId'],
      clogo: json['clogo'],
      banner: json['banner'],
      aboutUs: json['aboutUs'],
      slug: json['slug'],
      cname: json['cname'],
      country: json['country'],
      city: json['city'],
      zipcode: json['zipcode'],
      cemail: json['cemail'],
      sLink: (json['sLink'] as List)
          .map((e) => SocialLink.fromJson(e))
          .toList(),
      industry: json['industry'],
      service: List<dynamic>.from(json['service']),
      employeesId: List<String>.from(json['employeesId']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'clogo': clogo,
      'banner': banner,
      'aboutUs': aboutUs,
      'slug': slug,
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
      '__v': v,
    };
  }
}

class SocialLink {
  final String id;
  final String label;
  final String url;

  SocialLink({
    required this.id,
    required this.label,
    required this.url,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['_id'],
      label: json['label'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': label,
      'url': url,
    };
  }
}
