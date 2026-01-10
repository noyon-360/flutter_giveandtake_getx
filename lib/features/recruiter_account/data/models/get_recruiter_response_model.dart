class FetchRecruiterResponseModel {
  final String id;
  final String userId;
  final String bio;
  final String banner;
  final String photo;
  final String title;
  final String firstName;
  final String sureName;
  final String country;
  final String city;
  final String zipCode;
  final String emailAddress;
  final String? phoneNumber; // nullable since your JSON doesn't have it
  final String slug;
  final List<SocialLink> sLink;
  final Company? companyId;
  final ElevatorPitch? elevatorPitch;
  final bool deactivate;

  FetchRecruiterResponseModel({
    required this.id,
    required this.userId,
    required this.bio,
    required this.banner,
    required this.photo,
    required this.title,
    required this.firstName,
    required this.sureName,
    required this.country,
    required this.city,
    required this.zipCode,
    required this.emailAddress,
    this.phoneNumber,
    required this.slug,
    required this.sLink,
    this.companyId,
    this.elevatorPitch,
    required this.deactivate,
  });

  factory FetchRecruiterResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchRecruiterResponseModel(
      id: json["_id"] ?? '',
      userId: json["userId"] ?? '',
      bio: json["bio"] ?? '',
      banner: json["banner"] ?? '',
      photo: json["photo"] ?? '',
      title: json["title"] ?? '',
      firstName: json["firstName"] ?? '',
      sureName: json["sureName"] ?? '',
      country: json["country"] ?? '',
      city: json["city"] ?? '',
      zipCode: json["zipCode"] ?? '',
      emailAddress: json["emailAddress"] ?? '',
      phoneNumber: json["phoneNumber"],
      slug: json["slug"] ?? '',
      sLink: (json["sLink"] is List)
          ? List<SocialLink>.from(
        json["sLink"].map((x) => SocialLink.fromJson(x)),
      )
          : [],
      companyId: (json["companyId"] is Map<String, dynamic>)
          ? Company.fromJson(json["companyId"])
          : null,
      elevatorPitch: (json["elevatorPitch"] is Map<String, dynamic>)
          ? ElevatorPitch.fromJson(json["elevatorPitch"])
          : null,
      deactivate: json["deactivate"] ?? false,
    );
  }
}

class SocialLink {
  final String label;
  final String? url;

  SocialLink({required this.label, this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json["label"] ?? '',
      url: json["url"],
    );
  }
}

class Company {
  final String id;
  final String userId;
  final String clogo;
  final String banner;
  final String aboutUs;
  final String slug;
  final String cname;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final List<SocialLink> sLink;
  final String industry;
  final List<dynamic> service;
  final List<String> employeesId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Company({
    required this.id,
    required this.userId,
    required this.clogo,
    required this.banner,
    required this.aboutUs,
    required this.slug,
    required this.cname,
    required this.country,
    required this.city,
    required this.zipcode,
    required this.cemail,
    required this.sLink,
    required this.industry,
    required this.service,
    required this.employeesId,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["_id"] ?? '',
      userId: json["userId"] ?? '',
      clogo: json["clogo"] ?? '',
      banner: json["banner"] ?? '',
      aboutUs: json["aboutUs"] ?? '',
      slug: json["slug"] ?? '',
      cname: json["cname"] ?? '',
      country: json["country"] ?? '',
      city: json["city"] ?? '',
      zipcode: json["zipcode"] ?? '',
      cemail: json["cemail"] ?? '',
      sLink: (json["sLink"] is List)
          ? List<SocialLink>.from(
        json["sLink"].map((x) => SocialLink.fromJson(x)),
      )
          : [],
      industry: json["industry"] ?? '',
      service: json["service"] is List ? json["service"] : [],
      employeesId: (json["employeesId"] is List)
          ? List<String>.from(json["employeesId"])
          : [],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"])
          : null,
    );
  }
}


class ElevatorPitch {
  final ElevatorVideo video;
  final ElevatorMetadata metadata;
  final ElevatorProcessing processing;

  ElevatorPitch({
    required this.video,
    required this.metadata,
    required this.processing,
  });

  factory ElevatorPitch.fromJson(Map<String, dynamic> json) {
    return ElevatorPitch(
      video: ElevatorVideo.fromJson(json["video"] ?? {}),
      metadata: ElevatorMetadata.fromJson(json["metadata"] ?? {}),
      processing: ElevatorProcessing.fromJson(json["processing"] ?? {}),
    );
  }
}

class ElevatorVideo {
  final String? hlsUrl;
  final String? encryptionKeyUrl;

  ElevatorVideo({this.hlsUrl, this.encryptionKeyUrl});

  factory ElevatorVideo.fromJson(Map<String, dynamic> json) {
    return ElevatorVideo(
      hlsUrl: json["hlsUrl"],
      encryptionKeyUrl: json["encryptionKeyUrl"],
    );
  }
}

class ElevatorMetadata {
  final double duration;
  final String format;
  final String vcodec;
  final int rotation;
  final int width;
  final int height;

  ElevatorMetadata({
    required this.duration,
    required this.format,
    required this.vcodec,
    required this.rotation,
    required this.width,
    required this.height,
  });

  factory ElevatorMetadata.fromJson(Map<String, dynamic> json) {
    return ElevatorMetadata(
      duration: (json["duration"] ?? 0).toDouble(),
      format: json["format"] ?? '',
      vcodec: json["vcodec"] ?? '',
      rotation: json["rotation"] ?? 0,
      width: json["width"] ?? 0,
      height: json["height"] ?? 0,
    );
  }
}

class ElevatorProcessing {
  final String state;
  final DateTime? startedAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final int retries;
  final String? error;
  final int fileSize;
  final String fileName;

  ElevatorProcessing({
    required this.state,
    this.startedAt,
    this.updatedAt,
    this.completedAt,
    required this.retries,
    this.error,
    required this.fileSize,
    required this.fileName,
  });

  factory ElevatorProcessing.fromJson(Map<String, dynamic> json) {
    return ElevatorProcessing(
      state: json["state"] ?? '',
      startedAt: json["startedAt"] != null
          ? DateTime.parse(json["startedAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
      completedAt: json["completedAt"] != null
          ? DateTime.parse(json["completedAt"])
          : null,
      retries: json["retries"] ?? 0,
      error: json["error"],
      fileSize: json["fileSize"] ?? 0,
      fileName: json["fileName"] ?? '',
    );
  }
}
