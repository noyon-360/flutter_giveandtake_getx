// class GetResumePublicViewResponseModel {
//   final bool? deactivate;
//   final Resume? resume;
//   final List<Experience>? experiences;
//   final List<Education>? education;
//   final List<Award>? awardsAndHonors;
//   final List<ElevatorPitch>? elevatorPitch;

//   GetResumePublicViewResponseModel({
//     this.deactivate,
//     this.resume,
//     this.experiences,
//     this.education,
//     this.awardsAndHonors,
//     this.elevatorPitch,
//   });

//   factory GetResumePublicViewResponseModel.fromJson(Map<String, dynamic> json) {
//     return GetResumePublicViewResponseModel(
//       deactivate: json['deactivate'],
//       resume: json['resume'] != null
//           ? Resume.fromJson(json['resume'])
//           : null,
//       experiences: json['experiences'] != null
//           ? List<Experience>.from(
//               json['experiences'].map((x) => Experience.fromJson(x)))
//           : [],
//       education: json['education'] != null
//           ? List<Education>.from(
//               json['education'].map((x) => Education.fromJson(x)))
//           : [],
//       awardsAndHonors: json['awardsAndHonors'] != null
//           ? List<Award>.from(
//               json['awardsAndHonors'].map((x) => Award.fromJson(x)))
//           : [],
//       elevatorPitch: json['elevatorPitch'] != null
//           ? List<ElevatorPitch>.from(
//               json['elevatorPitch'].map((x) => ElevatorPitch.fromJson(x)))
//           : [],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "deactivate": deactivate,
//         "resume": resume?.toJson(),
//         "experiences": experiences?.map((e) => e.toJson()).toList(),
//         "education": education?.map((e) => e.toJson()).toList(),
//         "awardsAndHonors":
//             awardsAndHonors?.map((e) => e.toJson()).toList(),
//         "elevatorPitch":
//             elevatorPitch?.map((e) => e.toJson()).toList(),
//       };
// }
// class Resume {
//   final String? id;
//   final String? userId;
//   final String? type;
//   final String? photo;
//   final String? banner;
//   final String? firstName;
//   final String? lastName;
//   final String? country;
//   final String? city;
//   final String? email;
//   final List<String>? certifications;
//   final List<String>? languages;
//   final List<String>? sLink;
//   final List<String>? skills;
//   final bool? immediatelyAvailable;
//   final String? aboutUs;
//   final String? title;
//   final String? zipCode;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   Resume({
//     this.id,
//     this.userId,
//     this.type,
//     this.photo,
//     this.banner,
//     this.firstName,
//     this.lastName,
//     this.country,
//     this.city,
//     this.email,
//     this.certifications,
//     this.languages,
//     this.sLink,
//     this.skills,
//     this.immediatelyAvailable,
//     this.aboutUs,
//     this.title,
//     this.zipCode,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory Resume.fromJson(Map<String, dynamic> json) {
//     return Resume(
//       id: json['_id'],
//       userId: json['userId'],
//       type: json['type'],
//       photo: json['photo'],
//       banner: json['banner'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       country: json['country'],
//       city: json['city'],
//       email: json['email'],
//       certifications: json['certifications'] != null
//           ? List<String>.from(json['certifications'])
//           : [],
//       languages: json['languages'] != null
//           ? List<String>.from(json['languages'])
//           : [],
//       sLink: json['sLink'] != null
//           ? List<String>.from(json['sLink'])
//           : [],
//       skills: json['skills'] != null
//           ? List<String>.from(json['skills'])
//           : [],
//       immediatelyAvailable: json['immediatelyAvailable'],
//       aboutUs: json['aboutUs'],
//       title: json['title'],
//       zipCode: json['zipCode'],
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userId": userId,
//         "type": type,
//         "photo": photo,
//         "banner": banner,
//         "firstName": firstName,
//         "lastName": lastName,
//         "country": country,
//         "city": city,
//         "email": email,
//         "certifications": certifications,
//         "languages": languages,
//         "sLink": sLink,
//         "skills": skills,
//         "immediatelyAvailable": immediatelyAvailable,
//         "aboutUs": aboutUs,
//         "title": title,
//         "zipCode": zipCode,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//       };
// }
// class Experience {
//   final String? id;
//   final String? company;
//   final String? position;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final String? country;
//   final String? city;
//   final String? jobCategory;
//   final String? jobDescription;
//   final String? zip;

//   Experience({
//     this.id,
//     this.company,
//     this.position,
//     this.startDate,
//     this.endDate,
//     this.country,
//     this.city,
//     this.jobCategory,
//     this.jobDescription,
//     this.zip,
//   });

