


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

  Map<String, dynamic> toJson() => {
        'meta': meta.toJson(),
        'companies': companies.map((e) => e.toJson()).toList(),
        'honors': honors.map((e) => e.toJson()).toList(),
      };
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

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'clogo': clogo,
        'banner': banner,
        'aboutUs': aboutUs,
        'slug': slug,
        'cname': cname,
        'country': country,
        'city': city,
        'zipcode': zipcode,
        'cemail': cemail,
        'sLink': sLink.map((e) => e.toJson()).toList(),
        'industry': industry,
        'service': service,
        'employeesId': employeesId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'elevatorPitch': elevatorPitch.toJson(),
      };
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

  Map<String, dynamic> toJson() => {
        'video': video.toJson(),
        'metadata': metadata.toJson(),
        'processing': processing.toJson(),
        '_id': id,
        'userId': userId,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
class Video {
  final String? url;
  final String? hlsUrl;
  final String? encryptionKeyUrl;

  Video({
    this.url,
    this.hlsUrl,
    this.encryptionKeyUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        url: json['url'],
        hlsUrl: json['hlsUrl'],
        encryptionKeyUrl: json['encryptionKeyUrl'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'hlsUrl': hlsUrl,
        'encryptionKeyUrl': encryptionKeyUrl,
      };
}

class VideoMetadata {
  final int duration;
  final String format;
  final String vcodec;
  final int width;
  final int height;

  VideoMetadata({
    required this.duration,
    required this.format,
    required this.vcodec,
    required this.width,
    required this.height,
  });

  factory VideoMetadata.fromJson(Map<String, dynamic> json) => VideoMetadata(
        duration: json['duration'],
        format: json['format'],
        vcodec: json['vcodec'],
        width: json['width'],
        height: json['height'],
      );

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'format': format,
        'vcodec': vcodec,
        'width': width,
        'height': height,
      };
}

class Processing {
  final String state;
  final int fileSize;
  final String fileName;

  Processing({
    required this.state,
    required this.fileSize,
    required this.fileName,
  });

  factory Processing.fromJson(Map<String, dynamic> json) => Processing(
        state: json['state'],
        fileSize: json['fileSize'],
        fileName: json['fileName'],
      );

  Map<String, dynamic> toJson() => {
        'state': state,
        'fileSize': fileSize,
        'fileName': fileName,
      };
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
