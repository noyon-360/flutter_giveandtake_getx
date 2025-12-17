// upload_response_model.dart
import 'dart:convert';

List<ResumeUpdatedResponseModel> uploadResponseFromJson(String str) =>
    List<ResumeUpdatedResponseModel>.from(json.decode(str).map((x) => ResumeUpdatedResponseModel.fromJson(x)));

String uploadResponseToJson(List<ResumeUpdatedResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResumeUpdatedResponseModel {
  ResumeUpdatedResponseModel({
    required this.id,
    required this.userId,
    required this.file,
    required this.uploadDate,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String userId;
  final List<UploadFile> file;
  final DateTime uploadDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  factory ResumeUpdatedResponseModel.fromJson(Map<String, dynamic> json) => ResumeUpdatedResponseModel(
        id: json['_id'] as String,
        userId: json['userId'] as String,
        file: json['file'] == null
            ? <UploadFile>[]
            : List<UploadFile>.from((json['file'] as List).map((x) => UploadFile.fromJson(x))),
        uploadDate: DateTime.parse(json['uploadDate'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] is int ? json['__v'] as int : int.parse('${json['__v']}'),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'file': List<dynamic>.from(file.map((x) => x.toJson())),
        'uploadDate': uploadDate.toUtc().toIso8601String(),
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        '__v': v,
      };

  ResumeUpdatedResponseModel copyWith({
    String? id,
    String? userId,
    List<UploadFile>? file,
    DateTime? uploadDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      ResumeUpdatedResponseModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        file: file ?? this.file,
        uploadDate: uploadDate ?? this.uploadDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  @override
  String toString() {
    return 'UploadResponse(id: $id, userId: $userId, file: $file, uploadDate: $uploadDate, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeUpdatedResponseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          file == other.file &&
          uploadDate == other.uploadDate &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v;

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ file.hashCode ^ uploadDate.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ v.hashCode;
}

class UploadFile {
  UploadFile({
    required this.filename,
    required this.url,
    required this.uploadedAt,
    required this.id,
  });

  final String filename;
  final String url;
  final DateTime uploadedAt;
  final String id;

  factory UploadFile.fromJson(Map<String, dynamic> json) => UploadFile(
        filename: json['filename'] as String,
        url: json['url'] as String,
        uploadedAt: DateTime.parse(json['uploadedAt'] as String),
        id: json['_id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'url': url,
        'uploadedAt': uploadedAt.toUtc().toIso8601String(),
        '_id': id,
      };

  UploadFile copyWith({
    String? filename,
    String? url,
    DateTime? uploadedAt,
    String? id,
  }) =>
      UploadFile(
        filename: filename ?? this.filename,
        url: url ?? this.url,
        uploadedAt: uploadedAt ?? this.uploadedAt,
        id: id ?? this.id,
      );

  @override
  String toString() {
    return 'UploadFile(filename: $filename, url: $url, uploadedAt: $uploadedAt, id: $id)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadFile &&
          runtimeType == other.runtimeType &&
          filename == other.filename &&
          url == other.url &&
          uploadedAt == other.uploadedAt &&
          id == other.id;

  @override
  int get hashCode => filename.hashCode ^ url.hashCode ^ uploadedAt.hashCode ^ id.hashCode;
}
