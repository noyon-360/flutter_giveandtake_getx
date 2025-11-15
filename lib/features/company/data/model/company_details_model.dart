class Employee {
  final String name;
  final String role;
  final String phone;

  Employee({required this.name, required this.role, required this.phone});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'role': role, 'phone': phone};
  }
}

class CompanyDetailsModel {
  final String logoUrl;
  final String recruiterName;
  final String recruiterRole;
  final String location;
  final String aboutUs;
  final String website;
  final String industry;
  final String companySize;
  final String specialties;
  final String address;
  final String elevatorPitchUrl;
  final List<Employee> employees;

  CompanyDetailsModel({
    required this.logoUrl,
    required this.recruiterName,
    required this.recruiterRole,
    required this.location,
    required this.aboutUs,
    required this.website,
    required this.industry,
    required this.companySize,
    required this.specialties,
    required this.address,
    required this.elevatorPitchUrl,
    required this.employees,
  });
}
