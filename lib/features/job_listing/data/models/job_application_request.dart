class JobApplicationRequest {
  final String jobId;
  final String visaRequired;
  final String? elevatorPitchUrl;
  final String? expectedSalary;
  final String? resumeFileName;

  JobApplicationRequest({
    required this.jobId,
    required this.visaRequired,
    this.elevatorPitchUrl,
    this.expectedSalary,
    this.resumeFileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'visaRequired': visaRequired,
      'elevatorPitchUrl': elevatorPitchUrl,
      'expectedSalary': expectedSalary,
      'resumeFileName': resumeFileName,
    };
  }
}