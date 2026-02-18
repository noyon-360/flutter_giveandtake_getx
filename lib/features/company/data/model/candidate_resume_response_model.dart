// profile_response_model.dart


class CandidateResumeResponseModel {
  final Resume? resume;
  final List<Experience> experiences;
  final List<Education> education;
  final List<Award> awardsAndHonors;
  final List<ElevatorPitch> elevatorPitch;

  CandidateResumeResponseModel({
    required this.resume,
    required this.experiences,
    required this.education,
    required this.awardsAndHonors,
    required this.elevatorPitch,
  });

  factory CandidateResumeResponseModel.fromJson(Map<String, dynamic> json) {
    return CandidateResumeResponseModel(
      resume:
          json['resume'] != null ? Resume.fromJson(json['resume']) : null,
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      awardsAndHonors: (json['awardsAndHonors'] as List<dynamic>?)
              ?.map((e) => Award.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      elevatorPitch: (json['elevatorPitch'] as List<dynamic>?)
              ?.map((e) => ElevatorPitch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resume': resume?.toJson(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'awardsAndHonors': awardsAndHonors.map((e) => e.toJson()).toList(),
      'elevatorPitch': elevatorPitch.map((e) => e.toJson()).toList(),
    };
  }
}

/* --------------------- Resume --------------------- */

class Resume {
  final String? id;
  final String? userId;
  final String? photo;
  final String? banner;
  final String? aboutUs;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? city;
  final String? email;
  final List<String> certifications;
  final List<String> languages;
  final List<String> sLink;
  final List<String> skills;
  final bool immediatelyAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? type;
  final String? zipCode;

  Resume({
    this.id,
    this.userId,
    this.photo,
    this.banner,
    this.aboutUs,
    this.title,
    this.firstName,
    this.lastName,
    this.country,
    this.city,
    this.email,
    required this.certifications,
    required this.languages,
    required this.sLink,
    required this.skills,
    required this.immediatelyAvailable,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.type,
    this.zipCode,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      photo: json['photo'] as String?,
      banner: json['banner'] as String?,
      aboutUs: json['aboutUs'] as String?,
      title: json['title'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      email: json['email'] as String?,
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sLink: (json['sLink'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      immediatelyAvailable: json['immediatelyAvailable'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
      type: json['type'] as String?,
      zipCode: json['zipCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'photo': photo,
      'banner': banner,
      'aboutUs': aboutUs,
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'country': country,
      'city': city,
      'email': email,
      'certifications': certifications,
      'languages': languages,
      'sLink': sLink,
      'skills': skills,
      'immediatelyAvailable': immediatelyAvailable,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'type': type,
      'zipCode': zipCode,
    };
  }
}

/* --------------------- Experience --------------------- */

class Experience {
  final String? id;
  final String? userId;
  final String company;
  final String position;
  final DateTime? startDate;
  final DateTime? endDate;
  final String country;
  final String city;
  final String zip;
  final String jobDescription;
  final String jobCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Experience({
    this.id,
    this.userId,
    this.company = '',
    this.position = '',
    this.startDate,
    this.endDate,
    this.country = '',
    this.city = '',
    this.zip = '',
    this.jobDescription = '',
    this.jobCategory = '',
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      company: json['company'] as String? ?? '',
      position: json['position'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      zip: json['zip'] as String? ?? '',
      jobDescription: json['jobDescription'] as String? ?? '',
      jobCategory: json['jobCategory'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'company': company,
      'position': position,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'country': country,
      'city': city,
      'zip': zip,
      'jobDescription': jobDescription,
      'jobCategory': jobCategory,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

/* --------------------- Education --------------------- */

class Education {
  final String? id;
  final String? userId;
  final String instituteName;
  final String city;
  final String country;
  final String degree;
  final String fieldOfStudy;
  final DateTime? startDate;
  final DateTime? graduationDate;
  final int? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Education({
    this.id,
    this.userId,
    this.instituteName = '',
    this.city = '',
    this.country = '',
    this.degree = '',
    this.fieldOfStudy = '',
    this.startDate,
    this.graduationDate,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      instituteName: json['instituteName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      fieldOfStudy: json['fieldOfStudy'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      graduationDate: json['graduationDate'] != null
          ? DateTime.tryParse(json['graduationDate'])
          : null,
      v: json['__v'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'instituteName': instituteName,
      'city': city,
      'country': country,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate?.toIso8601String(),
      'graduationDate': graduationDate?.toIso8601String(),
      '__v': v,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/* --------------------- Award --------------------- */

class Award {
  final String? id;
  final String? userId;
  final String title;
  final String programeName;
  final DateTime? programeDate;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Award({
    this.id,
    this.userId,
    this.title = '',
    this.programeName = '',
    this.programeDate,
    this.description = '',
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String? ?? '',
      programeName: json['programeName'] as String? ?? '',
      programeDate: json['programeDate'] != null
          ? DateTime.tryParse(json['programeDate'])
          : null,
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'programeName': programeName,
      'programeDate': programeDate?.toIso8601String(),
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

/* --------------------- ElevatorPitch (video) --------------------- */

class ElevatorPitch {
  final Video? video;
  final VideoMetadata? metadata;
  final VideoProcessing? processing;
  final String? id;
  final String? userId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ElevatorPitch({
    this.video,
    this.metadata,
    this.processing,
    this.id,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ElevatorPitch.fromJson(Map<String, dynamic> json) {
    return ElevatorPitch(
      video: json['video'] != null ? Video.fromJson(json['video']) : null,
      metadata: json['metadata'] != null
          ? VideoMetadata.fromJson(json['metadata'])
          : null,
      processing: json['processing'] != null
          ? VideoProcessing.fromJson(json['processing'])
          : null,
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video': video?.toJson(),
      'metadata': metadata?.toJson(),
      'processing': processing?.toJson(),
      '_id': id,
      'userId': userId,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Video {
  final LocalPaths localPaths;
  final String? url;
  final String? hlsUrl;
  final String? encryptionKeyUrl;
  final String? rawKey;
  final String? rawBucket;

  Video({
    required this.localPaths,
    this.url,
    this.hlsUrl,
    this.encryptionKeyUrl,
    this.rawKey,
    this.rawBucket,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      localPaths: LocalPaths.fromJson(json['localPaths'] ?? {}),
      url: json['url'] as String?,
      hlsUrl: json['hlsUrl'] as String?,
      encryptionKeyUrl: json['encryptionKeyUrl'] as String?,
      rawKey: json['rawKey'] as String?,
      rawBucket: json['rawBucket'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localPaths': localPaths.toJson(),
      'url': url,
      'hlsUrl': hlsUrl,
      'encryptionKeyUrl': encryptionKeyUrl,
      'rawKey': rawKey,
      'rawBucket': rawBucket,
    };
  }
}

class LocalPaths {
  final String? original;
  final String? hls;
  final String? key;

  LocalPaths({this.original, this.hls, this.key});

  factory LocalPaths.fromJson(Map<String, dynamic> json) {
    return LocalPaths(
      original: json['original'] as String?,
      hls: json['hls'] as String?,
      key: json['key'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'hls': hls,
      'key': key,
    };
  }
}

class VideoMetadata {
  final double? duration;
  final String? format;
  final String? vcodec;
  final int? rotation;
  final int? width;
  final int? height;

  VideoMetadata({
    this.duration,
    this.format,
    this.vcodec,
    this.rotation,
    this.width,
    this.height,
  });

  factory VideoMetadata.fromJson(Map<String, dynamic> json) {
    return VideoMetadata(
      duration: (json['duration'] is num) ? (json['duration'] as num).toDouble() : null,
      format: json['format'] as String?,
      vcodec: json['vcodec'] as String?,
      rotation: json['rotation'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'format': format,
      'vcodec': vcodec,
      'rotation': rotation,
      'width': width,
      'height': height,
    };
  }
}

class VideoProcessing {
  final String? state;
  final DateTime? startedAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final int? retries;
  final String? error;
  final int? fileSize;
  final String? fileName;

  VideoProcessing({
    this.state,
    this.startedAt,
    this.updatedAt,
    this.completedAt,
    this.retries,
    this.error,
    this.fileSize,
    this.fileName,
  });

  factory VideoProcessing.fromJson(Map<String, dynamic> json) {
    return VideoProcessing(
      state: json['state'] as String?,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
      retries: json['retries'] as int?,
      error: json['error'] as String?,
      fileSize: json['fileSize'] as int?,
      fileName: json['fileName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'startedAt': startedAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'retries': retries,
      'error': error,
      'fileSize': fileSize,
      'fileName': fileName,
    };
  }
}

