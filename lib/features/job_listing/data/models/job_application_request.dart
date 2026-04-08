class JobApplicationRequest {
  JobApplicationRequest({
    required this.jobId,
    required this.userId,
    this.resumeId,
    this.answer,
    this.hasValidVisa,
  });

  final String jobId;
  final String userId;
  final String? resumeId;
  final List<Map<String, String>>? answer;
  final bool? hasValidVisa;

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'userId': userId,
      if (resumeId != null && resumeId!.trim().isNotEmpty) 'resumeId': resumeId,
      'answer': answer,
      if (hasValidVisa != null) 'hasValidVisa': hasValidVisa,
    };
  }
}
