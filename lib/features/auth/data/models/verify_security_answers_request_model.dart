class VerifySecurityAnswersRequestModel {
  final String email;
  final List<String> answers;

  VerifySecurityAnswersRequestModel({
    required this.email,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'answers': answers};
  }
}
