class SecurityQuestionsRequestModel {
  final String email;
  final List<SecurityQuestionAnswer> securityQuestions;

  SecurityQuestionsRequestModel({
    required this.email,
    required this.securityQuestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'securityQuestions': securityQuestions.map((q) => q.toJson()).toList(),
    };
  }
}

class SecurityQuestionAnswer {
  final String question;
  final String answer;

  SecurityQuestionAnswer({required this.question, required this.answer});

  Map<String, dynamic> toJson() {
    return {'question': question, 'answer': answer};
  }
}
