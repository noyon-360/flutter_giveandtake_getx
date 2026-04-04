
class ArchieveRequestModel {
  final String id;
  final String userId;
  final bool adminApprove;
  final List<ApplicationRequirement> applicationRequirement;
  final bool arcrivedJob;
  final List<dynamic> benefits;
  final String billingPlanType;
  final String careerStage;
  final String companyId;
  final String compensation;
  final int counter;
  final String createdAt;
  final List<CustomQuestion> customQuestion;
  final String? deactivatedAt;
  final String deadline;
  final String description;
  final List<dynamic> educationExperience;
  final List<double> embedding;
  final String employementType;
  final String experience;
  final String expiryDate;
  final String jobApprove;
  final String jobCategoryId;
  final String location;
  final String locationType;
  final String name;
  final String publishDate;
  final List<dynamic> responsibilities;
  final String role;
  final String salaryRange;
  final String shift;
  final String status;
  final String title;
  final String updatedAt;
  final int vacancy;
  final String websiteUrl;
  final int v;

  ArchieveRequestModel({
    required this.id,
    required this.userId,
    required this.adminApprove,
    required this.applicationRequirement,
    required this.arcrivedJob,
    required this.benefits,
    required this.billingPlanType,
    required this.careerStage,
    required this.companyId,
    required this.compensation,
    required this.counter,
    required this.createdAt,
    required this.customQuestion,
    required this.deactivatedAt,
    required this.deadline,
    required this.description,
    required this.educationExperience,
    required this.embedding,
    required this.employementType,
    required this.experience,
    required this.expiryDate,
    required this.jobApprove,
    required this.jobCategoryId,
    required this.location,
    required this.locationType,
    required this.name,
    required this.publishDate,
    required this.responsibilities,
    required this.role,
    required this.salaryRange,
    required this.shift,
    required this.status,
    required this.title,
    required this.updatedAt,
    required this.vacancy,
    required this.websiteUrl,
    required this.v,
  });

  factory ArchieveRequestModel.fromJson(Map<String, dynamic> json) {
    return ArchieveRequestModel(
      id: json['_id'],
      userId: json['userId'],
      adminApprove: json['adminApprove'],
      applicationRequirement: (json['applicationRequirement'] as List)
          .map((e) => ApplicationRequirement.fromJson(e))
          .toList(),
      arcrivedJob: json['arcrivedJob'],
      benefits: json['benefits'] ?? [],
      billingPlanType: json['billingPlanType'] ?? "",
      careerStage: json['career_Stage'] ?? "",
      companyId: json['companyId'] ?? "",
      compensation: json['compensation'] ?? "",
      counter: json['counter'] ?? 0,
      createdAt: json['createdAt'] ?? "",
      customQuestion: (json['customQuestion'] as List)
          .map((e) => CustomQuestion.fromJson(e))
          .toList(),
      deactivatedAt: json['deactivatedAt'],
      deadline: json['deadline'] ?? "",
      description: json['description'] ?? "",
      educationExperience: json['educationExperience'] ?? [],
      embedding: (json['embedding'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      employementType: json['employement_Type'] ?? "",
      experience: json['experience'] ?? "",
      expiryDate: json['expiryDate'] ?? "",
      jobApprove: json['jobApprove'] ?? "",
      jobCategoryId: json['jobCategoryId'] ?? "",
      location: json['location'] ?? "",
      locationType: json['location_Type'] ?? "",
      name: json['name'] ?? "",
      publishDate: json['publishDate'] ?? "",
      responsibilities: json['responsibilities'] ?? [],
      role: json['role'] ?? "",
      salaryRange: json['salaryRange'] ?? "",
      shift: json['shift'] ?? "",
      status: json['status'] ?? "",
      title: json['title'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      vacancy: json['vacancy'] ?? 0,
      websiteUrl: json['website_Url'] ?? "",
      v: json['__v'] ?? 0,
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
      requirement: json['requirement'],
      status: json['status'],
      id: json['_id'],
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
      question: json['question'],
      id: json['_id'],
    );
  }
}
