// company_response_model.dart
// Generated response model for the provided JSON.

import 'dart:convert';

class RemoveRecruiterResponseModel {
  final String id;
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
  final List<SLink> sLink;
  final String? industry;
  final List<dynamic> service;
  final List<dynamic> employeesId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  RemoveRecruiterResponseModel({
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
    List<SLink>? sLink,
    this.industry,
    List<dynamic>? service,
    List<dynamic>? employeesId,
    this.createdAt,
    this.updatedAt,
    this.v,
  }) : sLink = sLink ?? [],
       service = service ?? [],
       employeesId = employeesId ?? [];

  RemoveRecruiterResponseModel copyWith({
    String? id,
    String? userId,
    String? clogo,
    String? banner,
    String? aboutUs,
    String? slug,
    String? cname,
    String? country,
    String? city,
    String? zipcode,
    String? cemail,
    List<SLink>? sLink,
    String? industry,
    List<dynamic>? service,
    List<dynamic>? employeesId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return RemoveRecruiterResponseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clogo: clogo ?? this.clogo,
      banner: banner ?? this.banner,
      aboutUs: aboutUs ?? this.aboutUs,
      slug: slug ?? this.slug,
      cname: cname ?? this.cname,
      country: country ?? this.country,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
      cemail: cemail ?? this.cemail,
      sLink: sLink ?? this.sLink,
      industry: industry ?? this.industry,
      service: service ?? this.service,
      employeesId: employeesId ?? this.employeesId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory RemoveRecruiterResponseModel.fromJson(Map<String, dynamic> json) {
    return RemoveRecruiterResponseModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
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
          ?.map((e) => SLink.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      industry: json['industry'] as String?,
      service: json['service'] as List<dynamic>?,
      employeesId: json['employeesId'] as List<dynamic>?,
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int?,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

class SLink {
  final String? label;
  final String? url;
  final String? id;

  SLink({this.label, this.url, this.id});

  SLink copyWith({String? label, String? url, String? id}) {
    return SLink(
      label: label ?? this.label,
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }

  factory SLink.fromJson(Map<String, dynamic> json) {
    return SLink(
      label: json['label'] as String?,
      url: json['url'] as String?,
      id: json['_id'] as String?,
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

// Example usage:
// final model = CompanyResponseModel.fromJson(jsonMap);
// final json = model.toJson();
