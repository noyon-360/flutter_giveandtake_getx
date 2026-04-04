import 'job_model.dart';

class JobListingResponseModel {
  final MetaModel? meta;
  final List<JobModel> jobs;

  JobListingResponseModel({required this.meta, required this.jobs});

  factory JobListingResponseModel.fromJson(dynamic json) {
    List<JobModel> parsedJobs = [];
    MetaModel? parsedMeta;

    print("DEBUG: JobListingResponseModel received json type: ${json.runtimeType}");
    print("DEBUG: JobListingResponseModel received json: $json");

    if (json == null) {
      return JobListingResponseModel(jobs: [], meta: null);
    }

    if (json is List) {
       parsedJobs = json.map((e) => JobModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (json is Map<String, dynamic>) {
      // Try to find the list of jobs in various keys
      final jobsList = json['jobs'] ?? json['docs'] ?? json['data'] ?? json['results'];
      
      if (jobsList is List) {
        parsedJobs = jobsList.map((e) => JobModel.fromJson(e as Map<String, dynamic>)).toList();
      }

      // Try to find meta
      if (json['meta'] != null) {
        parsedMeta = MetaModel.fromJson(json['meta']);
      } else if (json['currentPage'] != null) {
         // Maybe meta is merged in root
         parsedMeta = MetaModel.fromJson(json);
      }
    }

    return JobListingResponseModel(
      meta: parsedMeta,
      jobs: parsedJobs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta?.toJson(),
      'jobs': jobs.map((e) => e.toJson()).toList(),
    };
  }
}

class MetaModel {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  MetaModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
    };
  }
}
