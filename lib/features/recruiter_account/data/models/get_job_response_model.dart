import 'package:flutx_core/core/debug_print.dart';

class YourJobResponseModel {
  final String id;
  final String userId;
  final String companyId;
  final String title;
  final String description;
  final String? salaryRange;
  final String location;
  final String? shift;
  final List<dynamic>? responsibilities;
  final List<dynamic>? educationExperience;
  final List<dynamic>? benefits;
  final int vacancy;
  final int counter;
  final List<double> embedding;
  final String experience;
  final DateTime deadline;
  final String? status;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final bool arcrivedJob;
  final List<ApplicationRequirement> applicationRequirement;
  final List<CustomQuestion> customQuestion;
  final String jobApprove;
  final bool adminApprove;
  final DateTime publishDate;
  final String employementType;
  final String locationType;
  final String careerStage;
  final String websiteUrl;
  final DateTime expiryDate;
  final String billingPlanType;
  final DateTime? deactivatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int applicantCount;
  final String derivedStatus;

  YourJobResponseModel({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.title,
    required this.description,
    this.salaryRange,
    required this.location,
    this.shift,
    this.responsibilities,
    this.educationExperience,
    this.benefits,
    required this.vacancy,
    required this.counter,
    required this.embedding,
    required this.experience,
    required this.deadline,
    this.status,
    required this.jobCategoryId,
    required this.name,
    required this.role,
    required this.compensation,
    required this.arcrivedJob,
    required this.applicationRequirement,
    required this.customQuestion,
    required this.jobApprove,
    required this.adminApprove,
    required this.publishDate,
    required this.employementType,
    required this.locationType,
    required this.careerStage,
    required this.websiteUrl,
    required this.expiryDate,
    required this.billingPlanType,
    this.deactivatedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.applicantCount,
    required this.derivedStatus,
  });

  factory YourJobResponseModel.fromJson(Map<String, dynamic> json) {
    return YourJobResponseModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      companyId: json['companyId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      salaryRange: json['salaryRange'] as String?,
      location: json['location'] as String,
      shift: json['shift'] as String?,
      responsibilities: json['responsibilities'] as List<dynamic>?,
      educationExperience: json['educationExperience'] as List<dynamic>?,
      benefits: json['benefits'] as List<dynamic>?,
      vacancy: json['vacancy'] as int,
      counter: json['counter'] as int? ?? 0,
      embedding: (json['embedding'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      experience: json['experience'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      status: json['status'] as String?,
      jobCategoryId: json['jobCategoryId'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      compensation: json['compensation'] as String? ?? '',
      arcrivedJob: json['arcrivedJob'] as bool? ?? false,
      applicationRequirement: (json['applicationRequirement'] as List<dynamic>?)
          ?.map((e) => ApplicationRequirement.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      customQuestion: (json['customQuestion'] as List<dynamic>?)
          ?.map((e) => CustomQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      jobApprove: json['jobApprove'] as String? ?? 'pending',
      adminApprove: json['adminApprove'] as bool? ?? false,
      publishDate: DateTime.parse(json['publishDate'] as String),
      employementType: json['employement_Type'] as String? ?? 'full-time',
      locationType: json['location_Type'] as String? ?? 'onsite',
      careerStage: json['career_Stage'] as String? ?? 'New Entry',
      websiteUrl: (json['website_Url'] as String?) ?? '',
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      billingPlanType: json['billingPlanType'] as String? ?? 'free',
      deactivatedAt: json['deactivatedAt'] != null
          ? DateTime.parse(json['deactivatedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      applicantCount: json['applicantCount'] as int? ?? 0,
      derivedStatus: json['derivedStatus'] as String? ?? 'Pending',
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

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) => ApplicationRequirement(
    requirement: json["requirement"],
    status: json["status"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "requirement": requirement,
    "status": status,
    "_id": id,
  };
}

class CustomQuestion {
  final String question;
  final String id;

  CustomQuestion({
    required this.question,
    required this.id,
  });

  factory CustomQuestion.fromJson(Map<String, dynamic> json) => CustomQuestion(
    question: json["question"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "_id": id,
  };
}