//   factory Experience.fromJson(Map<String, dynamic> json) {
//     return Experience(
//       id: json['_id'],
//       company: json['company'],
//       position: json['position'],
//       startDate: json['startDate'] != null
//           ? DateTime.parse(json['startDate'])
//           : null,
//       endDate: json['endDate'] != null
//           ? DateTime.parse(json['endDate'])
//           : null,
//       country: json['country'],
//       city: json['city'],
//       jobCategory: json['jobCategory'],
//       jobDescription: json['jobDescription'],
//       zip: json['zip'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "company": company,
//         "position": position,
//         "startDate": startDate?.toIso8601String(),
//         "endDate": endDate?.toIso8601String(),
//         "country": country,
//         "city": city,
//         "jobCategory": jobCategory,
//         "jobDescription": jobDescription,
//         "zip": zip,
//       };
// }
// class Education {
//   final String? id;
//   final String? city;
//   final String? country;
//   final String? degree;
//   final String? fieldOfStudy;
//   final DateTime? startDate;
//   final DateTime? graduationDate;
//   final String? instituteName;

//   Education({
//     this.id,
//     this.city,
//     this.country,
//     this.degree,
//     this.fieldOfStudy,
//     this.startDate,
//     this.graduationDate,
//     this.instituteName,
//   });

//   factory Education.fromJson(Map<String, dynamic> json) {
//     return Education(
//       id: json['_id'],
//       city: json['city'],
//       country: json['country'],
//       degree: json['degree'],
//       fieldOfStudy: json['fieldOfStudy'],
//       startDate: json['startDate'] != null
//           ? DateTime.parse(json['startDate'])
//           : null,
//       graduationDate: json['graduationDate'] != null
//           ? DateTime.parse(json['graduationDate'])
//           : null,
//       instituteName: json['instituteName'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "city": city,
//         "country": country,
//         "degree": degree,
//         "fieldOfStudy": fieldOfStudy,
//         "startDate": startDate?.toIso8601String(),
//         "graduationDate": graduationDate?.toIso8601String(),
//         "instituteName": instituteName,
//       };
// }
// class Award {
//   final String? id;
//   final String? title;
//   final String? description;
//   final String? programeName;
//   final DateTime? programeDate;

//   Award({
//     this.id,
//     this.title,
//     this.description,
//     this.programeName,
//     this.programeDate,
//   });

//   factory Award.fromJson(Map<String, dynamic> json) {
//     return Award(
//       id: json['_id'],
//       title: json['title'],
//       description: json['description'],
//       programeName: json['programeName'],
//       programeDate: json['programeDate'] != null
//           ? DateTime.parse(json['programeDate'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "description": description,
//         "programeName": programeName,
//         "programeDate": programeDate?.toIso8601String(),
//       };
// }
// class ElevatorPitch {
//   final String? id;
//   final String? status;
//   final Video? video;

//   ElevatorPitch({
//     this.id,
//     this.status,
//     this.video,
//   });

//   factory ElevatorPitch.fromJson(Map<String, dynamic> json) {
//     return ElevatorPitch(
//       id: json['_id'],
//       status: json['status'],
//       video: json['video'] != null
//           ? Video.fromJson(json['video'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "status": status,
//         "video": video?.toJson(),
//       };
// }

// class Video {
//   final String? url;
//   final String? hlsUrl;
//   final String? encryptionKeyUrl;

//   Video({
//     this.url,
//     this.hlsUrl,
//     this.encryptionKeyUrl,
//   });

//   factory Video.fromJson(Map<String, dynamic> json) {
//     return Video(
//       url: json['url'],
//       hlsUrl: json['hlsUrl'],
//       encryptionKeyUrl: json['encryptionKeyUrl'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "url": url,
//         "hlsUrl": hlsUrl,
//         "encryptionKeyUrl": encryptionKeyUrl,
//       };
// }

class GetResumePublicViewResponseModel {
  final bool? deactivate;
  final Resume? resume;
  final List<Experience> experiences;
  final List<Education> education;
  final List<Award> awardsAndHonors;
  final List<ElevatorPitch> elevatorPitch;

  GetResumePublicViewResponseModel({
    this.deactivate,
    this.resume,
    required this.experiences,
    required this.education,
    required this.awardsAndHonors,
    required this.elevatorPitch,
  });

