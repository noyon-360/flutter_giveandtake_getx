import 'job_model.dart';

class JobListingResponseModel {
  final List<JobModel> jobs;

  JobListingResponseModel({required this.jobs});

  factory JobListingResponseModel.fromJson(Map<String, dynamic> json) {
    return JobListingResponseModel(
      jobs:
          (json['jobs'] as List<dynamic>?)
              ?.map((e) => JobModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'jobs': jobs.map((e) => e.toJson()).toList()};
  }
}
