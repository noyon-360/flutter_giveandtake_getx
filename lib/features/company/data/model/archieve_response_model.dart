// job_response_model.dart

import 'dart:convert';

class ArchieveResponseModel {
  final String id;
  final String userId;
  final String companyId;
  final String title;
  final String description;
  final String salaryRange;
  final String location;
  final String shift;
  final List<String> responsibilities;
  final List<String> educationExperience;
  final List<String> benefits;
  final int vacancy;
  final int counter;
  final List<double> embedding;
  final String experience;
  final DateTime? deadline;
  final String status;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final bool arcrivedJob;
  final List<ApplicationRequirement> applicationRequirement;
  final List<CustomQuestion> customQuestion;
  final String jobApprove;
  final bool adminApprove;
  final DateTime? publishDate;
  final String employementType;
  final String locationType;
  final String careerStage;
  final String websiteUrl;
  final DateTime? expiryDate;
  final String billingPlanType;
  final DateTime? deactivatedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  ArchieveResponseModel({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.title,
    required this.description,
    required this.salaryRange,
    required this.location,
    required this.shift,
    required this.responsibilities,
    required this.educationExperience,
    required this.benefits,
    required this.vacancy,
    required this.counter,
    required this.embedding,
    required this.experience,
    this.deadline,
    required this.status,
    required this.jobCategoryId,
    required this.name,
    required this.role,
    required this.compensation,
    required this.arcrivedJob,
    required this.applicationRequirement,
    required this.customQuestion,
    required this.jobApprove,
    required this.adminApprove,
    this.publishDate,
    required this.employementType,
    required this.locationType,
    required this.careerStage,
    required this.websiteUrl,
    this.expiryDate,
    required this.billingPlanType,
    this.deactivatedAt,
    this.createdAt,
    this.updatedAt,
    required this.v,
  });

  factory ArchieveResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? emb = json['embedding'] as List<dynamic>?;
    return ArchieveResponseModel(
      id: json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      salaryRange: json['salaryRange'] as String? ?? '',
      location: json['location'] as String? ?? '',
      shift: json['shift'] as String? ?? '',
      responsibilities: (json['responsibilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      educationExperience:
          (json['educationExperience'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              <String>[],
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      vacancy: (json['vacancy'] is int)
          ? json['vacancy'] as int
          : int.tryParse(json['vacancy']?.toString() ?? '') ?? 0,
      counter: (json['counter'] is int)
          ? json['counter'] as int
          : int.tryParse(json['counter']?.toString() ?? '') ?? 0,
      embedding: emb != null
          ? emb.map((e) => (e as num).toDouble()).toList()
          : <double>[],
      experience: json['experience'] as String? ?? '',
      deadline: _parseNullableDate(json['deadline']),
      status: json['status'] as String? ?? '',
      jobCategoryId: json['jobCategoryId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      compensation: json['compensation'] as String? ?? '',
      arcrivedJob: json['arcrivedJob'] is bool
          ? json['arcrivedJob'] as bool
          : (json['arcrivedJob']?.toString().toLowerCase() == 'true'),
      applicationRequirement:
          (json['applicationRequirement'] as List<dynamic>?)
                  ?.map((e) => ApplicationRequirement.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              <ApplicationRequirement>[],
      customQuestion: (json['customQuestion'] as List<dynamic>?)
              ?.map((e) => CustomQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <CustomQuestion>[],
      jobApprove: json['jobApprove'] as String? ?? '',
      adminApprove: json['adminApprove'] is bool
          ? json['adminApprove'] as bool
          : (json['adminApprove']?.toString().toLowerCase() == 'true'),
      publishDate: _parseNullableDate(json['publishDate']),
      employementType: json['employement_Type'] as String? ?? '',
      locationType: json['location_Type'] as String? ?? '',
      careerStage: json['career_Stage'] as String? ?? '',
      websiteUrl: json['website_Url'] as String? ?? '',
      expiryDate: _parseNullableDate(json['expiryDate']),
      billingPlanType: json['billingPlanType'] as String? ?? '',
      deactivatedAt: _parseNullableDate(json['deactivatedAt']),
      createdAt: _parseNullableDate(json['createdAt']),
      updatedAt: _parseNullableDate(json['updatedAt']),
      v: (json['__v'] is int) ? json['__v'] as int : int.tryParse(json['__v']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'companyId': companyId,
      'title': title,
      'description': description,
      'salaryRange': salaryRange,
      'location': location,
      'shift': shift,
      'responsibilities': responsibilities,
      'educationExperience': educationExperience,
      'benefits': benefits,
      'vacancy': vacancy,
      'counter': counter,
      'embedding': embedding,
      'experience': experience,
      'deadline': deadline?.toIso8601String(),
      'status': status,
      'jobCategoryId': jobCategoryId,
      'name': name,
      'role': role,
      'compensation': compensation,
      'arcrivedJob': arcrivedJob,
      'applicationRequirement':
          applicationRequirement.map((e) => e.toJson()).toList(),
      'customQuestion': customQuestion.map((e) => e.toJson()).toList(),
      'jobApprove': jobApprove,
      'adminApprove': adminApprove,
      'publishDate': publishDate?.toIso8601String(),
      'employement_Type': employementType,
      'location_Type': locationType,
      'career_Stage': careerStage,
      'website_Url': websiteUrl,
      'expiryDate': expiryDate?.toIso8601String(),
      'billingPlanType': billingPlanType,
      'deactivatedAt': deactivatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }

  static DateTime? _parseNullableDate(dynamic dateValue) {
    if (dateValue == null) return null;
    if (dateValue is DateTime) return dateValue;
    try {
      return DateTime.parse(dateValue.toString());
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() => 'JobResponseModel(id: $id, title: $title)';
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
      requirement: json['requirement'] as String? ?? '',
      status: json['status'] as String? ?? '',
      id: json['_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requirement': requirement,
      'status': status,
      '_id': id,
    };
  }

  @override
  String toString() =>
      'ApplicationRequirement(requirement: $requirement, status: $status)';
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
      question: json['question'] as String? ?? '',
      id: json['_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      '_id': id,
    };
  }

  @override
  String toString() => 'CustomQuestion(question: $question)';
}
