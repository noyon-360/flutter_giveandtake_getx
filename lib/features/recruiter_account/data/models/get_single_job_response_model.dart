import 'job_update_request_model.dart';

class GetSingleJobResponseModel {
  String? id;
  User? user;
  Recruiter? recruiter;
  String? title;
  String? description;
  String? department;
  String? salaryRange;
  String? location;
  String? shift;
  List<String>? responsibilities;
  List<String>? educationExperience;
  List<String>? benefits;
  int? vacancy;
  int? counter;
  String? experience;
  DateTime? deadline;
  String? status;
  String? jobCategoryId;
  String? name;
  String? role;
  String? compensation;
  bool? arcrivedJob;
  List<ApplicationRequirement>? applicationRequirement;
  List<CustomQuestion>? customQuestion;
  String? jobApprove;
  String? website_Url;
  bool? adminApprove;
  DateTime? publishDate;
  String? employementType;
  String? locationType;
  String? careerStage;
  DateTime? expiryDate;
  String? billingPlanType;
  DateTime? deactivatedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GetSingleJobResponseModel({
    this.id,
    this.user,
    this.recruiter,
    this.title,
    this.description,
    this.department,
    this.salaryRange,
    this.location,
    this.shift,
    this.responsibilities,
    this.educationExperience,
    this.benefits,
    this.vacancy,
    this.counter,
    this.experience,
    this.deadline,
    this.status,
    this.jobCategoryId,
    this.name,
    this.role,
    this.compensation,
    this.arcrivedJob,
    this.applicationRequirement,
    this.customQuestion,
    this.jobApprove,
    this.website_Url,
    this.adminApprove,
    this.publishDate,
    this.employementType,
    this.locationType,
    this.careerStage,
    this.expiryDate,
    this.billingPlanType,
    this.deactivatedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GetSingleJobResponseModel.fromJson(Map<String, dynamic> json) {
    return GetSingleJobResponseModel(
      id: json['_id'],
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      recruiter: json['recruiterId'] != null ? Recruiter.fromJson(json['recruiterId']) : null,
      title: json['title'],
      description: json['description'],
      salaryRange: json['salaryRange'],
      location: json['location'],
      website_Url: json['website_Url'],
      shift: json['shift'],
      responsibilities: json['responsibilities'] != null ? List<String>.from(json['responsibilities']) : [],
      educationExperience: json['educationExperience'] != null ? List<String>.from(json['educationExperience']) : [],
      benefits: json['benefits'] != null ? List<String>.from(json['benefits']) : [],
      vacancy: json['vacancy'],
      counter: json['counter'],
      experience: json['experience'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      status: json['status'],
      jobCategoryId: json['jobCategoryId'],
      name: json['name'],
      role: json['role'],
      compensation: json['compensation'],
      arcrivedJob: json['arcrivedJob'],
      applicationRequirement: json['applicationRequirement'] != null
          ? List<ApplicationRequirement>.from(json['applicationRequirement'].map((x) => ApplicationRequirement.fromJson(x)))
          : [],
      customQuestion: json['customQuestion'] != null
          ? List<CustomQuestion>.from(json['customQuestion'].map((x) => CustomQuestion.fromJson(x)))
          : [],
      jobApprove: json['jobApprove'],
      adminApprove: json['adminApprove'],
      publishDate: json['publishDate'] != null ? DateTime.parse(json['publishDate']) : null,
      employementType: json['employement_Type'],
      locationType: json['location_Type'],
      careerStage: json['career_Stage'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      billingPlanType: json['billingPlanType'],
      deactivatedAt: json['deactivatedAt'] != null ? DateTime.parse(json['deactivatedAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }
}

class User {
  final Avatar avatar;
  final VerificationInfo verificationInfo;
  final String id;
  final String name;
  final String email;
  final String role;
  final String address;
  final String dateOfBirth;
  final String passwordResetToken;
  final bool deactivate;
  final List<SecurityQuestion> securityQuestions;
  final String createdAt;
  final String updatedAt;
  final String slug;
  final int v;
  final String refreshToken;

  User({
    required this.avatar,
    required this.verificationInfo,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    required this.dateOfBirth,
    required this.passwordResetToken,
    required this.deactivate,
    required this.securityQuestions,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.v,
    required this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatar: Avatar.fromJson(json["avatar"]),
      verificationInfo: VerificationInfo.fromJson(json["verificationInfo"]),
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      address: json["address"],
      dateOfBirth: json["dateOfbirth"],
      passwordResetToken: json["password_reset_token"],
      deactivate: json["deactivate"],
      securityQuestions: (json["securityQuestions"] as List)
          .map((e) => SecurityQuestion.fromJson(e))
          .toList(),
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      slug: json["slug"],
      v: json["__v"],
      refreshToken: json["refresh_token"],
    );
  }
}


class Avatar {
  String? url;
  Avatar({this.url});
  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(url: json['url']);
  Map<String, dynamic> toJson() => {'url': url};
}

class VerificationInfo {
  String? token;
  bool? verified;
  String? resetToken;
  VerificationInfo({this.token, this.verified, this.resetToken});
  factory VerificationInfo.fromJson(Map<String, dynamic> json) => VerificationInfo(
    token: json['token'],
    verified: json['verified'],
    resetToken: json['resetToken'],
  );
  Map<String, dynamic> toJson() => {'token': token, 'verified': verified, 'resetToken': resetToken};
}

class SecurityQuestion {
  String? question;
  String? answer;
  String? id;
  SecurityQuestion({this.question, this.answer, this.id});
  factory SecurityQuestion.fromJson(Map<String, dynamic> json) => SecurityQuestion(
    question: json['question'],
    answer: json['answer'],
    id: json['_id'],
  );
  Map<String, dynamic> toJson() => {'question': question, 'answer': answer, '_id': id};
}

class Recruiter {
  String? id;
  String? userId;
  String? bio;
  String? banner;
  String? photo;
  String? title;
  String? firstName;
  String? sureName;
  String? country;
  String? city;
  String? zipCode;
  String? emailAddress;
  String? slug;
  List<SocialLink>? sLink;
  DateTime? createdAt;
  DateTime? updatedAt;

  Recruiter({
    this.id,
    this.userId,
    this.bio,
    this.banner,
    this.photo,
    this.title,
    this.firstName,
    this.sureName,
    this.country,
    this.city,
    this.zipCode,
    this.emailAddress,
    this.slug,
    this.sLink,
    this.createdAt,
    this.updatedAt,
  });

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json['_id'],
    userId: json['userId'],
    bio: json['bio'],
    banner: json['banner'],
    photo: json['photo'],
    title: json['title'],
    firstName: json['firstName'],
    sureName: json['sureName'],
    country: json['country'],
    city: json['city'],
    zipCode: json['zipCode'],
    emailAddress: json['emailAddress'],
    slug: json['slug'],
    sLink: json['sLink'] != null ? List<SocialLink>.from(json['sLink'].map((x) => SocialLink.fromJson(x))) : [],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userId,
    'bio': bio,
    'banner': banner,
    'photo': photo,
    'title': title,
    'firstName': firstName,
    'sureName': sureName,
    'country': country,
    'city': city,
    'zipCode': zipCode,
    'emailAddress': emailAddress,
    'slug': slug,
    'sLink': sLink?.map((x) => x.toJson()).toList(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class SocialLink {
  String? label;
  String? url;
  String? id;
  SocialLink({this.label, this.url, this.id});
  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
    label: json['label'],
    url: json['url'],
    id: json['_id'],
  );
  Map<String, dynamic> toJson() => {'label': label, 'url': url, '_id': id};
}

class ApplicationRequirement {
  String? requirement;
  String? status;
  String? id;
  ApplicationRequirement({this.requirement, this.status, this.id});
  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) => ApplicationRequirement(
    requirement: json['requirement'],
    status: json['status'],
    id: json['_id'],
  );
  Map<String, dynamic> toJson() => {'requirement': requirement, 'status': status, '_id': id};
}

class CustomQuestion {
  String? question;
  String? id;
  CustomQuestion({this.question, this.id});
  factory CustomQuestion.fromJson(Map<String, dynamic> json) => CustomQuestion(
    question: json['question'],
    id: json['_id'],
  );
  Map<String, dynamic> toJson() => {'question': question, '_id': id};
}
