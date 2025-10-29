import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/constants/api_constants.dart';
import '../models/about_model.dart';
import 'content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  final http.Client client;

  ContentRepositoryImpl({http.Client? client})
    : client = client ?? http.Client();

  @override
  Future<AboutModel> fetchAbout() async {
    final uri = Uri.parse(ApiConstants.content.about);
    final resp = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception('No data in about response');
      return AboutModel.fromJson(data);
    }

    throw Exception('Failed to fetch about: ${resp.statusCode} ${resp.body}');
  }

  @override
  Future<AboutModel> fetchTerms() async {
    // Try the correct endpoint first, then fallback to the 'trems' variant if necessary
    final endpoints = [ApiConstants.content.terms, ApiConstants.content.trems];
    for (final e in endpoints) {
      final uri = Uri.parse(e);
      final resp = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (resp.statusCode == 200) {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) continue;
        return AboutModel.fromJson(data);
      }
      // on non-200 try next endpoint
    }

    throw Exception('Failed to fetch terms from both endpoints');
  }

  @override
  Future<AboutModel> fetchPrivacy() async {
    final uri = Uri.parse(ApiConstants.content.privacy);
    final resp = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception('No data in privacy response');
      return AboutModel.fromJson(data);
    }

    throw Exception('Failed to fetch privacy: ${resp.statusCode} ${resp.body}');
  }
}
