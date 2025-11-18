import 'dart:convert';

import 'package:flutx_core/core/debug_print.dart';

class YourJobResponseModel {
  final String id;
  final String userId;
  final String recruiterId;
  final String title;
  final String description;
  final dynamic salaryRange; // null in JSON
  final String location;
  final dynamic shift; // null
  final dynamic responsibilities; // null
  final dynamic educationExperience; // null
  final dynamic benefits; // null
  final int vacancy;
  final int counter;
  final List<double> embedding;
  final String experience;
  final DateTime deadline;
  final dynamic status; // null
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
  final String billingPlanType;
  final dynamic deactivatedAt; // null
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final int applicantCount;
  final String derivedStatus;

  YourJobResponseModel({
    required this.id,
    required this.userId,
    required this.recruiterId,
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
    required this.billingPlanType,
    this.deactivatedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.applicantCount,
    required this.derivedStatus,
  });

  factory YourJobResponseModel.fromJson(Map<String, dynamic> json) {
    DPrint.log("Get job response model -> ${json["userId"]}");
    return YourJobResponseModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      recruiterId: json['recruiterId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      salaryRange: json['salaryRange'],
      location: json['location'] as String,
      shift: json['shift'],
      responsibilities: json['responsibilities'],
      educationExperience: json['educationExperience'],
      benefits: json['benefits'],
      vacancy: json['vacancy'] as int,
      counter: json['counter'] as int,
      embedding: (json['embedding'] as List).cast<double>(),
      experience: json['experience'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      status: json['status'],
      jobCategoryId: json['jobCategoryId'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      compensation: json['compensation'] as String,
      arcrivedJob: json['arcrivedJob'] as bool,
      applicationRequirement: (json['applicationRequirement'] as List)
          .map((e) => ApplicationRequirement.fromJson(e as Map<String, dynamic>))
          .toList(),
      customQuestion: (json['customQuestion'] as List)
          .map((e) => CustomQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobApprove: json['jobApprove'] as String,
      adminApprove: json['adminApprove'] as bool,
      publishDate: DateTime.parse(json['publishDate'] as String),
      employementType: json['employement_Type'] as String,
      locationType: json['location_Type'] as String,
      careerStage: json['career_Stage'] as String,
      websiteUrl: json['website_Url'] as String,
      billingPlanType: json['billingPlanType'] as String,
      deactivatedAt: json['deactivatedAt'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
      applicantCount: json['applicantCount'] as int,
      derivedStatus: json['derivedStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'recruiterId': recruiterId,
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
      'deadline': deadline.toIso8601String(),
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
      'publishDate': publishDate.toIso8601String(),
      'employement_Type': employementType,
      'location_Type': locationType,
      'career_Stage': careerStage,
      'website_Url': websiteUrl,
      'billingPlanType': billingPlanType,
      'deactivatedAt': deactivatedAt,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'applicantCount': applicantCount,
      'derivedStatus': derivedStatus,
    };
  }

  @override
  String toString() {
    return 'YourJobResponseModel{id: $id, title: $title, location: $location, deadline: $deadline}';
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
      requirement: json['requirement'] as String,
      status: json['status'] as String,
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requirement': requirement,
      'status': status,
      '_id': id,
    };
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
      question: json['question'] as String,
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      '_id': id,
    };
  }
}