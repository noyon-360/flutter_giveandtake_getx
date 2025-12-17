// // applicant_response_model.dart

// class ApplicantListResponseModel {
//   final String id;
//   final String jobId;
//   final User user;
//   final String status;
//   final List<Answer> answer;
//   final ResumeId resumeId;
//   final String createdAt;
//   final String updatedAt;
//   final Resume resume;

//   ApplicantListResponseModel({
//     required this.id,
//     required this.jobId,
//     required this.user,
//     required this.status,
//     required this.answer,
//     required this.resumeId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.resume,
//   });

//   factory ApplicantListResponseModel.fromJson(Map<String, dynamic> json) {
//     return ApplicantListResponseModel(
//       id: json["_id"],
//       jobId: json["jobId"],
//       user: User.fromJson(json["userId"]),
//       status: json["status"],
//       answer: (json["answer"] as List)
//           .map((e) => Answer.fromJson(e))
//           .toList(),
//       resumeId: ResumeId.fromJson(json["resumeId"]),
//       createdAt: json["createdAt"],
//       updatedAt: json["updatedAt"],
//       resume: Resume.fromJson(json["resume"]),
//     );
//   }
// }

// // ---------------- USER ----------------

// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String slug;
//   final String avatarUrl;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.slug,
//     required this.avatarUrl,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json["_id"],
//       name: json["name"] ?? "",
//       email: json["email"] ?? "",
//       slug: json["slug"] ?? "",
//       avatarUrl: json["avatar"]?["url"] ?? "",
//     );
//   }
// }

// // ---------------- ANSWERS ----------------

// class Answer {
//   final String question;
//   final String ans;
//   final String id;

//   Answer({
//     required this.question,
//     required this.ans,
//     required this.id,
//   });

//   factory Answer.fromJson(Map<String, dynamic> json) {
//     return Answer(
//       question: json["question"] ?? "",
//       ans: json["ans"] ?? "",
//       id: json["_id"],
//     );
//   }
// }

// // ---------------- RESUME FILE ----------------

// class ResumeFile {
//   final String filename;
//   final String url;
//   final String uploadedAt;
//   final String id;

//   ResumeFile({
//     required this.filename,
//     required this.url,
//     required this.uploadedAt,
//     required this.id,
//   });

//   factory ResumeFile.fromJson(Map<String, dynamic> json) {
//     return ResumeFile(
//       filename: json["filename"],
//       url: json["url"],
//       uploadedAt: json["uploadedAt"],
//       id: json["_id"],
//     );
//   }
// }

// // ---------------- RESUME ID ----------------

// class ResumeId {
//   final String id;
//   final String userId;
//   final List<ResumeFile> file;
//   final String uploadDate;

//   ResumeId({
//     required this.id,
//     required this.userId,
//     required this.file,
//     required this.uploadDate,
//   });

//   factory ResumeId.fromJson(Map<String, dynamic> json) {
//     return ResumeId(
//       id: json["_id"],
//       userId: json["userId"],
//       file: (json["file"] as List)
//           .map((e) => ResumeFile.fromJson(e))
//           .toList(),
//       uploadDate: json["uploadDate"],
//     );
//   }
// }

// // ---------------- FULL RESUME PROFILE ----------------

// class Resume {
//   final String id;
//   final String userId;
//   final String photo;
//   final String banner;
//   final String aboutUs;
//   final String title;
//   final String firstName;
//   final String lastName;
//   final String country;
//   final String city;
//   final String email;
//   final List<String> certifications;
//   final List<String> languages;
//   final List<dynamic> sLink;
//   final List<String> skills;
//   final bool immediatelyAvailable;
//   final String createdAt;
//   final String updatedAt;
//   final String type;
//   final String zipCode;

//   Resume({
//     required this.id,
//     required this.userId,
//     required this.photo,
//     required this.banner,
//     required this.aboutUs,
//     required this.title,
//     required this.firstName,
//     required this.lastName,
//     required this.country,
//     required this.city,
//     required this.email,
//     required this.certifications,
//     required this.languages,
//     required this.sLink,
//     required this.skills,
//     required this.immediatelyAvailable,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.type,
//     required this.zipCode,
//   });

