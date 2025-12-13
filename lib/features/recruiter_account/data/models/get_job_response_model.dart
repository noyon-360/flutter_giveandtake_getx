// job_response.dart
class YourJobResponseModel {
  final String id;
  final String userId;
  final String recruiterId;
  final String title;
  final String description;
  final String salaryRange;
  final String location;
  final String shift;
  final List<dynamic> responsibilities;
  final List<dynamic> educationExperience;
  final List<dynamic> benefits;
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
   bool arcrivedJob;
  final List<ApplicationRequirement> applicationRequirement;
  final List<CustomQuestion> customQuestion;
  final String jobApprove;
  final bool adminApprove;
  final DateTime? publishDate;
  final String employementType;
  final String locationType;
  final String careerStage;
  final String websiteUrl; // mapped from website_Url
  final DateTime? expiryDate;
  final String billingPlanType;
  final DateTime? deactivatedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final int applicantCount;
  final String derivedStatus;

  YourJobResponseModel({
    required this.id,
    required this.userId,
    required this.recruiterId,
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
    required this.applicantCount,
    required this.derivedStatus,
  });

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  factory YourJobResponseModel.fromJson(Map<String, dynamic> json) {
    List<double> toDoubleList(dynamic list) {
      if (list is! List) return [];
      return list.map<double>((e) => (e is num) ? e.toDouble() : double.tryParse(e.toString()) ?? 0.0).toList();
    }

    return YourJobResponseModel(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      recruiterId: json['recruiterId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      salaryRange: json['salaryRange']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      shift: json['shift']?.toString() ?? '',
      responsibilities: json['responsibilities'] as List<dynamic>? ?? [],
      educationExperience: json['educationExperience'] as List<dynamic>? ?? [],
      benefits: json['benefits'] as List<dynamic>? ?? [],
      vacancy: (json['vacancy'] is int) ? json['vacancy'] : int.tryParse('${json['vacancy']}') ?? 0,
      counter: (json['counter'] is int) ? json['counter'] : int.tryParse('${json['counter']}') ?? 0,
      embedding: toDoubleList(json['embedding']),
      experience: json['experience']?.toString() ?? '',
      deadline: _parseDate(json['deadline']),
      status: json['status']?.toString() ?? '',
      jobCategoryId: json['jobCategoryId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      compensation: json['compensation']?.toString() ?? '',
      arcrivedJob: json['arcrivedJob'] == true,
      applicationRequirement: (json['applicationRequirement'] as List<dynamic>?)
          ?.map((e) => ApplicationRequirement.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      customQuestion: (json['customQuestion'] as List<dynamic>?)
          ?.map((e) => CustomQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      jobApprove: json['jobApprove']?.toString() ?? '',
      adminApprove: json['adminApprove'] == true,
      publishDate: _parseDate(json['publishDate']),
      employementType: json['employement_Type']?.toString() ?? '',
      locationType: json['location_Type']?.toString() ?? '',
      careerStage: json['career_Stage']?.toString() ?? '',
      websiteUrl: json['website_Url']?.toString() ?? '',
      expiryDate: _parseDate(json['expiryDate']),
      billingPlanType: json['billingPlanType']?.toString() ?? '',
      deactivatedAt: _parseDate(json['deactivatedAt']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      v: (json['__v'] is int) ? json['__v'] : int.tryParse('${json['__v']}') ?? 0,
      applicantCount: (json['applicantCount'] is int) ? json['applicantCount'] : int.tryParse('${json['applicantCount']}') ?? 0,
      derivedStatus: json['derivedStatus']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    String? toIso(DateTime? d) => d?.toUtc().toIso8601String();
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
      'deadline': toIso(deadline),
      'status': status,
      'jobCategoryId': jobCategoryId,
      'name': name,
      'role': role,
      'compensation': compensation,
      'arcrivedJob': arcrivedJob,
      'applicationRequirement': applicationRequirement.map((e) => e.toJson()).toList(),
      'customQuestion': customQuestion.map((e) => e.toJson()).toList(),
      'jobApprove': jobApprove,
      'adminApprove': adminApprove,
      'publishDate': toIso(publishDate),
      'employement_Type': employementType,
      'location_Type': locationType,
      'career_Stage': careerStage,
      'website_Url': websiteUrl,
      'expiryDate': toIso(expiryDate),
      'billingPlanType': billingPlanType,
      'deactivatedAt': toIso(deactivatedAt),
      'createdAt': toIso(createdAt),
      'updatedAt': toIso(updatedAt),
      '__v': v,
      'applicantCount': applicantCount,
      'derivedStatus': derivedStatus,
    };
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
      requirement: json['requirement']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
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
      question: json['question']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'question': question, '_id': id};
  }
}
