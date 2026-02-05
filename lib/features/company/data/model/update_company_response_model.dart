


import 'dart:convert';

class CompanyUpdateResponse {
  final UpdateCompanyResponseModel? updated;
  final List<AwardResult>? results;

  CompanyUpdateResponse({
    this.updated,
    this.results,
  });

  factory CompanyUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CompanyUpdateResponse(
      updated: json["updated"] != null
          ? UpdateCompanyResponseModel.fromJson(json["updated"])
          : null,
      results: json["results"] != null
          ? List<AwardResult>.from(
              json["results"].map((x) => AwardResult.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "updated": updated?.toJson(),
        "results": results != null
            ? List<dynamic>.from(results!.map((x) => x.toJson()))
            : [],
      };
}

/// ----------------------- UPDATED COMPANY -----------------------

class UpdateCompanyResponseModel {
  final String? id;
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
  final List<dynamic>? service;
  final List<String>? employeesId;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  UpdateCompanyResponseModel({
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

  factory UpdateCompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateCompanyResponseModel(
      id: json["_id"],
      userId: json["userId"],
      clogo: json["clogo"],
      banner: json["banner"],
      aboutUs: json["aboutUs"],
      slug: json["slug"],
      cname: json["cname"],
      country: json["country"],
      city: json["city"],
      zipcode: json["zipcode"],
      cemail: json["cemail"],
      industry: json["industry"],
      service: json["service"] ?? [],
      employeesId: json["employeesId"] != null
          ? List<String>.from(json["employeesId"])
          : [],
      sLink: json["sLink"] != null
          ? List<SocialLink>.from(
              json["sLink"].map((x) => SocialLink.fromJson(x)))
          : [],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "clogo": clogo,
        "banner": banner,
        "aboutUs": aboutUs,
        "slug": slug,
        "cname": cname,
        "country": country,
        "city": city,
        "zipcode": zipcode,
        "cemail": cemail,
        "industry": industry,
        "service": service,
        "employeesId":
            employeesId != null ? List<dynamic>.from(employeesId!) : [],
        "sLink":
            sLink != null ? List<dynamic>.from(sLink!.map((x) => x.toJson())) : [],
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

/// ----------------------- SOCIAL LINK -----------------------

class SocialLink {
  final String? label;
  final String? url;
  final String? id;

  SocialLink({
    this.label,
    this.url,
    this.id,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        label: json["label"],
        url: json["url"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "url": url,
        "_id": id,
      };
}

/// ----------------------- RESULT (Award & Honors) -----------------------

class AwardResult {
  final String? id;
  final String? userId;
  final String? title;
  final String? programeName;
  final String? programeDate;
  final String? description;
  final int? v;
  final String? createdAt;
  final String? updatedAt;
  final String? issuer;

  AwardResult({
    this.id,
    this.userId,
    this.title,
    this.programeName,
    this.programeDate,
    this.description,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.issuer,
  });

  factory AwardResult.fromJson(Map<String, dynamic> json) {
    return AwardResult(
      id: json["_id"],
      userId: json["userId"],
      title: json["title"],
      programeName: json["programeName"],
      programeDate: json["programeDate"],
      description: json["description"],
      v: json["__v"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      issuer: json["issuer"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "title": title,
        "programeName": programeName,
        "programeDate": programeDate,
        "description": description,
        "__v": v,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "issuer": issuer,
      };
}