//   factory Resume.fromJson(Map<String, dynamic> json) {
//     return Resume(
//       id: json["_id"],
//       userId: json["userId"],
//       photo: json["photo"] ?? "",
//       banner: json["banner"] ?? "",
//       aboutUs: json["aboutUs"] ?? "",
//       title: json["title"] ?? "",
//       firstName: json["firstName"] ?? "",
//       lastName: json["lastName"] ?? "",
//       country: json["country"] ?? "",
//       city: json["city"] ?? "",
//       email: json["email"] ?? "",
//       certifications: List<String>.from(json["certifications"]),
//       languages: List<String>.from(json["languages"]),
//       sLink: json["sLink"],
//       skills: List<String>.from(json["skills"]),
//       immediatelyAvailable: json["immediatelyAvailable"] ?? false,
//       createdAt: json["createdAt"] ?? "",
//       updatedAt: json["updatedAt"] ?? "",
//       type: json["type"] ?? "",
//       zipCode: json["zipCode"] ?? "",
//     );
//   }
// }


class ApplicantListResponseModel {
  final String id;
  final String jobId;
  final User user;
  final String status;
  final List<Answer> answer;
  final ResumeId? resumeId;   // nullable
  final String createdAt;
  final String updatedAt;
  final Resume? resume;       // nullable

  ApplicantListResponseModel({
    required this.id,
    required this.jobId,
    required this.user,
    required this.status,
    required this.answer,
    required this.resumeId,
    required this.createdAt,
    required this.updatedAt,
    required this.resume,
  });

  factory ApplicantListResponseModel.fromJson(Map<String, dynamic> json) {
    return ApplicantListResponseModel(
      id: json["_id"] ?? "",
      jobId: json["jobId"]?.toString() ?? "",
      user: User.fromJson(json["userId"] ?? {}),
      status: json["status"] ?? "",
      answer: (json["answer"] as List?)
              ?.map((e) => Answer.fromJson(e))
              .toList() 
              ?? [],
      resumeId: json["resumeId"] == null
          ? null
          : ResumeId.fromJson(json["resumeId"]),
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      resume: json["resume"] == null
          ? null
          : Resume.fromJson(json["resume"]),
    );
  }
}
class User {
  final String id;
  final String name;
  final String email;
  final String slug;
  final String avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.slug,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      slug: json["slug"] ?? "",
      avatarUrl: json["avatar"]?["url"] ?? "",
    );
  }
}
class Answer {
  final String? question;   // nullable
  final String? ans;        // nullable
  final String id;

  Answer({
    this.question,
    this.ans,
    required this.id,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      question: json["question"],
      ans: json["ans"],
      id: json["_id"] ?? "",
    );
  }
}
class ResumeFile {
  final String filename;
  final String url;
  final String uploadedAt;
  final String id;

  ResumeFile({
    required this.filename,
    required this.url,
    required this.uploadedAt,
    required this.id,
  });

  factory ResumeFile.fromJson(Map<String, dynamic> json) {
    return ResumeFile(
      filename: json["filename"] ?? "",
      url: json["url"] ?? "",
      uploadedAt: json["uploadedAt"] ?? "",
      id: json["_id"] ?? "",
    );
  }
}
class ResumeId {
  final String id;
  final String userId;
  final List<ResumeFile> file;
  final String uploadDate;

  ResumeId({
    required this.id,
    required this.userId,
    required this.file,
    required this.uploadDate,
  });

  factory ResumeId.fromJson(Map<String, dynamic> json) {
    return ResumeId(
      id: json["_id"] ?? "",
      userId: json["userId"]?.toString() ?? "",
      file: (json["file"] as List?)
              ?.map((e) => ResumeFile.fromJson(e))
              .toList()
              ?? [],
      uploadDate: json["uploadDate"] ?? "",
    );
  }
}
class Resume {
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
  final List<String> certifications;
  final List<String> languages;
  final List<dynamic> sLink;
  final List<String> skills;
  final bool immediatelyAvailable;
  final String createdAt;
  final String updatedAt;
  final String type;
  final String zipCode;

  Resume({
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
    required this.certifications,
    required this.languages,
    required this.sLink,
    required this.skills,
    required this.immediatelyAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.zipCode,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json["_id"] ?? "",
      userId: json["userId"]?.toString() ?? "",
      photo: json["photo"] ?? "",
      banner: json["banner"] ?? "",
      aboutUs: json["aboutUs"] ?? "",
      title: json["title"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      country: json["country"] ?? "",
      city: json["city"] ?? "",
      email: json["email"] ?? "",
      certifications: (json["certifications"] as List?)
              ?.map((e) => e.toString())
              .toList()
              ?? [],
      languages: (json["languages"] as List?)
              ?.map((e) => e.toString())
              .toList()
              ?? [],
      sLink: json["sLink"] ?? [],
      skills: (json["skills"] as List?)
              ?.map((e) => e.toString())
              .toList()
              ?? [],
      immediatelyAvailable: json["immediatelyAvailable"] ?? false,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      type: json["type"] ?? "",
      zipCode: json["zipCode"] ?? "",
    );
  }
}
