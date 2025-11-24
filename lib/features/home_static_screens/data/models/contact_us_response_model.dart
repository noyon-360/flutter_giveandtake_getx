class ContactUsResponseModel {
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final String subject;
  final String message;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  ContactUsResponseModel({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.subject,
    required this.message,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ContactUsResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactUsResponseModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
