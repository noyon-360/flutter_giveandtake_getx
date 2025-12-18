class JobApplicationRequest {
  final String jobId;
  final String userId;
  final String status;
  final String resumeId;
  final List<Map<String, String>>? answer;

  JobApplicationRequest({
    required this.jobId,
    required this.userId,
    required this.resumeId,
    this.status = 'pending',
    this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'userId': userId,
      'status': status,
      'resumeId': resumeId,
      'answer': answer,
    };
  }
}