class UploadVideoRequestModel {
  final String fileName;
  final String fileType;
  final int fileSize;

  UploadVideoRequestModel({
    required this.fileName,
    required this.fileType,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
    };
  }
}
