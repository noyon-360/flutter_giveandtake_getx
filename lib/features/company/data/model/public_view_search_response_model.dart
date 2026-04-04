class PublicViewSearchResponseModel {
  final bool deactivate;
  final Meta meta;
  final List<Company> companies;
  final List<Honor> honors;

  PublicViewSearchResponseModel({
    required this.deactivate,
    required this.meta,
    required this.companies,
    required this.honors,
  });

  factory PublicViewSearchResponseModel.fromJson(Map<String, dynamic> json) {
    return PublicViewSearchResponseModel(
      deactivate: json['deactivate'] ?? false,
      meta: Meta.fromJson(json['meta'] ?? {}),
      companies: (json['companies'] as List<dynamic>? ?? [])
          .map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList(),
      honors: (json['honors'] as List<dynamic>? ?? [])
          .map((e) => Honor.fromJson(e as Map<String, dynamic>))
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 0,
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
  final String createdAt;
  final String updatedAt;
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
    this.elevatorPitch,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      clogo: json['clogo'] ?? '',
      banner: json['banner'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
      slug: json['slug'] ?? '',
      cname: json['cname'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      cemail: json['cemail'] ?? '',
      sLink: (json['sLink'] as List<dynamic>? ?? [])
          .map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      industry: json['industry'] ?? '',
      service: json['service'] ?? [],
      employeesId: (json['employeesId'] as List<dynamic>? ?? []).cast<String>(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      elevatorPitch: json['elevatorPitch'] != null
          ? ElevatorPitch.fromJson(
              json['elevatorPitch'] as Map<String, dynamic>?,
            )
          : null,
    );
  }
}

class SocialLink {
  final String label;
  final String url;
  final String id;

  SocialLink({required this.label, required this.url, required this.id});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json['label'] ?? '',
      url: json['url'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class ElevatorPitch {
  final Video video;
  final VideoMetadata metadata;
  final Processing processing;
  final String id;
  final String userId;
  final String status;
  final String createdAt;
  final String updatedAt;

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

  ElevatorPitch.empty()
    : video = Video(),
      metadata = VideoMetadata(
        duration: 0,
        format: '',
        vcodec: '',
        width: 0,
        height: 0,
      ),
      processing = Processing(
        state: '',
        startedAt: '',
        completedAt: '',
        fileSize: 0,
        fileName: '',
      ),
      id = '',
      userId = '',
      status = '',
      createdAt = '',
      updatedAt = '';

  factory ElevatorPitch.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ElevatorPitch.empty();

    return ElevatorPitch(
      video: Video.fromJson(json['video'] as Map<String, dynamic>?),
      metadata: VideoMetadata.fromJson(json['metadata'] ?? {}),
      processing: Processing.fromJson(json['processing'] ?? {}),
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class Video {
  final String? url;
  final String? hlsUrl;
  final String? encryptionKeyUrl;

  Video({this.url, this.hlsUrl, this.encryptionKeyUrl});

  factory Video.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Video();

    final localPaths = json['localPaths'] as Map<String, dynamic>?;

    return Video(
      url: json['url'] as String? ?? localPaths?['original'] as String?,
      hlsUrl: json['hlsUrl'] as String? ?? localPaths?['hls'] as String?,
      encryptionKeyUrl:
          json['encryptionKeyUrl'] as String? ?? localPaths?['key'] as String?,
    );
  }
}

class VideoMetadata {
  final double duration;
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

  factory VideoMetadata.fromJson(Map<String, dynamic> json) {
    return VideoMetadata(
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
  final String startedAt;
  final String completedAt;
  final int fileSize;
  final String fileName;

  Processing({
    required this.state,
    required this.startedAt,
    required this.completedAt,
    required this.fileSize,
    required this.fileName,
  });

  factory Processing.fromJson(Map<String, dynamic> json) {
    return Processing(
      state: json['state'] ?? '',
      startedAt: json['startedAt'] ?? '',
      completedAt: json['completedAt'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      fileName: json['fileName'] ?? '',
    );
  }
}

class Honor {
  final String id;
  final String userId;
  final String title;
  final String programeName;
  final String programeDate;
  final String description;
  final String createdAt;
  final String updatedAt;

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
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      programeName: json['programeName'] ?? '',
      programeDate: json['programeDate'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
