class JobUpdateResponseModel {
  final String id;
  final String userId;
  final String recruiterId;
  final String title;
  final String description;
  final String salaryRange;
  final String location;
  final int vacancy;
  final String experience;
  final String role;
  final String compensation;
  final String website_Url;
  final String employmentType;
  final String careerStage;
  final DateTime? deadline;
  final List<ApplicationRequirement> applicationRequirement;
  final List<CustomQuestion> customQuestion;

  JobUpdateResponseModel({
    required this.id,
    required this.userId,
    required this.recruiterId,
    required this.title,
    required this.description,
    required this.salaryRange,
    required this.location,
    required this.vacancy,
    required this.experience,
    required this.role,
    required this.compensation,
    required this.employmentType,
    required this.careerStage,
    required this.deadline,
    required this.applicationRequirement,
    required this.customQuestion, required this.website_Url,
  });

  factory JobUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return JobUpdateResponseModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      recruiterId: json['recruiterId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      salaryRange: json['salaryRange'] ?? '',
      location: json['location'] ?? '',
      vacancy: json['vacancy'] ?? 0,
      experience: json['experience'] ?? '',
      role: json['role'] ?? '',
      compensation: json['compensation'] ?? '',
      employmentType: json['employement_Type'] ?? '',
      careerStage: json['career_Stage'] ?? '',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      applicationRequirement: json['applicationRequirement'] != null
          ? (json['applicationRequirement'] as List)
          .map((e) => ApplicationRequirement.fromJson(e))
          .toList()
          : [],
      customQuestion: json['customQuestion'] != null
          ? (json['customQuestion'] as List)
          .map((e) => CustomQuestion.fromJson(e))
          .toList()
          : [], website_Url: json['website_Url'],
    );
  }
}

class ApplicationRequirement {
  final String requirement;
  final String status;
  final String id;

  ApplicationRequirement({
    required this.requirement,
    required this.status,
    required this.id,
  });

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirement(
      requirement: json['requirement'] ?? '',
      status: json['status'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class CustomQuestion {
  final String question;
  final String id;

  CustomQuestion({
    required this.question,
    required this.id,
  });

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      question: json['question'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
