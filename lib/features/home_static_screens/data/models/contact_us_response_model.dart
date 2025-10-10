
class ContactUsResponseModel {
  final String user;
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final String subject;
  final String yourCompony;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  ContactUsResponseModel({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.subject,
    required this.yourCompony,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ContactUsResponseModel.fromJson(Map<String, dynamic> json) {
    return ContactUsResponseModel(
      user: json['user'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      subject: json['subject'] ?? '',
      yourCompony: json['yourCompony'] ?? '',
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
