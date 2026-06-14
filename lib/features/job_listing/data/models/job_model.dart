import 'company_model.dart';
import 'recruiter_model.dart';

class JobModel {
  final String id;
  final String userId;
  final CompanyModel? companyId;
  final RecruiterModel? recruiterId;
  final String title;
  final String description;
  final String salaryRange;
  final String location;
  final String shift;
  final List<dynamic> responsibilities;
  final List<dynamic> educationExperience;
  final List<dynamic> benefits;
  final int vacancy;
  final String experience;
  final DateTime? deadline;
  final String status;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final bool arcrivedJob;
  final List<ApplicationRequirementModel> applicationRequirement;
  final List<CustomQuestionModel> customQuestion;
  final String jobApprove;
  final bool adminApprove;
  final DateTime? publishDate;
  final String employementType;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobModel({
    required this.id,
    required this.userId,
    this.companyId,
    this.recruiterId,
    required this.title,
    required this.description,
    required this.salaryRange,
    required this.location,
    required this.shift,
    required this.responsibilities,
    required this.educationExperience,
    required this.benefits,
    required this.vacancy,
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      userId: json['userId'] is Map<String, dynamic>
          ? (json['userId']['_id'] ?? '')
          : (json['userId'] ?? ''),
      companyId: json['companyId'] is Map<String, dynamic>
          ? CompanyModel.fromJson(json['companyId'] as Map<String, dynamic>)
          : null,
      recruiterId: json['recruiterId'] is Map<String, dynamic>
          ? RecruiterModel.fromJson(json['recruiterId'] as Map<String, dynamic>)
          : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      salaryRange: json['salaryRange'] ?? '',
      location: json['location'] ?? '',
      shift: json['shift'] ?? '',
      responsibilities: json['responsibilities'] ?? [],
      educationExperience: json['educationExperience'] ?? [],
      benefits: json['benefits'] ?? [],
      vacancy: json['vacancy'] ?? 0,
      experience: json['experience'] ?? '',
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'])
          : null,
      status: json['status'] ?? '',
      jobCategoryId: json['jobCategoryId'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      compensation: json['compensation'] ?? '',
      arcrivedJob: json['arcrivedJob'] ?? false,
      applicationRequirement:
          (json['applicationRequirement'] as List<dynamic>?)
              ?.map(
                (e) => ApplicationRequirementModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      customQuestion:
          (json['customQuestion'] as List<dynamic>?)
              ?.map(
                (e) => CustomQuestionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      jobApprove: json['jobApprove'] ?? '',
      adminApprove: json['adminApprove'] ?? false,
      publishDate: json['publishDate'] != null
          ? DateTime.tryParse(json['publishDate'])
          : null,
      employementType: json['employement_Type'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'companyId': companyId?.toJson(),
      'recruiterId': recruiterId?.toJson(),
      'title': title,
      'description': description,
      'salaryRange': salaryRange,
      'location': location,
      'shift': shift,
      'responsibilities': responsibilities,
      'educationExperience': educationExperience,
      'benefits': benefits,
      'vacancy': vacancy,
      'experience': experience,
      'deadline': deadline?.toIso8601String(),
      'status': status,
      'jobCategoryId': jobCategoryId,
      'name': name,
      'role': role,
      'compensation': compensation,
      'arcrivedJob': arcrivedJob,
      'applicationRequirement': applicationRequirement
          .map((e) => e.toJson())
          .toList(),
      'customQuestion': customQuestion.map((e) => e.toJson()).toList(),
      'jobApprove': jobApprove,
      'adminApprove': adminApprove,
      'publishDate': publishDate?.toIso8601String(),
      'employement_Type': employementType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to convert to map for existing UI
  Map<String, dynamic> toDisplayMap() {
    // Determine if job is from company or recruiter and get appropriate logo
    String? logoUrl;
    if (companyId != null) {
      logoUrl = companyId!.clogo;
    } else if (recruiterId != null) {
      logoUrl = recruiterId!.photo;
    }

    return {
      'id': id,
      'title': title,
      'company': companyId?.cname ?? recruiterId?.fullName ?? 'Unknown Company',
      'postedBySlug': companyId?.slug ?? recruiterId?.slug ?? '',
      'postedByType': companyId != null ? 'company' : 'recruiter',
      'location': location,
      'duration': employementType.replaceAll('-', ' ').toUpperCase(),
      'salary': salaryRange,
      'timePosted': _calculateTimePosted(),
      'type': employementType,
      'datePosted': publishDate ?? createdAt,
      'logoUrl': logoUrl,
      'raw': toJson(),
    };
  }

  String get timePostedFormatted => _calculateTimePosted();

  String _calculateTimePosted() {
    final date = publishDate ?? createdAt;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

class ApplicationRequirementModel {
  final String requirement;
  final String status;
  final String id;

  ApplicationRequirementModel({
    required this.requirement,
    required this.status,
    required this.id,
  });

  factory ApplicationRequirementModel.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirementModel(
      requirement: json['requirement'] ?? '',
      status: json['status'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'requirement': requirement, 'status': status, '_id': id};
  }
}

class CustomQuestionModel {
  final String question;
  final String id;

  CustomQuestionModel({required this.question, required this.id});

  factory CustomQuestionModel.fromJson(Map<String, dynamic> json) {
    return CustomQuestionModel(
      question: json['question'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'question': question, '_id': id};
  }
}
