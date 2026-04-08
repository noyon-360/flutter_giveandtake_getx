import 'dart:io';

import 'package:dio/dio.dart';

class MultipartPayload {
  MultipartPayload({
    Map<String, String>? fields,
    Map<String, List<File>>? files,
  }) : fields = fields ?? <String, String>{},
       files = files ?? <String, List<File>>{};

  final Map<String, String> fields;
  final Map<String, List<File>> files;

  void putField(String key, Object? value) {
    if (value == null) return;
    fields[key] = value.toString();
  }

  void putFile(String key, File? file) {
    if (file == null) return;
    files.putIfAbsent(key, () => <File>[]).add(file);
  }

  Future<FormData> toFormData() async {
    final formData = FormData();

    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    for (final entry in files.entries) {
      for (final file in entry.value) {
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }

    return formData;
  }
}
