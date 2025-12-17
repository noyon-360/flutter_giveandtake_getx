// // company_response_model.dart
// import 'dart:convert';

// class RecruiterAddedResponseModel {
//   final String id; // maps from "_id"
//   final String userId;
//   final String? clogo;
//   final String? banner;
//   final String? aboutUs;
//   final String? slug;
//   final String? cname;
//   final String? country;
//   final String? city;
//   final String? zipcode;
//   final String? cemail;
//   final List<SocialLink> sLink;
//   final String? industry;
//   final List<String> service;
//   final List<String> employeesId;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final int? v;

//   RecruiterAddedResponseModel({
//     required this.id,
//     required this.userId,
//     this.clogo,
//     this.banner,
//     this.aboutUs,
//     this.slug,
//     this.cname,
//     this.country,
//     this.city,
//     this.zipcode,
//     this.cemail,
//     required this.sLink,
//     this.industry,
//     required this.service,
//     required this.employeesId,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory RecruiterAddedResponseModel.fromJson(Map<String, dynamic> json) {
//     return RecruiterAddedResponseModel(
//       id: json['_id'] as String,
//       userId: json['userId'] as String,
//       clogo: json['clogo'] as String?,
//       banner: json['banner'] as String?,
//       aboutUs: json['aboutUs'] as String?,
//       slug: json['slug'] as String?,
//       cname: json['cname'] as String?,
//       country: json['country'] as String?,
//       city: json['city'] as String?,
//       zipcode: json['zipcode'] as String?,
//       cemail: json['cemail'] as String?,
//       sLink: (json['sLink'] as List<dynamic>?)
//               ?.map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
//               .toList() ??
//           [],
//       industry: json['industry'] as String?,
//       // service might be an array of strings or objects; assuming strings as shown (empty array).
//       service: (json['service'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       employeesId: (json['employeesId'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
//       v: json['__v'] is int ? json['__v'] as int : (json['__v'] != null ? int.tryParse(json['__v'].toString()) : null),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       'clogo': clogo,
//       'banner': banner,
//       'aboutUs': aboutUs,
//       'slug': slug,
//       'cname': cname,
//       'country': country,
//       'city': city,
//       'zipcode': zipcode,
//       'cemail': cemail,
//       'sLink': sLink.map((e) => e.toJson()).toList(),
//       'industry': industry,
//       'service': service,
//       'employeesId': employeesId,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       '__v': v,
//     };
//   }

//   /// Convenience: decode from JSON string
//   static RecruiterAddedResponseModel fromRawJson(String str) =>
//       RecruiterAddedResponseModel.fromJson(json.decode(str) as Map<String, dynamic>);

//   /// Convenience: encode to JSON string
//   String toRawJson() => json.encode(toJson());
// }

// class SocialLink {
//   final String label;
//   final String url;
//   final String id; // maps from "_id"

//   SocialLink({
//     required this.label,
//     required this.url,
//     required this.id,
//   });

//   factory SocialLink.fromJson(Map<String, dynamic> json) {
//     return SocialLink(
//       label: json['label'] as String? ?? '',
//       url: json['url'] as String? ?? '',
//       id: json['_id'] as String? ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'label': label,
//       'url': url,
//       '_id': id,
//     };
//   }
// }

// // network_response.dart
// class ApiResponse<T> {
//   final bool success;
//   final String? message;
//   final T? data;

//   ApiResponse({required this.success, this.message, this.data});

//   factory ApiResponse.fromJson(
//   Map<String, dynamic> json,
//   T Function(Object? json) fromJsonT,
// ) {
//   return ApiResponse(
//     success: json['success'] as bool? ?? false,
//     message: json['message'] as String?,
//     data: (json['data'] == null) ? null : fromJsonT(json['data']),
//   );
// }

// }
import 'dart:convert';

class RecruiterAddedResponseModel {
  final String id;                    // _id
  final String userId;
  final String? clogo;
  final String? banner;
  final String? aboutUs;
  final String? slug;
  final String? cname;
  final String? country;
  final String? city;
  final String? zipcode;
  final String? cemail;
  final List<SocialLink> sLink;
  final String? industry;
  final List<String> service;
  final List<String> employeesId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  RecruiterAddedResponseModel({
    required this.id,
    required this.userId,
    this.clogo,
    this.banner,
    this.aboutUs,
    this.slug,
    this.cname,
    this.country,
    this.city,
    this.zipcode,
    this.cemail,
    required this.sLink,
    this.industry,
    required this.service,
    required this.employeesId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// THIS IS THE KEY FIX → Accept dynamic and safely handle null
  factory RecruiterAddedResponseModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      // You can either throw or return a dummy – but better to fail fast in dev
      throw FormatException('Expected Map<String, dynamic>, got $json');
    }

    return RecruiterAddedResponseModel(
      id: json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      clogo: json['clogo'] as String?,
      banner: json['banner'] as String?,
      aboutUs: json['aboutUs'] as String?,
      slug: json['slug'] as String?,
      cname: json['cname'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      zipcode: json['zipcode'] as String?,
      cemail: json['cemail'] as String?,
      sLink: (json['sLink'] as List<dynamic>?)
              ?.map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      industry: json['industry'] as String?,
      service: (json['service'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      employeesId: (json['employeesId'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: json['__v'] is int
          ? json['__v'] as int
          : (json['__v'] != null ? int.tryParse(json['__v'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() => {
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
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  static RecruiterAddedResponseModel fromRawJson(String str) =>
      RecruiterAddedResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
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
      label: json['label'] as String? ?? '',
      url: json['url'] as String? ?? '',
      id: json['_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
        '_id': id,
      };
}