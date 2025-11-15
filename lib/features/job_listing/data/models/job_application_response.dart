class JobApplicationResponse {
  final String id;
  final String jobId;
  final String candidateId;
  final String status;
  final String visaRequired;
  final String? elevatorPitchUrl;
  final String? expectedSalary;
  final String? resumeFileName;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobApplicationResponse({
    required this.id,
    required this.jobId,
    required this.candidateId,
    required this.status,
    required this.visaRequired,
    this.elevatorPitchUrl,
    this.expectedSalary,
    this.resumeFileName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return JobApplicationResponse(
      id: json['_id'] ?? '',
      jobId: json['jobId'] ?? '',
      candidateId: json['candidateId'] ?? '',
      status: json['status'] ?? 'pending',
      visaRequired: json['visaRequired'] ?? 'No',
      elevatorPitchUrl: json['elevatorPitchUrl'],
      expectedSalary: json['expectedSalary'],
      resumeFileName: json['resumeFileName'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'jobId': jobId,
      'candidateId': candidateId,
      'status': status,
      'visaRequired': visaRequired,
      'elevatorPitchUrl': elevatorPitchUrl,
      'expectedSalary': expectedSalary,
      'resumeFileName': resumeFileName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}