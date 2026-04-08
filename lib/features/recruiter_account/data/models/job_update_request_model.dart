import 'package:giveandtake/core/contracts/web/job_contract.dart';

class UpdateJobRequest {
  UpdateJobRequest({
    this.applicationRequirement,
    this.arcrivedJob,
    this.careerStage,
    this.compensation,
    this.createdAt,
    this.customQuestion,
    this.deadline,
    this.description,
    this.department,
    this.educationExperience,
    this.employementType,
    this.experience,
    this.expiryDate,
    this.expirationDateDays,
    this.jobApprove,
    this.jobCategoryId,
    this.location,
    this.locationType,
    this.name,
    this.publishDate,
    this.website_Url,
    this.recruiterId,
    this.role,
    this.salaryRange,
    this.shift,
    this.status,
    this.title,
    this.updatedAt,
    this.userId,
    this.vacancy,
    this.id,
    this.companyId,
    this.responsibilities,
    this.benefits,
  });

  List<ApplicationRequirement>? applicationRequirement;
  bool? arcrivedJob;
  String? careerStage;
  String? compensation;
  String? createdAt;
  List<CustomQuestion>? customQuestion;
  String? deadline;
  String? description;
  String? department;
  List<dynamic>? educationExperience;
  String? employementType;
  String? experience;
  String? expiryDate;
  String? expirationDateDays;
  String? jobApprove;
  String? jobCategoryId;
  String? location;
  String? locationType;
  String? name;
  String? publishDate;
  String? website_Url;
  String? recruiterId;
  String? role;
  String? salaryRange;
  String? shift;
  String? status;
  String? title;
  String? updatedAt;
  String? userId;
  int? vacancy;
  String? id;
  String? companyId;
  List<String>? responsibilities;
  List<String>? benefits;

  factory UpdateJobRequest.fromJson(Map<String, dynamic> json) {
    return UpdateJobRequest(
      applicationRequirement: json['applicationRequirement'] != null
          ? List<ApplicationRequirement>.from(
              json['applicationRequirement'].map(
                (x) => ApplicationRequirement.fromJson(x),
              ),
            )
          : [],
      arcrivedJob: json['arcrivedJob'],
      website_Url: json['website_Url'] ?? json['companyUrl'],
      careerStage: json['career_Stage'],
      compensation: json['compensation'],
      createdAt: json['createdAt'],
      customQuestion: json['customQuestion'] != null
          ? List<CustomQuestion>.from(
              json['customQuestion'].map((x) => CustomQuestion.fromJson(x)),
            )
          : [],
      deadline: json['deadline'],
      description: json['description'],
      department: json['department'],
      educationExperience: json['educationExperience'] ?? [],
      employementType: json['employement_Type'],
      experience: json['experience'],
      expiryDate: json['expiryDate'],
      expirationDateDays: json['expirationDate']?.toString(),
      jobApprove: json['jobApprove'],
      jobCategoryId: json['jobCategoryId'],
      location: json['location'],
      locationType: json['location_Type'],
      name: json['name'],
      publishDate: json['publishDate'],
      recruiterId: json['recruiterId'],
      role: json['role'],
      salaryRange: json['salaryRange'],
      shift: json['shift'],
      status: json['status'],
      title: json['title'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vacancy: json['vacancy'],
      id: json['_id'],
      companyId: json['companyId'],
      responsibilities: (json['responsibilities'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      benefits: (json['benefits'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final payload = JobPayloadBuilder.build(
      JobContractInput(
        userId: userId ?? '',
        companyId: companyId,
        title: title ?? '',
        description: description ?? '',
        location: location ?? '',
        vacancy: vacancy ?? 1,
        experience: experience ?? '',
        jobCategoryId: jobCategoryId ?? '',
        name: name ?? '',
        role: role ?? '',
        compensation: compensation ?? '',
        employementType: employementType ?? '',
        publishDate: publishDate ?? createdAt ?? DateTime.now().toIso8601String(),
        careerStage: careerStage ?? '',
        locationType: locationType ?? '',
        expirationDateDays:
            expirationDateDays ?? _deriveExpirationDateDays(publishDate, expiryDate),
        applicationRequirement: (applicationRequirement ?? <ApplicationRequirement>[])
            .map(
              (item) => JobRequirementInput(
                requirement: item.requirement ?? '',
                status: item.status ?? '',
              ),
            )
            .toList(),
        customQuestion: (customQuestion ?? <CustomQuestion>[])
            .map((item) => JobQuestionInput(question: item.question ?? ''))
            .toList(),
        status: status ?? 'active',
        archivedJob: arcrivedJob ?? false,
        websiteUrl: website_Url,
        salaryRange: salaryRange,
        shift: shift,
        responsibilities: responsibilities ?? const <String>[],
        educationExperience: educationExperience
                ?.map((item) => item.toString())
                .toList() ??
            const <String>[],
        benefits: benefits ?? const <String>[],
      ),
    );

    payload['_id'] = id;
    payload['createdAt'] = createdAt;
    payload['updatedAt'] = updatedAt;
    payload['jobApprove'] = jobApprove;
    payload['recruiterId'] = recruiterId;

    if (applicationRequirement != null) {
      payload['applicationRequirement'] = applicationRequirement!
          .map((item) => item.toJson())
          .toList();
    }
    if (customQuestion != null) {
      payload['customQuestion'] = customQuestion!.map((item) => item.toJson()).toList();
    }

    return payload;
  }

  static String _deriveExpirationDateDays(String? publishDate, String? expiryDate) {
    final publish = DateTime.tryParse(publishDate ?? '');
    final expiry = DateTime.tryParse(expiryDate ?? '');
    if (publish == null || expiry == null) {
      return '30';
    }
    final difference = expiry.difference(publish).inDays;
    if (difference <= 0) {
      return '30';
    }
    return difference.toString();
  }
}

class ApplicationRequirement {
  ApplicationRequirement({this.requirement, this.status, this.id});

  String? requirement;
  String? status;
  String? id;

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirement(
      requirement: json['requirement'],
      status: json['status'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'requirement': requirement,
        'status': status,
        if (id != null) '_id': id,
      };
}

class CustomQuestion {
  CustomQuestion({this.question, this.id});

  String? question;
  String? id;

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      question: json['question'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        if (id != null) '_id': id,
      };
}
