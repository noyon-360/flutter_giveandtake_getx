// import 'dart:convert';

// CompanyResponseModel companyResponseModelFromJson(String str) =>
//     CompanyResponseModel.fromJson(json.decode(str));

// class CompanyResponseModel {
//   final Company? company;
//   final List<dynamic>? honors;

//   CompanyResponseModel({this.company, this.honors});

//   factory CompanyResponseModel.fromJson(Map<String, dynamic> json) =>
//       CompanyResponseModel(
//         company:
//             json["company"] != null ? Company.fromJson(json["company"]) : null,
//         honors: json["honors"] ?? [],
//       );
// }

// class Company {
//   final String? userId;
//   final String? clogo;
//   final String? banner;
//   final String? aboutUs;
//   final String? slug;
//   final String? cname;
//   final String? country;
//   final String? city;
//   final String? zipcode;
//   final String? cemail;
//   final List<SLink>? sLink;
//   final String? industry;
//   final List<String>? service;
//   final List<String>? employeesId;
//   final String? id;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final int? v;

//   Company({
//     this.userId,
//     this.clogo,
//     this.banner,
//     this.aboutUs,
//     this.slug,
//     this.cname,
//     this.country,
//     this.city,
//     this.zipcode,
//     this.cemail,
//     this.sLink,
//     this.industry,
//     this.service,
//     this.employeesId,
//     this.id,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) => Company(
//         userId: json["userId"],
//         clogo: json["clogo"],
//         banner: json["banner"],
//         aboutUs: json["aboutUs"],
//         slug: json["slug"],
//         cname: json["cname"],
//         country: json["country"],
//         city: json["city"],
//         zipcode: json["zipcode"],
//         cemail: json["cemail"],
//         sLink: json["sLink"] == null
//             ? []
//             : List<SLink>.from(json["sLink"].map((e) => SLink.fromJson(e))),
//         industry: json["industry"],
//         service: json["service"] == null
//             ? []
//             : List<String>.from(json["service"].map((x) => x)),
//         employeesId: json["employeesId"] == null
//             ? []
//             : List<String>.from(json["employeesId"].map((x) => x)),
//         id: json["_id"],
//         createdAt:
//             json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
//         updatedAt:
//             json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
//         v: json["__v"],
//       );
// }

// class SLink {
//   final String? label;
//   final String? url;
//   final String? id;

//   SLink({this.label, this.url, this.id});

//   factory SLink.fromJson(Map<String, dynamic> json) => SLink(
//         label: json["label"],
//         url: json["url"],
//         id: json["_id"],
//       );
// }

/////////////////////////updated no 2

// import 'dart:convert';

// CompanyResponseModel singleCompanyResponseModelFromJson(String str) =>
//     CompanyResponseModel.fromJson(json.decode(str));

// class CompanyResponseModel {
//   final Company? company;
//   final List<Honor>? honors;

//   CompanyResponseModel({
//     this.company,
//     this.honors,
//   });

//   factory CompanyResponseModel.fromJson(Map<String, dynamic> json) =>
//       CompanyResponseModel(
//         company: json["company"] != null
//             ? Company.fromJson(json["company"])
//             : null,
//         honors: json["honors"] != null
//             ? List<Honor>.from(json["honors"].map((x) => Honor.fromJson(x)))
//             : [],
//       );
// }

// class Company {
//   final String? userId;
//   final String? clogo;
//   final String? banner;
//   final String? aboutUs;
//   final String? slug;
//   final String? cname;
//   final String? country;
//   final String? city;
//   final String? zipcode;
//   final String? cemail;
//   final List<SocialLink>? sLink;
//   final String? industry;
//   final List<String>? service;
//   final List<String>? employeesId;
//   final String? id;
//   final String? createdAt;
//   final String? updatedAt;
//   final int? v;

