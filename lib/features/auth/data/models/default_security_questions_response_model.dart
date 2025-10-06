class DefaultSecurityQuestionsResponseModel {
  final bool success;
  final String message;
  final List<String> questions;

  DefaultSecurityQuestionsResponseModel({
    required this.success,
    required this.message,
    required this.questions,
  });

  factory DefaultSecurityQuestionsResponseModel.fromJson(dynamic json) {
    // Handle null case - return empty model
    if (json == null) {
      return DefaultSecurityQuestionsResponseModel(
        success: false,
        message: 'No data received',
        questions: [],
      );
    }

    // Handle the case where json might be the raw list or a Map
    if (json is List) {
      // If json is directly a list, return it as questions
      return DefaultSecurityQuestionsResponseModel(
        success: true,
        message: 'Success',
        questions: json.map((e) => e.toString()).toList(),
      );
    }

    // Otherwise, treat it as a Map and check for both 'data' and 'date' fields
    if (json is! Map<String, dynamic>) {
      // If it's not a Map, return empty
      return DefaultSecurityQuestionsResponseModel(
        success: false,
        message: 'Invalid data format',
        questions: [],
      );
    }

    final jsonMap = json;

    // Try to get the questions list from either 'data' or 'date' field
    List<dynamic>? questionsList;
    if (jsonMap.containsKey('data')) {
      questionsList = jsonMap['data'] as List<dynamic>?;
    } else if (jsonMap.containsKey('date')) {
      questionsList = jsonMap['date'] as List<dynamic>?;
    }

    return DefaultSecurityQuestionsResponseModel(
      success: jsonMap['success'] ?? false,
      message: jsonMap['message'] ?? '',
      questions: questionsList?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
