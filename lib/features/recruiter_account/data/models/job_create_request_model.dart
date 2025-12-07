import 'job_update_request_model.dart';

class JobPostRequestModel {
  final String userId;
  final String title;
  final String description;
   String? salaryRange;
  final String location;
  String? shift;
  final List<String>? responsibilities;
  final List<String>? educationExperience;
  final List<String>? benefits;
  final int vacancy;
  final String experience;
  final String deadline;
  final String? status;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final bool? archivedJob;
  final List<ApplicationRequirement> applicationRequirement;
  final List<CustomQuestion> customQuestion;
  final String employementType;
  final String websiteUrl;
  final String publishDate;
  final String careerStage;
  final String locationType;
  final String website_Url;

  JobPostRequestModel({
    required this.userId,
    required this.title,
    required this.description,
    this.salaryRange,
    required this.location,
    this.shift,
    this.responsibilities,
    this.educationExperience,
    this.benefits,
    required this.vacancy,
    required this.experience,
    required this.deadline,
     this.status,
    required this.jobCategoryId,
    required this.name,
    required this.role,
    required this.compensation,
     this.archivedJob,
    required this.applicationRequirement,
    required this.customQuestion,
    required this.employementType,
    required this.websiteUrl,
    required this.publishDate,
    required this.careerStage,
    required this.locationType,
    required this.website_Url,
  });

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

class ApplicationRequirement {
  final String requirement;
  final String status;

  ApplicationRequirement({
    required this.requirement,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "requirement": requirement,
      "status": status,
    };
  }

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirement(
      requirement: json["requirement"],
      status: json["status"],
    );
  }
}

class CustomQuestion {
  final String question;

  CustomQuestion({required this.question});

  Map<String, dynamic> toJson() {
    return {
      "question": question,
    };
  }

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      question: json["question"],
    );
  }
}
