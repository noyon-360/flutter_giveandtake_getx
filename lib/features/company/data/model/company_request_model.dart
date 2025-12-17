// import 'dart:convert';

// class CompanyRequestModel {
//   final String? cname;
//   final String? country;
//   final String? city;
//   final String? zipcode;
//   final String? cemail;
//   final String? aboutUs;
//   final String? industry;

//   /// array of social links: label + url
//   final List<SocialLink>? sLink;

//   /// services list
//   final List<String>? service;

//   /// employeesId list
//   final List<String>? employeesId;

//   /// awards list
//   final List<String>? awardsAndHonors;

//   /// binary files for banner + logo
//   final List<int>? banner;
//   final List<int>? clogo;

//   CompanyRequestModel({
//     this.banner,
//     this.clogo,
//     this.cname,
//     this.country,
//     this.city,
//     this.zipcode,
//     this.cemail,
//     this.aboutUs,
//     this.industry,
//     this.sLink,
//     this.service,
//     this.employeesId,
//     this.awardsAndHonors,
//   });

//   Map<String, dynamic> toJson() => {
//         "banner": banner,
//         "clogo": clogo,
//         "cname": cname,
//         "country": country,
//         "city": city,
//         "zipcode": zipcode,
//         "cemail": cemail,
//         "aboutUs": aboutUs,
//         "industry": industry,
//         "sLink": sLink?.map((e) => e.toJson()).toList(),
//         "service": service,
//         "employeesId": employeesId,
//         "AwardsAndHonors": awardsAndHonors,
//       };

//   String toRawJson() => json.encode(toJson());
// }

// class SocialLink {
//   final String label;
//   final String url;

//   SocialLink({required this.label, required this.url});

//   Map<String, dynamic> toJson() => {
//         "label": label,
//         "url": url,
//       };
// }
import 'dart:convert';
import 'dart:io';

class CompanyRequestModel {
  File? banner; // binary file
  File? clogo;  // binary file
  String cname;
  String country;
  String city;
  String zipcode;
  String cemail;
  String aboutUs;
  String industry;
  List<SocialLink> sLink;
  List<String> service;
  List<String> employeesId;
  List<AwardHonor> awardsAndHonors;

  CompanyRequestModel({
    this.banner,
    this.clogo,
    required this.cname,
    required this.country,
    required this.city,
    required this.zipcode,
    required this.cemail,
    required this.aboutUs,
    required this.industry,
    required this.sLink,
    required this.service,
    required this.employeesId,
    required this.awardsAndHonors,
  });

  Map<String, dynamic> toJson() => {
        // Banner and clogo usually sent as multipart, not JSON
        'cname': cname,
        'country': country,
        'city': city,
        'zipcode': zipcode,
        'cemail': cemail,
        'aboutUs': aboutUs,
        'industry': industry,
        'sLink': sLink.map((x) => x.toJson()).toList(),
        'service': service,
        'employeesId': employeesId,
        'AwardsAndHonors': awardsAndHonors.map((x) => x.toJson()).toList(),
      };
}

class SocialLink {
  String label;
  String url;

  SocialLink({required this.label, required this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        label: json['label'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
      };
}

class AwardHonor {
  String title;
  String programeName;
  DateTime programeDate;
  String description;

  AwardHonor({
    required this.title,
    required this.programeName,
    required this.programeDate,
    required this.description,
  });

  factory AwardHonor.fromJson(Map<String, dynamic> json) => AwardHonor(
        title: json['title'],
        programeName: json['programeName'],
        programeDate: DateTime.parse(json['programeDate']),
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'programeName': programeName,
        'programeDate': programeDate.toIso8601String(),
        'description': description,
      };
}
