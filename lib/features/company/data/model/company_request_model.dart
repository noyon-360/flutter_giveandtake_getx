import 'dart:convert';

class CompanyRequestModel {
  final String? cname;
  final String? country;
  final String? city;
  final String? zipcode;
  final String? cemail;
  final String? aboutUs;
  final String? industry;

  /// array of social links: label + url
  final List<SocialLink>? sLink;

  /// services list
  final List<String>? service;

  /// employeesId list
  final List<String>? employeesId;

  /// awards list
  final List<String>? awardsAndHonors;

  /// binary files for banner + logo
  final List<int>? banner;
  final List<int>? clogo;

  CompanyRequestModel({
    this.banner,
    this.clogo,
    this.cname,
    this.country,
    this.city,
    this.zipcode,
    this.cemail,
    this.aboutUs,
    this.industry,
    this.sLink,
    this.service,
    this.employeesId,
    this.awardsAndHonors,
  });

  Map<String, dynamic> toJson() => {
        "banner": banner,
        "clogo": clogo,
        "cname": cname,
        "country": country,
        "city": city,
        "zipcode": zipcode,
        "cemail": cemail,
        "aboutUs": aboutUs,
        "industry": industry,
        "sLink": sLink?.map((e) => e.toJson()).toList(),
        "service": service,
        "employeesId": employeesId,
        "AwardsAndHonors": awardsAndHonors,
      };

  String toRawJson() => json.encode(toJson());
}

class SocialLink {
  final String label;
  final String url;

  SocialLink({required this.label, required this.url});

  Map<String, dynamic> toJson() => {
        "label": label,
        "url": url,
      };
}
