// lib/core/network/models/base_response.dart

import 'error_source.dart';

class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<ErrorSource>? errorSources;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorSources,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    // Handle data field - it can be null, empty string, or actual data
    // Also check for 'date' field as a fallback (some APIs have typos)
    T? parsedData;
    final dataField = json['data'] ?? json['date'];

    if (dataField != null) {
      // Check if data is an empty string or non-map primitive
      if (dataField is String && dataField.isEmpty) {
        // Empty string - don't try to parse
        parsedData = null;
      } else if (dataField is Map || dataField is List) {
        // Valid JSON structure - parse it
        try {
          parsedData = fromJsonT(dataField);
        } catch (e) {
          // Parsing failed - set to null
          parsedData = null;
        }
      } else {
        // Primitive value (number, bool, etc.) - pass directly
        try {
          parsedData = fromJsonT(dataField);
        } catch (e) {
          parsedData = null;
        }
      }
    }

    // Handle success field - can be boolean or string
    bool successValue = false;
    if (json['success'] != null) {
      if (json['success'] is bool) {
        successValue = json['success'];
      } else if (json['success'] is String) {
        successValue = json['success'].toString().toLowerCase() == 'true';
      }
    } else if (json['status'] != null) {
      if (json['status'] is bool) {
        successValue = json['status'];
      } else if (json['status'] is String) {
        successValue = json['status'].toString().toLowerCase() == 'success';
      }
    }

    print("DEBUG: BaseResponse extracted data: $parsedData");
    return BaseResponse<T>(
      success: successValue,
      message: json['message'] ?? '',
      data: parsedData,
      errorSources: json['errorSources'] != null
          ? (json['errorSources'] as List)
                .map((e) => ErrorSource.fromJson(e))
                .toList()
          : null,
    );
  }

  String get combinedErrorMessage {
    if (errorSources == null || errorSources!.isEmpty) return message;
    return errorSources!.map((e) => e.message).join('\n');
  }
}
