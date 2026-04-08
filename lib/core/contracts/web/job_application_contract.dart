import 'dart:io';

import 'multipart_payload.dart';

class JobApplicationAnswerInput {
  const JobApplicationAnswerInput({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  Map<String, dynamic> toJson() => {
    'question': question,
    'ans': answer,
  };
}

class JobApplicationInput {
  const JobApplicationInput({
    required this.jobId,
    required this.userId,
    this.resumeId,
    this.hasValidVisa,
    this.answer = const <JobApplicationAnswerInput>[],
  });

  final String jobId;
  final String userId;
  final String? resumeId;
  final bool? hasValidVisa;
  final List<JobApplicationAnswerInput> answer;

  Map<String, dynamic> toJson() => {
    'jobId': jobId,
    'userId': userId,
    if (resumeId != null && resumeId!.trim().isNotEmpty) 'resumeId': resumeId,
    'answer': answer.map((item) => item.toJson()).toList(),
    if (hasValidVisa != null) 'hasValidVisa': hasValidVisa,
  };
}

class ResumeUploadInput {
  const ResumeUploadInput({
    required this.userId,
    required this.file,
  });

  final String userId;
  final File file;
}

class JobApplicationPayloadBuilder {
  static MultipartPayload buildResumeUpload(ResumeUploadInput input) {
    final payload = MultipartPayload();
    payload.putField('userId', input.userId);
    payload.putFile('resumes', input.file);
    return payload;
  }
}
