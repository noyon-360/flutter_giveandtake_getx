import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/constants/api_constants.dart';
import '../models/content_page.dart';

class ContentPageNotFoundException implements Exception {
  const ContentPageNotFoundException();
}

class ContentPageLoadException implements Exception {
  const ContentPageLoadException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

class ContentPagesRepository {
  ContentPagesRepository({
    http.Client? client,
    DateTime Function()? now,
    this.staleDuration = const Duration(minutes: 10),
    this.cacheDuration = const Duration(minutes: 30),
  }) : _client = client ?? http.Client(),
       _now = now ?? DateTime.now;

  final http.Client _client;
  final DateTime Function() _now;
  final Duration staleDuration;
  final Duration cacheDuration;

  _CacheEntry<List<ContentPageSummary>>? _publishedCache;
  final Map<String, _CacheEntry<ContentPage>> _pageCache = {};

  Future<List<ContentPageSummary>> fetchPublishedPages({
    bool forceRefresh = false,
  }) async {
    if (_isExpired(_publishedCache)) _publishedCache = null;
    if (!forceRefresh) {
      final cached = _freshValue(_publishedCache);
      if (cached != null) return cached;
    }

    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.content.published),
        headers: const {'Accept': 'application/json'},
      );
      if (response.statusCode != 200) return const [];

      final body = _decodeObject(response.body);
      final data = body['data'];
      if (body['status'] != 'success' || data is! List) {
        throw const FormatException('Invalid published content response');
      }

      final pages = List<ContentPageSummary>.unmodifiable(
        data.map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid published content item');
          }
          return ContentPageSummary.fromJson(item);
        }),
      );
      _publishedCache = _CacheEntry(pages, _now());
      return pages;
    } catch (_) {
      return const [];
    }
  }

  Future<ContentPage> fetchPage(
    String slug, {
    bool forceRefresh = false,
  }) async {
    if (_isExpired(_pageCache[slug])) _pageCache.remove(slug);
    if (!forceRefresh) {
      final cached = _freshValue(_pageCache[slug]);
      if (cached != null) return cached;
    }

    final response = await _client.get(
      Uri.parse(ApiConstants.content.getCustomPage(slug)),
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 404) {
      throw const ContentPageNotFoundException();
    }
    if (response.statusCode != 200) {
      throw ContentPageLoadException(
        _responseMessage(response.body) ?? 'Failed to load page',
        statusCode: response.statusCode,
      );
    }

    try {
      final body = _decodeObject(response.body);
      final data = body['data'];
      if (body['status'] != 'success' || data is! Map<String, dynamic>) {
        throw const FormatException('Invalid content response');
      }

      final page = ContentPage.fromJson(data);
      if (!page.published) throw const ContentPageNotFoundException();

      _pageCache[slug] = _CacheEntry(page, _now());
      return page;
    } on ContentPageNotFoundException {
      rethrow;
    } on FormatException catch (error) {
      throw ContentPageLoadException(error.message.toString());
    }
  }

  T? _freshValue<T>(_CacheEntry<T>? entry) {
    if (entry == null) return null;

    final age = _now().difference(entry.cachedAt);
    if (age <= staleDuration) return entry.value;
    return null;
  }

  bool _isExpired<T>(_CacheEntry<T>? entry) {
    return entry != null && _now().difference(entry.cachedAt) > cacheDuration;
  }

  static Map<String, dynamic> _decodeObject(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object');
    }
    return decoded;
  }

  static String? _responseMessage(String source) {
    try {
      final body = _decodeObject(source);
      return body['message'] is String ? body['message'] as String : null;
    } catch (_) {
      return null;
    }
  }
}

class _CacheEntry<T> {
  const _CacheEntry(this.value, this.cachedAt);

  final T value;
  final DateTime cachedAt;
}
