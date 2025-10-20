class ApplicationModel {
  final String id;
  final String jobTitle;
  final String companyName;
  final String appliedDate;
  final String status;
  final Map<String, dynamic> raw;

  ApplicationModel({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.appliedDate,
    required this.status,
    required this.raw,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    final job = json['job'] as Map<String, dynamic>?;
    final company = json['company'] as Map<String, dynamic>?;
    return ApplicationModel(
      id: json['_id'] ?? json['id'] ?? '',
      jobTitle: job != null ? (job['title'] ?? '') : (json['title'] ?? ''),
      companyName: company != null ? (company['name'] ?? '') : (json['companyName'] ?? ''),
      appliedDate: json['appliedAt'] ?? json['appliedDate'] ?? '',
      status: json['status'] ?? '',
      raw: Map<String, dynamic>.from(json),
    );
  }
}

class CreateResumeModel {
  final String id;
  final String userId;
  final String photo;
  final String banner;
  final String aboutUs;
  final String title;
  final String firstName;
  final String lastName;
  final String country;
  final String city;
  final String email;
  final List<String> skills;

  CreateResumeModel({
    required this.id,
    required this.userId,
    required this.photo,
    required this.banner,
    required this.aboutUs,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.city,
    required this.email,
    required this.skills,
  });

  factory CreateResumeModel.fromJson(Map<String, dynamic> json) {
    return CreateResumeModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      photo: json['photo'] ?? '',
      banner: json['banner'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
      title: json['title'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      email: json['email'] ?? '',
      skills: (json['skills'] as List?)?.map((e) => '$e').toList() ?? [],
    );
  }
}

class AppliedJobsResponseModel {
  final List<ApplicationModel> applications;
  final CreateResumeModel? createResume;

  AppliedJobsResponseModel({required this.applications, this.createResume});

  factory AppliedJobsResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AppliedJobsResponseModel(applications: []);
    final apps = (json['applications'] as List?)?.map((e) {
      return ApplicationModel.fromJson(Map<String, dynamic>.from(e as Map));
    }).toList(growable: false) ?? <ApplicationModel>[];

    final resume = json['createResume'] != null
        ? CreateResumeModel.fromJson(Map<String, dynamic>.from(json['createResume'] as Map))
        : null;

    return AppliedJobsResponseModel(applications: apps, createResume: resume);
  }
}