  factory GetResumePublicViewResponseModel.fromJson(Map<String, dynamic> json) {
    return GetResumePublicViewResponseModel(
      deactivate: json['deactivate'],
      resume: json['resume'] is Map<String, dynamic>
          ? Resume.fromJson(json['resume'])
          : null,
      experiences:
          (json['experiences'] as List?)
              ?.map((x) => Experience.fromJson(x))
              .toList() ??
          [],
      education:
          (json['education'] as List?)
              ?.map((x) => Education.fromJson(x))
              .toList() ??
          [],
      awardsAndHonors:
          (json['awardsAndHonors'] as List?)
              ?.map((x) => Award.fromJson(x))
              .toList() ??
          [],
      elevatorPitch:
          (json['elevatorPitch'] as List?)
              ?.map((x) => ElevatorPitch.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "deactivate": deactivate,
    "resume": resume?.toJson(),
    "experiences": experiences.map((e) => e.toJson()).toList(),
    "education": education.map((e) => e.toJson()).toList(),
    "awardsAndHonors": awardsAndHonors.map((e) => e.toJson()).toList(),
    "elevatorPitch": elevatorPitch.map((e) => e.toJson()).toList(),
  };
}

class Resume {
  final String? id;
  final String? userId;
  final String? type;
  final String? photo;
  final String? banner;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? city;
  final String? email;
  final List<String> certifications;
  final List<String> languages;
  final List<SocialLink> sLink;
  final List<String> skills;
  final bool? immediatelyAvailable;
  final String? aboutUs;
  final String? title;
  final String? zipCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Resume({
    this.id,
    this.userId,
    this.type,
    this.photo,
    this.banner,
    this.firstName,
    this.lastName,
    this.country,
    this.city,
    this.email,
    required this.certifications,
    required this.languages,
    required this.sLink,
    required this.skills,
    this.immediatelyAvailable,
    this.aboutUs,
    this.title,
    this.zipCode,
    this.createdAt,
    this.updatedAt,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'],
      photo: json['photo'],
      banner: json['banner'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      country: json['country'],
      city: json['city'],
      email: json['email'],
      certifications:
          (json['certifications'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      languages:
          (json['languages'] as List?)?.map((e) => e.toString()).toList() ?? [],
      sLink:
          (json['sLink'] as List?)
              ?.map((e) => SocialLink.fromJson(e))
              .toList() ??
          [],
      skills:
          (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      immediatelyAvailable: json['immediatelyAvailable'],
      aboutUs: json['aboutUs'],
      title: json['title'],
      zipCode: json['zipCode'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "type": type,
    "photo": photo,
    "banner": banner,
    "firstName": firstName,
    "lastName": lastName,
    "country": country,
    "city": city,
    "email": email,
    "certifications": certifications,
    "languages": languages,
    "sLink": sLink.map((e) => e.toJson()).toList(),
    "skills": skills,
    "immediatelyAvailable": immediatelyAvailable,
    "aboutUs": aboutUs,
    "title": title,
    "zipCode": zipCode,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class SocialLink {
  final String? id;
  final String? url;

  SocialLink({this.id, this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(id: json['_id'], url: json['url']);
  }

  Map<String, dynamic> toJson() => {"_id": id, "url": url};
}

class Experience {
  final String? id;
  final String? company;
  final String? position;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? country;
  final String? city;
  final String? jobCategory;
  final String? jobDescription;
  final String? zip;

  Experience({
    this.id,
    this.company,
    this.position,
    this.startDate,
    this.endDate,
    this.country,
    this.city,
    this.jobCategory,
    this.jobDescription,
    this.zip,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['_id'],
      company: json['company'],
      position: json['position'],
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      country: json['country'],
      city: json['city'],
      jobCategory: json['jobCategory'],
      jobDescription: json['jobDescription'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "company": company,
    "position": position,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "country": country,
    "city": city,
    "jobCategory": jobCategory,
    "jobDescription": jobDescription,
    "zip": zip,
  };
}

class Education {
  final String? id;
  final String? city;
  final String? country;
  final String? degree;
  final String? fieldOfStudy;
  final DateTime? startDate;
  final DateTime? graduationDate;
  final String? instituteName;

  Education({
    this.id,
    this.city,
    this.country,
    this.degree,
    this.fieldOfStudy,
    this.startDate,
    this.graduationDate,
    this.instituteName,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['_id'],
      city: json['city'],
      country: json['country'],
      degree: json['degree'],
      fieldOfStudy: json['fieldOfStudy'],
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      graduationDate: json['graduationDate'] != null
          ? DateTime.tryParse(json['graduationDate'])
          : null,
      instituteName: json['instituteName'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "city": city,
    "country": country,
    "degree": degree,
    "fieldOfStudy": fieldOfStudy,
    "startDate": startDate?.toIso8601String(),
    "graduationDate": graduationDate?.toIso8601String(),
    "instituteName": instituteName,
  };
}

class Award {
  final String? id;
  final String? title;
  final String? description;
  final String? programeName;
  final DateTime? programeDate;

  Award({
    this.id,
    this.title,
    this.description,
    this.programeName,
    this.programeDate,
  });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      programeName: json['programeName'],
      programeDate: json['programeDate'] != null
          ? DateTime.tryParse(json['programeDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "programeName": programeName,
    "programeDate": programeDate?.toIso8601String(),
  };
}

class ElevatorPitch {
  final String? id;
  final String? status;
  final Video? video;

  ElevatorPitch({this.id, this.status, this.video});

  factory ElevatorPitch.fromJson(Map<String, dynamic> json) {
    return ElevatorPitch(
      id: json['_id'],
      status: json['status'],
      video: json['video'] is Map<String, dynamic>
          ? Video.fromJson(json['video'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "video": video?.toJson(),
  };
}

class Video {
  final String? url;
  final String? hlsUrl;
  final String? encryptionKeyUrl;

  Video({this.url, this.hlsUrl, this.encryptionKeyUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'],
      hlsUrl: json['hlsUrl'],
      encryptionKeyUrl: json['encryptionKeyUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    "url": url,
    "hlsUrl": hlsUrl,
    "encryptionKeyUrl": encryptionKeyUrl,
  };
}
