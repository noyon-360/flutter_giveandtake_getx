import 'package:karlfive/features/company/data/model/meta_response_model.dart';

class SingleCompanyResponseModel {
  final Meta meta;
  final List<Company> companies;
  final List<Honor> honors; // Now properly typed!

  SingleCompanyResponseModel({
    required this.meta,
    required this.companies,
    required this.honors,
  });

  // FIXED: Now correctly extracts from 'data' field
// In single_company_response_model.dart
factory SingleCompanyResponseModel.fromJson(Map<String, dynamic> json) {
  print("RAW JSON RECEIVED: $json");

  // 'json' is already dataMap, so no need to extract 'data'
  final meta = json['meta'] is Map<String, dynamic>
      ? Meta.fromJson(json['meta'])
      : Meta(currentPage: 1, totalPages: 1, totalItems: 0, itemsPerPage: 10);

  final companies = (json['companies'] as List?)
      ?.whereType<Map<String, dynamic>>()
      .map((e) => Company.fromJson(e))
      .toList() ?? [];

  final honors = (json['honors'] as List?)
      ?.whereType<Map<String, dynamic>>()
      .map((e) => Honor.fromJson(e))
      .toList() ?? [];

  return SingleCompanyResponseModel(
    meta: meta,
    companies: companies,
    honors: honors,
  );
}




  // Map<String, dynamic> toJson() => {
  //       "meta": meta.toJson(),
  //       "companies": companies.map((e) => e.toJson()).toList(),
  //       "honors": honors.map((e) => e.toJson()).toList(),
  //     };
}

// NEW: Honor model (from your actual honors array)
class Honor {
  final String id;
  final String userId;
  final String title;
  final String programeName;
  final String programeDate;
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

