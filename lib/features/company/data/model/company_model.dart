class CompanyModel {
  final String about;
  final String website;
  final String industry;
  final String companySize;
  final String specialties;
  final String location;
  final List<EmployeeModel> employees;

  CompanyModel({
    required this.about,
    required this.website,
    required this.industry,
    required this.companySize,
    required this.specialties,
    required this.location,
    required this.employees,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      about: json["about"] ?? "Not provided",
      website: json["website"] ?? "Not provided",
      industry: json["industry"] ?? "Not provided",
      companySize: json["companySize"] ?? "Not provided",
      specialties: json["specialties"] ?? "Not provided",
      location: json["location"] ?? "Not provided",
      employees: (json["employees"] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
    );
  }
}

class EmployeeModel {
  final String name;
  final String role;
  final String phone;

  EmployeeModel({
    required this.name,
    required this.role,
    required this.phone,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}
