class JobPostResponseModel {
  final String userId;
  final String title;
  final String description;
  final String salaryRange;
  final String location;
  final String shift;
  final List<String> responsibilities;
  final List<String> educationExperience;
  final List<String> benefits;
  final int vacancy;
  final String experience;
  final String deadline;
  final String status;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final bool archivedJob;
  final List<ApplicationRequirementResponse> applicationRequirement;
  final List<CustomQuestionResponse> customQuestion;
  final String employementType;
  final String websiteUrl;
  final String publishDate;
  final String careerStage;
  final String locationType;

  JobPostResponseModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.salaryRange,
    required this.location,
    required this.shift,
    required this.responsibilities,
    required this.educationExperience,
    required this.benefits,
    required this.vacancy,
    required this.experience,
    required this.deadline,
    required this.status,
    required this.jobCategoryId,
    required this.name,
    required this.role,
    required this.compensation,
    required this.archivedJob,
    required this.applicationRequirement,
    required this.customQuestion,
    required this.employementType,
    required this.websiteUrl,
    required this.publishDate,
    required this.careerStage,
    required this.locationType,
  });

  factory JobPostResponseModel.fromJson(Map<String, dynamic> json) {
    return JobPostResponseModel(
      userId: json["userId"] ?? '',
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      salaryRange: json["salaryRange"] ?? '',
      location: json["location"] ?? '',
      shift: json["shift"] ?? '',
      responsibilities:
      List<String>.from(json["responsibilities"] ?? <String>[]),
      educationExperience:
      List<String>.from(json["educationExperience"] ?? <String>[]),
      benefits: List<String>.from(json["benefits"] ?? <String>[]),
      vacancy: json["vacancy"] ?? 0,
      experience: json["experience"] ?? '',
      deadline: json["deadline"] ?? '',
      status: json["status"] ?? '',
      jobCategoryId: json["jobCategoryId"] ?? '',
      name: json["name"] ?? '',
      role: json["role"] ?? '',
      compensation: json["compensation"] ?? '',
      archivedJob: json["archivedJob"] ?? false,
      applicationRequirement: (json["applicationRequirement"] as List<dynamic>?)
          ?.map((e) =>
          ApplicationRequirementResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      customQuestion: (json["customQuestion"] as List<dynamic>?)
          ?.map(
              (e) => CustomQuestionResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      employementType: json["employement_Type"] ?? '',
      websiteUrl: json["website_Url"] ?? '',
      publishDate: json["publishDate"] ?? '',
      careerStage: json["career_Stage"] ?? '',
      locationType: json["location_Type"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "title": title,
      "description": description,
      "salaryRange": salaryRange,
      "location": location,
      "shift": shift,
      "responsibilities": responsibilities,
      "educationExperience": educationExperience,
      "benefits": benefits,
      "vacancy": vacancy,
      "experience": experience,
      "deadline": deadline,
      "status": status,
      "jobCategoryId": jobCategoryId,
      "name": name,
      "role": role,
      "compensation": compensation,
      "archivedJob": archivedJob,
      "applicationRequirement":
      applicationRequirement.map((e) => e.toJson()).toList(),
      "customQuestion": customQuestion.map((e) => e.toJson()).toList(),
      "employement_Type": employementType,
      "website_Url": websiteUrl,
      "publishDate": publishDate,
      "career_Stage": careerStage,
      "location_Type": locationType,
    };
  }
}

class ApplicationRequirementResponse {
  final String requirement;
  final String status;

  ApplicationRequirementResponse({
    required this.requirement,
    required this.status,
  });

  factory ApplicationRequirementResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirementResponse(
      requirement: json["requirement"] ?? '',
      status: json["status"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "requirement": requirement,
      "status": status,
    };
  }
}

class CustomQuestionResponse {
  final String question;

  CustomQuestionResponse({required this.question});

  factory CustomQuestionResponse.fromJson(Map<String, dynamic> json) {
    return CustomQuestionResponse(
      question: json["question"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
    };
  }
}