  factory Honor.fromJson(Map<String, dynamic> json) {
    return Honor(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String? ?? '',
      programeName: json['programeName'] as String? ?? '',
      programeDate: json['programeDate'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "title": title,
        "programeName": programeName,
        "programeDate": programeDate,
        "description": description,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

// Your existing Company class — made slightly safer
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
  final List<String> service;
  final List<String> employeesId;
  final String createdAt;
  final String updatedAt;
  final int v;
  final ElevatorPitch? elevatorPitch;

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
    required this.v,
    this.elevatorPitch,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['_id'] as String,
        userId: json['userId'] as String,
        clogo: json['clogo'] as String? ?? '',
        banner: json['banner'] as String? ?? '',
        aboutUs: json['aboutUs'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        cname: json['cname'] as String? ?? '',
        country: json['country'] as String? ?? '',
        city: json['city'] as String? ?? '',
        zipcode: json['zipcode']?.toString() ?? '',
        cemail: json['cemail'] as String? ?? '',
        sLink: (json['sLink'] as List? ?? [])
            .map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
            .toList(),
        industry: json['industry'] as String? ?? '',
        service: List<String>.from(json['service'] ?? []),
        employeesId: List<String>.from(json['employeesId'] ?? []),
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        v: json['__v'] as int? ?? 0,
        elevatorPitch: json['elevatorPitch'] != null
            ? ElevatorPitch.fromJson(json['elevatorPitch'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "clogo": clogo,
        "banner": banner,
        "aboutUs": aboutUs,
        "slug": slug,
        "cname": cname,
        "country": country,
        "city": city,
        "zipcode": zipcode,
        "cemail": cemail,
        "sLink": sLink.map((e) => e.toJson()).toList(),
        "industry": industry,
        "service": service,
        "employeesId": employeesId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        if (elevatorPitch != null) "elevatorPitch": elevatorPitch!.toJson(),
      };
}

class SocialLink {
  final String label;
  final String url;
  final String id;

  SocialLink({required this.label, required this.url, required this.id});

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        label: json['label'] as String? ?? '',
        url: json['url'] as String? ?? '',
        id: json['_id'] as String,
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "url": url,
        "_id": id,
      };
}

// All your ElevatorPitch classes remain exactly the same — no changes needed
// (They are already perfect and null-safe)

class ElevatorPitch {
  final PitchVideo video;
  final PitchMetadata metadata;
  final PitchProcessing processing;
  final String id;
  final String userId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int v;

  ElevatorPitch({
    required this.video,
    required this.metadata,
    required this.processing,
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ElevatorPitch.fromJson(Map<String, dynamic> json) => ElevatorPitch(
        video: PitchVideo.fromJson(json['video']),
        metadata: PitchMetadata.fromJson(json['metadata']),
        processing: PitchProcessing.fromJson(json['processing']),
        id: json['_id'] as String,
        userId: json['userId'] as String,
        status: json['status'] as String,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        v: json['__v'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "video": video.toJson(),
        "metadata": metadata.toJson(),
        "processing": processing.toJson(),
        "_id": id,
        "userId": userId,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class PitchVideo {
  final LocalPaths localPaths;
  final String? url;
  final String hlsUrl;
  final String encryptionKeyUrl;
  final String rawKey;
  final String? rawBucket;

  PitchVideo({
    required this.localPaths,
    this.url,
    required this.hlsUrl,
    required this.encryptionKeyUrl,
    required this.rawKey,
    this.rawBucket,
  });

  factory PitchVideo.fromJson(Map<String, dynamic> json) => PitchVideo(
        localPaths: LocalPaths.fromJson(json['localPaths']),
        url: json['url'],
        hlsUrl: json['hlsUrl'],
        encryptionKeyUrl: json['encryptionKeyUrl'],
        rawKey: json['rawKey'],
        rawBucket: json['rawBucket'],
      );

  Map<String, dynamic> toJson() => {
        "localPaths": localPaths.toJson(),
        "url": url,
        "hlsUrl": hlsUrl,
        "encryptionKeyUrl": encryptionKeyUrl,
        "rawKey": rawKey,
        "rawBucket": rawBucket,
      };
}

class LocalPaths {
  final String? original;
  final String? hls;
  final String? key;

  LocalPaths({this.original, this.hls, this.key});

  factory LocalPaths.fromJson(Map<String, dynamic> json) => LocalPaths(
        original: json['original'],
        hls: json['hls'],
        key: json['key'],
      );

  Map<String, dynamic> toJson() => {
        "original": original,
        "hls": hls,
        "key": key,
      };
}

class PitchMetadata {
  final int duration;
  final String format;
  final String vcodec;
  final int rotation;
  final int width;
  final int height;

  PitchMetadata({
    required this.duration,
    required this.format,
    required this.vcodec,
    required this.rotation,
    required this.width,
    required this.height,
  });

  factory PitchMetadata.fromJson(Map<String, dynamic> json) => PitchMetadata(
        duration: json['duration'] as int,
        format: json['format'] as String,
        vcodec: json['vcodec'] as String,
        rotation: json['rotation'] as int,
        width: json['width'] as int,
        height: json['height'] as int,
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "format": format,
        "vcodec": vcodec,
        "rotation": rotation,
        "width": width,
        "height": height,
      };
}

class PitchProcessing {
  final String state;
  final String startedAt;
  final String updatedAt;
  final String completedAt;
  final int retries;
  final dynamic error;
  final int fileSize;
  final String fileName;

  PitchProcessing({
    required this.state,
    required this.startedAt,
    required this.updatedAt,
    required this.completedAt,
    required this.retries,
    required this.error,
    required this.fileSize,
    required this.fileName,
  });

  factory PitchProcessing.fromJson(Map<String, dynamic> json) => PitchProcessing(
        state: json['state'] as String,
        startedAt: json['startedAt'] as String,
        updatedAt: json['updatedAt'] as String,
        completedAt: json['completedAt'] as String? ?? '',
        retries: json['retries'] as int? ?? 0,
        error: json['error'],
        fileSize: json['fileSize'] as int? ?? 0,
        fileName: json['fileName'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "startedAt": startedAt,
        "updatedAt": updatedAt,
        "completedAt": completedAt,
        "retries": retries,
        "error": error,
        "fileSize": fileSize,
        "fileName": fileName,
      };
}