//   Company({
//     this.userId,
//     this.clogo,
//     this.banner,
//     this.aboutUs,
//     this.slug,
//     this.cname,
//     this.country,
//     this.city,
//     this.zipcode,
//     this.cemail,
//     this.sLink,
//     this.industry,
//     this.service,
//     this.employeesId,
//     this.id,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) => Company(
//         userId: json["userId"],
//         clogo: json["clogo"],
//         banner: json["banner"],
//         aboutUs: json["aboutUs"],
//         slug: json["slug"],
//         cname: json["cname"],
//         country: json["country"],
//         city: json["city"],
//         zipcode: json["zipcode"],
//         cemail: json["cemail"],
//         sLink: json["sLink"] != null
//             ? List<SocialLink>.from(json["sLink"].map((x) => SocialLink.fromJson(x)))
//             : [],
//         industry: json["industry"],
//         service: json["service"] != null
//             ? List<String>.from(json["service"])
//             : [],
//         employeesId: json["employeesId"] != null
//             ? List<String>.from(json["employeesId"])
//             : [],
//         id: json["_id"],
//         createdAt: json["createdAt"],
//         updatedAt: json["updatedAt"],
//         v: json["__v"],
//       );
// }

// class SocialLink {
//   final String? label;
//   final String? url;
//   final String? id;

//   SocialLink({
//     this.label,
//     this.url,
//     this.id,
//   });

//   factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
//         label: json["label"],
//         url: json["url"],
//         id: json["_id"],
//       );
// }

// class Honor {
//   final String? userId;
//   final String? title;
//   final String? programeName;
//   final String? programeDate;
//   final String? description;
//   final String? id;
//   final int? v;
//   final String? createdAt;
//   final String? updatedAt;

//   Honor({
//     this.userId,
//     this.title,
//     this.programeName,
//     this.programeDate,
//     this.description,
//     this.id,
//     this.v,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory Honor.fromJson(Map<String, dynamic> json) => Honor(
//         userId: json["userId"],
//         title: json["title"],
//         programeName: json["programeName"],
//         programeDate: json["programeDate"],
//         description: json["description"],
//         id: json["_id"],
//         v: json["__v"],
//         createdAt: json["createdAt"],
//         updatedAt: json["updatedAt"],
//       );
// }


import 'dart:convert';

class CompanyResponseModel {
  final Company company;
  final List<Honor> honors;

  CompanyResponseModel({
    required this.company,
    required this.honors,
  });

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      company: Company.fromJson(json['company']),
      honors: json['honors'] != null
          ? List<Honor>.from(json['honors'].map((x) => Honor.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'company': company.toJson(),
        'honors': List<dynamic>.from(honors.map((x) => x.toJson())),
      };
}

class Company {
  final String userId;
  final String? clogo;
  final String? banner;
  final String aboutUs;
  final String slug;
  final String cname;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final List<SocialLink> sLink;
  final String industry;
  final List<String> service;
  final List<String> employeesId;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Company({
    required this.userId,
    this.clogo,
    this.banner,
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
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
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
      sLink: json['sLink'] != null
          ? List<SocialLink>.from(
              json['sLink'].map((x) => SocialLink.fromJson(x)))
          : [],
      industry: json['industry'],
      service: json['service'] != null
          ? List<String>.from(json['service'])
          : [],
      employeesId: json['employeesId'] != null
          ? List<String>.from(json['employeesId'])
          : [],
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
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
        'sLink': List<dynamic>.from(sLink.map((x) => x.toJson())),
        'industry': industry,
        'service': List<dynamic>.from(service),
        'employeesId': List<dynamic>.from(employeesId),
        '_id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}

class SocialLink {
  final String label;
  final String url;
  final String id;

  SocialLink({
    required this.label,
    required this.url,
    required this.id,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json['label'],
      url: json['url'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
        '_id': id,
      };
}

class Honor {
  final String userId;
  final String title;
  final String programeName;
  final DateTime programeDate;
  final String description;
  final String id;
  final int v;
  final DateTime createdAt;
  final DateTime updatedAt;

  Honor({
    required this.userId,
    required this.title,
    required this.programeName,
    required this.programeDate,
    required this.description,
    required this.id,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Honor.fromJson(Map<String, dynamic> json) {
    return Honor(
      userId: json['userId'],
      title: json['title'],
      programeName: json['programeName'],
      programeDate: DateTime.parse(json['programeDate']),
      description: json['description'],
      id: json['_id'],
      v: json['__v'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'programeName': programeName,
        'programeDate': programeDate.toIso8601String(),
        'description': description,
        '_id': id,
        '__v': v,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
