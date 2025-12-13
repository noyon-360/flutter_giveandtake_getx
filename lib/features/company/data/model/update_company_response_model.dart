
import 'dart:convert';

class UpdateCompanyResponseModel {
  final Updated? updated;

  UpdateCompanyResponseModel({this.updated});

  factory UpdateCompanyResponseModel.fromJson(Map<String, dynamic> json) => UpdateCompanyResponseModel(
        updated: json['updated'] == null ? null : Updated.fromJson(json['updated'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        if (updated != null) 'updated': updated!.toJson(),
      };

  UpdateCompanyResponseModel copyWith({Updated? updated}) => UpdateCompanyResponseModel(updated: updated ?? this.updated);

  @override
  String toString() => 'CompanyResponse(updated: $updated)';
}

class Updated {
  final String? id; // maps from _id
  final String? userId;
  final String? clogo;
  final String? banner;
  final String? aboutUs;
  final String? slug;
  final String? cname;
  final String? country;
  final String? city;
  final String? zipcode;
  final String? cemail;
  final List<SocialLink>? sLink;
  final String? industry;
  final List<String>? service;
  final List<String>? employeesId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Updated({
    this.id,
    this.userId,
    this.clogo,
    this.banner,
    this.aboutUs,
    this.slug,
    this.cname,
    this.country,
    this.city,
    this.zipcode,
    this.cemail,
    this.sLink,
    this.industry,
    this.service,
    this.employeesId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Updated.fromJson(Map<String, dynamic> json) => Updated(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
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
            .toList(),
        industry: json['industry'] as String?,
        service: (json['service'] as List<dynamic>?)?.map((e) => e as String).toList(),
        employeesId: (json['employeesId'] as List<dynamic>?)?.map((e) => e as String).toList(),
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] is int ? json['__v'] as int : (json['__v'] != null ? int.tryParse('${json['__v']}') : null),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) '_id': id,
        if (userId != null) 'userId': userId,
        if (clogo != null) 'clogo': clogo,
        if (banner != null) 'banner': banner,
        if (aboutUs != null) 'aboutUs': aboutUs,
        if (slug != null) 'slug': slug,
        if (cname != null) 'cname': cname,
        if (country != null) 'country': country,
        if (city != null) 'city': city,
        if (zipcode != null) 'zipcode': zipcode,
        if (cemail != null) 'cemail': cemail,
        if (sLink != null) 'sLink': sLink!.map((e) => e.toJson()).toList(),
        if (industry != null) 'industry': industry,
        if (service != null) 'service': service,
        if (employeesId != null) 'employeesId': employeesId,
        if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
        if (v != null) '__v': v,
      };

  Updated copyWith({
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
    List<SocialLink>? sLink,
    String? industry,
    List<String>? service,
    List<String>? employeesId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      Updated(
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

  @override
  String toString() => 'Updated(id: $id, cname: $cname, country: $country, city: $city)';
}

class SocialLink {
  final String? label;
  final String? url;
  final String? id; // maps from _id

  SocialLink({this.label, this.url, this.id});

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        label: json['label'] as String?,
        url: json['url'] as String?,
        id: json['_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (label != null) 'label': label,
        if (url != null) 'url': url,
        if (id != null) '_id': id,
      };

  SocialLink copyWith({String? label, String? url, String? id}) => SocialLink(
        label: label ?? this.label,
        url: url ?? this.url,
        id: id ?? this.id,
      );

  @override
  String toString() => 'SocialLink(label: $label, url: $url)';
}
