class RecruiterPublicViewResponseModel {
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
  final String slug;
  final List<SocialLink> sLink;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Company? company;
  final ElevatorPitch? elevatorPitch;
  final bool deactivate;

  RecruiterPublicViewResponseModel({
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
    required this.slug,
    required this.sLink,
    required this.createdAt,
    required this.updatedAt,
    this.company,
    this.elevatorPitch,
    required this.deactivate,
  });

  factory RecruiterPublicViewResponseModel.fromJson(Map<String, dynamic> json) {
    return RecruiterPublicViewResponseModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      bio: json['bio'] ?? '',
      banner: json['banner'] ?? '',
      photo: json['photo'] ?? '',
      title: json['title'] ?? '',
      firstName: json['firstName'] ?? '',
      sureName: json['sureName'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      slug: json['slug'] ?? '',
      sLink: (json['sLink'] as List<dynamic>?)
          ?.map((e) => SocialLink.fromJson(e))
          .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      company: json['companyId'] != null
          ? Company.fromJson(json['companyId'])
          : null,
      elevatorPitch: json['elevatorPitch'] != null
          ? ElevatorPitch.fromJson(json['elevatorPitch'])
          : null,
      deactivate: json['deactivate'] ?? false,
    );
  }
}

class SocialLink {
  final String id;
  final String label;
  final String url;

  SocialLink({
    required this.id,
    required this.label,
    required this.url,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['_id'] ?? '',
      label: json['label'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Company {
  final String id;
  final String cname;
  final String clogo;
  final String banner;
  final String aboutUs;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final String industry;
  final List<String> employeesId;

  Company({
    required this.id,
    required this.cname,
    required this.clogo,
    required this.banner,
    required this.aboutUs,
    required this.country,
    required this.city,
    required this.zipcode,
    required this.cemail,
    required this.industry,
    required this.employeesId,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? '',
      cname: json['cname'] ?? '',
      clogo: json['clogo'] ?? '',
      banner: json['banner'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      cemail: json['cemail'] ?? '',
      industry: json['industry'] ?? '',
      employeesId:
      (json['employeesId'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class ElevatorPitch {
  final String id;
  final String userId;
  final String status;
  final Video video;
  final Metadata metadata;
  final Processing processing;

  ElevatorPitch({
    required this.id,
    required this.userId,
    required this.status,
    required this.video,
    required this.metadata,
    required this.processing,
  });

  factory ElevatorPitch.fromJson(Map<String, dynamic> json) {
    return ElevatorPitch(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      video: Video.fromJson(json['video']),
      metadata: Metadata.fromJson(json['metadata']),
      processing: Processing.fromJson(json['processing']),
    );
  }
}

class Video {
  final String? hlsUrl;
  final String? encryptionKeyUrl;

  Video({
    this.hlsUrl,
    this.encryptionKeyUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      hlsUrl: json['hlsUrl'],
      encryptionKeyUrl: json['encryptionKeyUrl'],
    );
  }
}
class Metadata {
  final double duration;
  final String format;
  final String vcodec;
  final int width;
  final int height;

  Metadata({
    required this.duration,
    required this.format,
    required this.vcodec,
    required this.width,
    required this.height,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      duration: (json['duration'] ?? 0).toDouble(),
      format: json['format'] ?? '',
      vcodec: json['vcodec'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}

class Processing {
  final String state;
  final String fileName;
  final int fileSize;

  Processing({
    required this.state,
    required this.fileName,
    required this.fileSize,
  });

  factory Processing.fromJson(Map<String, dynamic> json) {
    return Processing(
      state: json['state'] ?? '',
      fileName: json['fileName'] ?? '',
      fileSize: json['fileSize'] ?? 0,
    );
  }
}

