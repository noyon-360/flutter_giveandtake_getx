import '../models/about_model.dart';

abstract class ContentRepository {
  /// Fetch the "about" content
  Future<AboutModel> fetchAbout();

  /// Fetch the "privacy" content
  Future<AboutModel> fetchPrivacy();

  /// Fetch the "terms" content
  Future<AboutModel> fetchTerms();
}
