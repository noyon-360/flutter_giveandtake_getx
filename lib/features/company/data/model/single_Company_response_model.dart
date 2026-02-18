
import 'package:flutter/material.dart';

class SingleCompanyResponseModel {
  final Meta meta;
  final List<Company> companies;
  final List<Honor> honors;

  SingleCompanyResponseModel({
    required this.meta,
    required this.companies,
    required this.honors,
  });

  factory SingleCompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return SingleCompanyResponseModel(
      meta: Meta.fromJson(json['meta']),
      companies: (json['companies'] as List)
          .map((e) => Company.fromJson(e))
          .toList(),
      honors: (json['honors'] as List)
          .map((e) => Honor.fromJson(e))
          .toList(),
    );
  }

 
}
class Meta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Meta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['currentPage'],
        totalPages: json['totalPages'],
        totalItems: json['totalItems'],
        itemsPerPage: json['itemsPerPage'],
      );

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'totalPages': totalPages,
        'totalItems': totalItems,
        'itemsPerPage': itemsPerPage,
      };
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final ElevatorPitch elevatorPitch;

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
    required this.createdAt,
    required this.updatedAt,
    required this.elevatorPitch,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['_id'],
        userId: json['userId'],
        clogo: json['clogo'],
        banner: json['banner'],
        aboutUs: json['aboutUs'],
        slug: json['slug'],
        cname: json['cname'],
        country: json['country'],
        city: json['city'],
        zipcode: json['zipcode'],
        cemail: json['cemail'],
        sLink: (json['sLink'] as List)
            .map((e) => SocialLink.fromJson(e))
            .toList(),
        industry: json['industry'],
        service: json['service'] ?? [],
        employeesId: List<String>.from(json['employeesId']),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        elevatorPitch: ElevatorPitch.fromJson(json['elevatorPitch']),
      );

 
}
class SocialLink {
  final String label;
  final String url;
  final String id;

  SocialLink({
    required this.label,
    required this.url,
    required this.id,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        label: json['label'],
        url: json['url'],
        id: json['_id'],
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
        '_id': id,
      };
}
class ElevatorPitch {
  final Video video;
  final VideoMetadata metadata;
  final Processing processing;
  final String id;
  final String userId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ElevatorPitch({
    required this.video,
    required this.metadata,
    required this.processing,
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ElevatorPitch.fromJson(Map<String, dynamic> json) => ElevatorPitch(
    
        video: Video.fromJson(json['video']),
        metadata: VideoMetadata.fromJson(json['metadata']),
        processing: Processing.fromJson(json['processing']),
        id: json['_id'],
        userId: json['userId'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

 
}

class Video {
  final String? url;
  final String? hlsUrl;
  final String? encryptionKeyUrl;
  final dynamic rawKey;
  final dynamic rawBucket;

  Video({
    this.url,
    this.hlsUrl,
    this.encryptionKeyUrl,
    this.rawKey,
    this.rawBucket,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        url: json['url'],
        hlsUrl: json['hlsUrl'],
        encryptionKeyUrl: json['encryptionKeyUrl'],
        rawKey: json['rawKey'],
        rawBucket: json['rawBucket'],
      );
}

class VideoMetadata {
  final double duration;
  final String format;
  final String vcodec;
  final int rotation;
  final int width;
  final int height;

  VideoMetadata({
    required this.duration,
    required this.format,
    required this.vcodec,
    required this.rotation,
    required this.width,
    required this.height,
  });

  factory VideoMetadata.fromJson(Map<String, dynamic> json) => VideoMetadata(
        duration: (json['duration'] as num).toDouble(),
        format: json['format'],
        vcodec: json['vcodec'],
        rotation: json['rotation'] ?? 0,
        width: json['width'],
        height: json['height'],
      );
}

class Processing {
  final String state;
  final DateTime? startedAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final int retries;
  final dynamic error;
  final int fileSize;
  final String fileName;

  Processing({
    required this.state,
    this.startedAt,
    this.updatedAt,
    this.completedAt,
    required this.retries,
    this.error,
    required this.fileSize,
    required this.fileName,
  });

  factory Processing.fromJson(Map<String, dynamic> json) => Processing(
        state: json['state'],
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
        retries: json['retries'] ?? 0,
        error: json['error'],
        fileSize: json['fileSize'],
        fileName: json['fileName'],
      );
}
class Honor {
  final String id;
  final String userId;
  final String title;
  final String programeName;
  final DateTime programeDate;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Honor({
    required this.id,
    required this.userId,
    required this.title,
    required this.programeName,
    required this.programeDate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Honor.fromJson(Map<String, dynamic> json) => Honor(
        id: json['_id'],
        userId: json['userId'],
        title: json['title'],
        programeName: json['programeName'],
        programeDate: DateTime.parse(json['programeDate']),
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'title': title,
        'programeName': programeName,
        'programeDate': programeDate.toIso8601String(),
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
