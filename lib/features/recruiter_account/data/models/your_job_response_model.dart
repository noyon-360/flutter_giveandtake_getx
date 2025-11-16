// class YourJobResponse {
//   final String id;
//   final String userId;
//   final String recruiterId;
//   final String title;
//   final String description;
//   final String? salaryRange;
//   final String location;
//   final String? shift;
//   final String? responsibilities;
//   final String? educationExperience;
//   final String? benefits;
//   final int vacancy;
//   final String experience;
//   final String deadline;
//   final String? status;
//   final String jobCategoryId;
//   final String name;
//   final String role;
//   final String compensation;
//   final bool arcrivedJob;
//   final List<ApplicationRequirement> applicationRequirement;
//   final List<CustomQuestion> customQuestion;
//   final String jobApprove;
//   final bool adminApprove;
//   final String publishDate;
//   final String employementType;
//   final String locationType;
//   final String careerStage;
//   final String websiteUrl;
//   final String createdAt;
//   final String updatedAt;
//   final int v;
//   final int applicantCount;
//   final String derivedStatus;
//
//   YourJobResponse({
//     required this.id,
//     required this.userId,
//     required this.recruiterId,
//     required this.title,
//     required this.description,
//     this.salaryRange,
//     required this.location,
//     this.shift,
//     this.responsibilities,
//     this.educationExperience,
//     this.benefits,
//     required this.vacancy,
//     required this.experience,
//     required this.deadline,
//     this.status,
//     required this.jobCategoryId,
//     required this.name,
//     required this.role,
//     required this.compensation,
//     required this.arcrivedJob,
//     required this.applicationRequirement,
//     required this.customQuestion,
//     required this.jobApprove,
//     required this.adminApprove,
//     required this.publishDate,
//     required this.employementType,
//     required this.locationType,
//     required this.careerStage,
//     required this.websiteUrl,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.applicantCount,
//     required this.derivedStatus,
//   });
//
//   factory YourJobResponse.fromJson(Map<String, dynamic> json) {
//     return YourJobResponse(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       recruiterId: json['recruiterId'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       salaryRange: json['salaryRange'],
//       location: json['location'] ?? '',
//       shift: json['shift'],
//       responsibilities: json['responsibilities'],
//       educationExperience: json['educationExperience'],
//       benefits: json['benefits'],
//       vacancy: json['vacancy'] ?? 0,
//       experience: json['experience'] ?? '',
//       deadline: json['deadline'] ?? '',
//       status: json['status'],
//       jobCategoryId: json['jobCategoryId'] ?? '',
//       name: json['name'] ?? '',
//       role: json['role'] ?? '',
//       compensation: json['compensation'] ?? '',
//       arcrivedJob: json['arcrivedJob'] ?? false,
//       applicationRequirement: (json['applicationRequirement'] as List<dynamic>?)
//           ?.map((e) => ApplicationRequirement.fromJson(e))
//           .toList() ??
//           [],
//       customQuestion: (json['customQuestion'] as List<dynamic>?)
//           ?.map((e) => CustomQuestion.fromJson(e))
//           .toList() ??
//           [],
//       jobApprove: json['jobApprove'] ?? '',
//       adminApprove: json['adminApprove'] ?? false,
//       publishDate: json['publishDate'] ?? '',
//       employementType: json['employement_Type'] ?? '',
//       locationType: json['location_Type'] ?? '',
//       careerStage: json['career_Stage'] ?? '',
//       websiteUrl: json['website_Url'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       v: json['__v'] ?? 0,
//       applicantCount: json['applicantCount'] ?? 0,
//       derivedStatus: json['derivedStatus'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       'recruiterId': recruiterId,
//       'title': title,
//       'description': description,
//       'salaryRange': salaryRange,
//       'location': location,
//       'shift': shift,
//       'responsibilities': responsibilities,
//       'educationExperience': educationExperience,
//       'benefits': benefits,
//       'vacancy': vacancy,
//       'experience': experience,
//       'deadline': deadline,
//       'status': status,
//       'jobCategoryId': jobCategoryId,
//       'name': name,
//       'role': role,
//       'compensation': compensation,
//       'arcrivedJob': arcrivedJob,
//       'applicationRequirement': applicationRequirement.map((e) => e.toJson()).toList(),
//       'customQuestion': customQuestion.map((e) => e.toJson()).toList(),
//       'jobApprove': jobApprove,
//       'adminApprove': adminApprove,
//       'publishDate': publishDate,
//       'employement_Type': employementType,
//       'location_Type': locationType,
//       'career_Stage': careerStage,
//       'website_Url': websiteUrl,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       '__v': v,
//       'applicantCount': applicantCount,
//       'derivedStatus': derivedStatus,
//     };
//   }
// }
//
// class ApplicationRequirement {
//   final String requirement;
//   final String status;
//   final String id;
//
//   ApplicationRequirement({
//     required this.requirement,
//     required this.status,
//     required this.id,
//   });
//
//   factory ApplicationRequirement.fromJson(Map<String, dynamic> json) {
//     return ApplicationRequirement(
//       requirement: json['requirement'] ?? '',
//       status: json['status'] ?? '',
//       id: json['_id'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'requirement': requirement,
//       'status': status,
//       '_id': id,
//     };
//   }
// }
//
// class CustomQuestion {
//   final String question;
//   final String id;
//
//   CustomQuestion({
//     required this.question,
//     required this.id,
//   });
//
//   factory CustomQuestion.fromJson(Map<String, dynamic> json) {
//     return CustomQuestion(
//       question: json['question'] ?? '',
//       id: json['_id'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'question': question,
//       '_id': id,
//     };
//   }
// }
