class ArchieveJobRequestModel {
  bool? adminApprove;
  List<ApplicationRequirement>? applicationRequirement;
  bool? arcrivedJob;
  List<dynamic>? benefits;
  String? billingPlanType;
  String? careerStage;
  String? compensation;
  int? counter;
  String? createdAt;
  List<CustomQuestion>? customQuestion;
  String? deactivatedAt;
  String? deadline;
  String? description;
  List<dynamic>? educationExperience;
  List<double>? embedding;
  String? employementType;
  String? experience;
  String? expiryDate;
  String? jobApprove;
  String? jobCategoryId;
  String? location;
  String? locationType;
  String? name;
  String? publishDate;
  String? recruiterId;
  List<dynamic>? responsibilities;
  String? role;
  String? salaryRange;
  String? shift;
  String? status;
  String? title;
  String? updatedAt;
  String? userId;
  int? vacancy;
  String? websiteUrl;
  int? v;
  String? id;

  ArchieveJobRequestModel({
    this.adminApprove,
    this.applicationRequirement,
    this.arcrivedJob,
    this.benefits,
    this.billingPlanType,
    this.careerStage,
    this.compensation,
    this.counter,
    this.createdAt,
    this.customQuestion,
    this.deactivatedAt,
    this.deadline,
    this.description,
    this.educationExperience,
    this.embedding,
    this.employementType,
    this.experience,
    this.expiryDate,
    this.jobApprove,
    this.jobCategoryId,
    this.location,
    this.locationType,
    this.name,
    this.publishDate,
    this.recruiterId,
    this.responsibilities,
    this.role,
    this.salaryRange,
    this.shift,
    this.status,
    this.title,
    this.updatedAt,
    this.userId,
    this.vacancy,
    this.websiteUrl,
    this.v,
    this.id,
  });

  factory ArchieveJobRequestModel.fromJson(Map<String, dynamic> json) {
    return ArchieveJobRequestModel(
      adminApprove: json['adminApprove'],
      applicationRequirement: (json['applicationRequirement'] as List?)
          ?.map((e) => ApplicationRequirement.fromJson(e))
          .toList(),
      arcrivedJob: json['arcrivedJob'],
      benefits: json['benefits'],
      billingPlanType: json['billingPlanType'],
      careerStage: json['career_Stage'],
      compensation: json['compensation'],
      counter: json['counter'],
      createdAt: json['createdAt'],
      customQuestion: (json['customQuestion'] as List?)
          ?.map((e) => CustomQuestion.fromJson(e))
          .toList(),
      deactivatedAt: json['deactivatedAt'],
      deadline: json['deadline'],
      description: json['description'],
      educationExperience: json['educationExperience'],
      embedding: (json['embedding'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      employementType: json['employement_Type'],
      experience: json['experience'],
      expiryDate: json['expiryDate'],
      jobApprove: json['jobApprove'],
      jobCategoryId: json['jobCategoryId'],
      location: json['location'],
      locationType: json['location_Type'],
      name: json['name'],
      publishDate: json['publishDate'],
      recruiterId: json['recruiterId'],
      responsibilities: json['responsibilities'],
      role: json['role'],
      salaryRange: json['salaryRange'],
      shift: json['shift'],
      status: json['status'],
      title: json['title'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vacancy: json['vacancy'],
      websiteUrl: json['website_Url'],
      v: json['__v'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminApprove': adminApprove,
      'applicationRequirement':
      applicationRequirement?.map((e) => e.toJson()).toList(),
      'arcrivedJob': arcrivedJob,
      'benefits': benefits,
      'billingPlanType': billingPlanType,
      'career_Stage': careerStage,
      'compensation': compensation,
      'counter': counter,
      'createdAt': createdAt,
      'customQuestion': customQuestion?.map((e) => e.toJson()).toList(),
      'deactivatedAt': deactivatedAt,
      'deadline': deadline,
      'description': description,
      'educationExperience': educationExperience,
      'embedding': embedding,
      'employement_Type': employementType,
      'experience': experience,
      'expiryDate': expiryDate,
      'jobApprove': jobApprove,
      'jobCategoryId': jobCategoryId,
      'location': location,
      'location_Type': locationType,
      'name': name,
      'publishDate': publishDate,
      'recruiterId': recruiterId,
      'responsibilities': responsibilities,
      'role': role,
      'salaryRange': salaryRange,
      'shift': shift,
      'status': status,
      'title': title,
      'updatedAt': updatedAt,
      'userId': userId,
      'vacancy': vacancy,
      'website_Url': websiteUrl,
      '__v': v,
      '_id': id,
    };
  }
}

class ApplicationRequirement {
  String? requirement;
  String? status;
  String? id;

  ApplicationRequirement({this.requirement, this.status, this.id});

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirement(
      requirement: json['requirement'],
      status: json['status'],
      id: json['_id'],
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
  String? question;
  String? id;

  CustomQuestion({this.question, this.id});

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      question: json['question'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      '_id': id,
    };
  }
}
