class UpdateJobRequest {
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
  String? deadline;
  String? description;
  String? department;
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
  String? id;

  UpdateJobRequest({
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
    this.deadline,
    this.description,
    this.department,
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
    this.id,
  });

  factory UpdateJobRequest.fromJson(Map<String, dynamic> json) {
    return UpdateJobRequest(
      adminApprove: json['adminApprove'],
      applicationRequirement: json['applicationRequirement'] != null
          ? List<ApplicationRequirement>.from(json['applicationRequirement']
          .map((x) => ApplicationRequirement.fromJson(x)))
          : [],
      arcrivedJob: json['arcrivedJob'],
      benefits: json['benefits'] ?? [],
      billingPlanType: json['billingPlanType'],
      careerStage: json['career_Stage'],
      compensation: json['compensation'],
      counter: json['counter'],
      createdAt: json['createdAt'],
      customQuestion: json['customQuestion'] != null
          ? List<CustomQuestion>.from(
          json['customQuestion'].map((x) => CustomQuestion.fromJson(x)))
          : [],
      deadline: json['deadline'],
      description: json['description'],
      educationExperience: json['educationExperience'] ?? [],
      embedding: json['embedding'] != null
          ? List<double>.from(json['embedding'].map((x) => x.toDouble()))
          : [],
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
      responsibilities: json['responsibilities'] ?? [],
      role: json['role'],
      salaryRange: json['salaryRange'],
      shift: json['shift'],
      status: json['status'],
      title: json['title'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vacancy: json['vacancy'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminApprove': adminApprove,

      'arcrivedJob': arcrivedJob,
      'benefits': benefits,
      'billingPlanType': billingPlanType,
      'career_Stage': careerStage,
      'compensation': compensation,
      'counter': counter,
      'createdAt': createdAt,
      "applicationRequirement":
      applicationRequirement?.map((e) => e.toJson()).toList(),
      "customQuestion": customQuestion?.map((e) => e.toJson()).toList(),
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

  Map<String, dynamic> toJson() => {
    'requirement': requirement,
    'status': status,
    '_id': id,
  };
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

  Map<String, dynamic> toJson() => {
    'question': question,
    '_id': id,
  };
}
