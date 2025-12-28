class AnswerModel {
  final String question;
  final String ans;
  final String id;

  AnswerModel({
    required this.question,
    required this.ans,
    required this.id,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      question: json['question'] ?? '',
      ans: json['ans'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'ans': ans,
      '_id': id,
    };
  }
}

class JobApplicationResponse {
  final String id;
  final String jobId;
  final String userId;
  final String status;
  final List<AnswerModel> answer;
  final String resumeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobApplicationResponse({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.answer,
    required this.resumeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return JobApplicationResponse(
      id: json['_id'] ?? '',
      jobId: json['jobId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? 'pending',
      answer: (json['answer'] as List<dynamic>?)
              ?.map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      resumeId: json['resumeId'] ?? '',
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
      'userId': userId,
      'status': status,
      'answer': answer.map((e) => e.toJson()).toList(),
      'resumeId': resumeId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}