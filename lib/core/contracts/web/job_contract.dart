import 'web_contract_utils.dart';

class JobRequirementInput {
  const JobRequirementInput({
    required this.requirement,
    required this.status,
  });

  final String requirement;
  final String status;

  Map<String, dynamic> toJson() => {
    'requirement': requirement,
    'status': status,
  };
}

class JobQuestionInput {
  const JobQuestionInput({required this.question});

  final String question;

  Map<String, dynamic> toJson() => {
    'question': question,
  };
}

class JobContractInput {
  const JobContractInput({
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.vacancy,
    required this.experience,
    required this.jobCategoryId,
    required this.name,
    required this.role,
    required this.compensation,
    required this.employementType,
    required this.publishDate,
    required this.careerStage,
    required this.locationType,
    required this.expirationDateDays,
    required this.applicationRequirement,
    required this.customQuestion,
    this.status = 'active',
    this.archivedJob = false,
    this.websiteUrl,
    this.companyId,
    this.salaryRange,
    this.shift,
    this.responsibilities = const <String>[],
    this.educationExperience = const <String>[],
    this.benefits = const <String>[],
  });

  final String userId;
  final String title;
  final String description;
  final String location;
  final int vacancy;
  final String experience;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final String employementType;
  final String publishDate;
  final String careerStage;
  final String locationType;
  final String expirationDateDays;
  final List<JobRequirementInput> applicationRequirement;
  final List<JobQuestionInput> customQuestion;
  final String status;
  final bool archivedJob;
  final String? websiteUrl;
  final String? companyId;
  final String? salaryRange;
  final String? shift;
  final List<String> responsibilities;
  final List<String> educationExperience;
  final List<String> benefits;
}

class JobPayloadBuilder {
  static const String validVisaLabel =
      'Have you got a valid visa for this location?';

  static Map<String, dynamic> build(JobContractInput input) {
    final publishDate = _normalizePublishDate(input.publishDate);
    final expirationDays = _normalizeExpirationDays(input.expirationDateDays);
    final expiryDate = _computeExpiryDate(publishDate, expirationDays);

    final applicationRequirement = input.applicationRequirement
        .where((requirement) => requirement.status.trim().isNotEmpty)
        .map((requirement) => requirement.toJson())
        .toList();

    final customQuestion = input.customQuestion
        .where((question) => question.question.trim().isNotEmpty)
        .map((question) => question.toJson())
        .toList();

    return {
      'userId': input.userId,
      if (nullIfBlank(input.companyId) != null) 'companyId': input.companyId,
      'title': input.title.trim(),
      'description': input.description.trim(),
      'salaryRange': nullIfBlank(input.salaryRange) ?? 'Negotiable',
      'location': input.location.trim(),
      'shift': nullIfBlank(input.shift) ??
          (input.employementType == 'full-time' ? 'Day' : 'Flexible'),
      'responsibilities': input.responsibilities,
      'educationExperience': input.educationExperience,
      'benefits': input.benefits,
      'vacancy': input.vacancy,
      'experience': input.experience.trim(),
      'deadline': expiryDate,
      'expiryDate': expiryDate,
      'expirationDate': expirationDays,
      'status': input.status,
      'jobCategoryId': input.jobCategoryId,
      'name': input.name,
      'role': input.role,
      'compensation': input.compensation,
      'archivedJob': input.archivedJob,
      'applicationRequirement': applicationRequirement,
      'customQuestion': customQuestion,
      'employement_Type': input.employementType,
      'website_Url': nullIfBlank(input.websiteUrl),
      'publishDate': publishDate,
      'career_Stage': input.careerStage,
      'location_Type': input.locationType,
    };
  }

  static String _normalizePublishDate(String publishDate) {
    final parsed = DateTime.tryParse(publishDate);
    return (parsed ?? DateTime.now().toUtc()).toUtc().toIso8601String();
  }

  static String _normalizeExpirationDays(String value) {
    final numberMatch = RegExp(r'(\d+)').firstMatch(value);
    final days = int.tryParse(numberMatch?.group(1) ?? '') ?? 30;
    return days.toString();
  }

  static String _computeExpiryDate(String publishDate, String expirationDays) {
    final base = DateTime.tryParse(publishDate)?.toUtc() ?? DateTime.now().toUtc();
    final days = int.tryParse(expirationDays) ?? 30;
    return base.add(Duration(days: days)).toIso8601String();
  }
}
