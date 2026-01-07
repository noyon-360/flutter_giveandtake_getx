class LeaveCompanyRequestModel {
  final String cname;
  final String aboutUs;
  final String industry;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final String clogo;
  final String banner;
  final String slug;
  final List<String> employeesId;
  final List<SocialLinkRequest> sLink;
  final List<String> service;

  LeaveCompanyRequestModel({
    required this.cname,
    required this.aboutUs,
    required this.industry,
    required this.country,
    required this.city,
    required this.zipcode,
    required this.cemail,
    required this.clogo,
    required this.banner,
    required this.slug,
    required this.employeesId,
    required this.sLink,
    required this.service,
  });

  Map<String, dynamic> toJson() {
    return {
      "cname": cname,
      "aboutUs": aboutUs,
      "industry": industry,
      "country": country,
      "city": city,
      "zipcode": zipcode,
      "cemail": cemail,
      "clogo": clogo,
      "banner": banner,
      "slug": slug,
      "employeesId": employeesId,
      "sLink": sLink.map((e) => e.toJson()).toList(),
      "service": service,
    };
  }
}
class SocialLinkRequest {
  final String label;
  final String url;

  SocialLinkRequest({
    required this.label,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      "label": label,
      "url": url,
    };
  }
}
