class ContactUsRequestModel {
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final String subject;
  final String message;

  ContactUsRequestModel({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.subject,
    required this.message,
  });

  // Convert Dart object → JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phoneNumber': phoneNumber,
      'subject': subject,
      'message': message,
    };
  }
}
