class UploadVideoResponseModel {
  final String uploadUrl;
  final String key;
  final String bucket;
  final String fileName;

  UploadVideoResponseModel({
    required this.uploadUrl,
    required this.key,
    required this.bucket,
    required this.fileName,
  });

  factory UploadVideoResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadVideoResponseModel(
      uploadUrl: json['uploadUrl'] as String,
      key: json['key'] as String,
      bucket: json['bucket'] as String,
      fileName: json['fileName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uploadUrl': uploadUrl,
      'key': key,
      'bucket': bucket,
      'fileName': fileName,
    };
  }
}
