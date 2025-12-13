class UpdateJobRequest {
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
  });

  factory UpdateJobRequest.fromJson(Map<String, dynamic> json) {
    return UpdateJobRequest(
      applicationRequirement: json['applicationRequirement'] != null
          ? List<ApplicationRequirement>.from(json['applicationRequirement']
          .map((x) => ApplicationRequirement.fromJson(x)))
          : [],
      arcrivedJob: json['arcrivedJob'],
      website_Url: json['website_Url'],
      careerStage: json['career_Stage'],
      compensation: json['compensation'],
      createdAt: json['createdAt'],
      customQuestion: json['customQuestion'] != null
          ? List<CustomQuestion>.from(
          json['customQuestion'].map((x) => CustomQuestion.fromJson(x)))
          : [],
      deadline: json['deadline'],
      description: json['description'],
      educationExperience: json['educationExperience'] ?? [],
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
      'arcrivedJob': arcrivedJob,
      'career_Stage': careerStage,
      'compensation': compensation,
      'createdAt': createdAt,
      "applicationRequirement":
      applicationRequirement?.map((e) => e.toJson()).toList(),
      "customQuestion": customQuestion?.map((e) => e.toJson()).toList(),
      'deadline': deadline,
      'description': description,
      'educationExperience': educationExperience,
      'employement_Type': employementType,
      'experience': experience,
      'expiryDate': expiryDate,
      'jobApprove': jobApprove,
      'jobCategoryId': jobCategoryId,
      'location': location,
      'location_Type': locationType,
      'name': name,
      'publishDate': publishDate,
      'companyUrl': website_Url,
      'recruiterId': recruiterId,
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
