class GetCompanyResponseModel {
  final String id;
  final String cname;
  final String clogo;
  final String cemail;
  final String industry;

  GetCompanyResponseModel({
    required this.id,
    required this.cname,
    required this.clogo,
    required this.cemail,
    required this.industry,
  });

  // Factory constructor to create a Company from JSON
  factory GetCompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCompanyResponseModel(
      id: json['id'] ?? '',
      cname: json['cname'] ?? '',
      clogo: json['clogo'] ?? '',
      cemail: json['cemail'] ?? '',
      industry: json['industry'] ?? '',
    );
  }

  // Convert Company to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cname': cname,
      'clogo': clogo,
      'cemail': cemail,
      'industry': industry,
    };
  }
}

/// If your API returns a list of companies:
List<GetCompanyResponseModel> companyListFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => GetCompanyResponseModel.fromJson(json)).toList();
}
