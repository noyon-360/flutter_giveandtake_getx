class StatusUpdateResponseModel {
  final String id;
  final JobInfo jobId;
  final UserInfo userId;
  final String status;
  final List<ApplicantAnswer> answer;
  final String resumeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  StatusUpdateResponseModel({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.answer,
    required this.resumeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StatusUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return StatusUpdateResponseModel(
      id: json['_id'] ?? '',
      jobId: JobInfo.fromJson(json['jobId']),
      userId: UserInfo.fromJson(json['userId']),
      status: json['status'] ?? '',
      answer: (json['answer'] as List<dynamic>?)
              ?.map((e) => ApplicantAnswer.fromJson(e))
              .toList() ??
          [],
      resumeId: json['resumeId'] ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'jobId': jobId.toJson(),
      'userId': userId.toJson(),
      'status': status,
      'answer': answer.map((e) => e.toJson()).toList(),
      'resumeId': resumeId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class JobInfo {
  final String id;
  final String title;

  JobInfo({
    required this.id,
    required this.title,
  });

  factory JobInfo.fromJson(Map<String, dynamic> json) {
    return JobInfo(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
    };
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}

class ApplicantAnswer {
  final String question;
  final String ans;
  final String id;

  ApplicantAnswer({
    required this.question,
    required this.ans,
    required this.id,
  });

  factory ApplicantAnswer.fromJson(Map<String, dynamic> json) {
    return ApplicantAnswer(
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
