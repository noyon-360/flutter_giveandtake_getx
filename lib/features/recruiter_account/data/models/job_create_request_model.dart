import 'package:giveandtake/core/contracts/web/job_contract.dart';

class JobPostRequestModel {
  JobPostRequestModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.vacancy,
    required this.experience,
    required this.expirationDateDays,
    required this.jobCategoryId,
    required this.name,
    required this.role,
    required this.compensation,
    required this.applicationRequirement,
    required this.customQuestion,
    required this.employementType,
    required this.publishDate,
    required this.careerStage,
    required this.locationType,
    this.websiteUrl,
    this.salaryRange,
    this.shift,
    this.responsibilities = const <String>[],
    this.educationExperience = const <String>[],
    this.benefits = const <String>[],
    this.status = 'active',
    this.archivedJob = false,
    this.companyId,
  });

  final String userId;
  final String title;
  final String description;
  final String location;
  final int vacancy;
  final String experience;
  final String expirationDateDays;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final List<ApplicationRequirement> applicationRequirement;
  final List<CustomQuestion> customQuestion;
  final String employementType;
  final String publishDate;
  final String careerStage;
  final String locationType;
  final String? websiteUrl;
  final String? salaryRange;
  final String? shift;
  final List<String> responsibilities;
  final List<String> educationExperience;
  final List<String> benefits;
  final String status;
  final bool archivedJob;
  final String? companyId;

  Map<String, dynamic> toJson() {
    return JobPayloadBuilder.build(
      JobContractInput(
        userId: userId,
        companyId: companyId,
        title: title,
        description: description,
        location: location,
        vacancy: vacancy,
        experience: experience,
        jobCategoryId: jobCategoryId,
        name: name,
        role: role,
        compensation: compensation,
        employementType: employementType,
        publishDate: publishDate,
        careerStage: careerStage,
        locationType: locationType,
        expirationDateDays: expirationDateDays,
        applicationRequirement: applicationRequirement
            .map(
              (item) => JobRequirementInput(
                requirement: item.requirement,
                status: item.status,
              ),
            )
            .toList(),
        customQuestion: customQuestion
            .map((item) => JobQuestionInput(question: item.question))
            .toList(),
        status: status,
        archivedJob: archivedJob,
        websiteUrl: websiteUrl,
        salaryRange: salaryRange,
        shift: shift,
        responsibilities: responsibilities,
        educationExperience: educationExperience,
        benefits: benefits,
      ),
    );
  }
}

class ApplicationRequirement {
  ApplicationRequirement({
    required this.requirement,
    required this.status,
  });

  final String requirement;
  final String status;

  Map<String, dynamic> toJson() => {
    'requirement': requirement,
    'status': status,
  };

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirement(
      requirement: json['requirement'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class CustomQuestion {
  CustomQuestion({required this.question});

  final String question;

  Map<String, dynamic> toJson() => {
    'question': question,
  };

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      question: json['question'] ?? '',
    );
  }
}
