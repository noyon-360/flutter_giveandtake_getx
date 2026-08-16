import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:giveandtake/features/content_pages/data/models/content_page.dart';
import 'package:giveandtake/features/content_pages/data/repositories/content_pages_repository.dart';
import 'package:giveandtake/features/content_pages/domain/content_page_filter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('isCustomPage', () {
    ContentPageSummary page({
      String? type = 'community-guidelines',
      bool isSystem = false,
    }) {
      return ContentPageSummary(
        id: 'page-id',
        type: type,
        title: 'Page',
        isSystem: isSystem,
      );
    }

    test('accepts only non-system pages outside the built-in slug list', () {
      expect(isCustomPage(page()), isTrue);
      expect(isCustomPage(page(isSystem: true)), isFalse);
      expect(isCustomPage(page(type: null)), isFalse);

      for (final type in builtInContentTypes) {
        expect(isCustomPage(page(type: type)), isFalse, reason: type);
      }
    });
  });

  group('ContentPagesRepository', () {
    test('fetches published pages without an Authorization header', () async {
      late http.Request capturedRequest;
      final repository = ContentPagesRepository(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'status': 'success',
              'data': [
                {
                  '_id': '1',
                  'type': 'csae-standards',
                  'title': 'CSAE Standards',
                  'isSystem': false,
                },
              ],
            }),
            200,
          );
        }),
      );

      final pages = await repository.fetchPublishedPages();

      expect(pages.single.title, 'CSAE Standards');
      expect(capturedRequest.url.path, '/api/v1/content/published');
      expect(capturedRequest.headers.containsKey('authorization'), isFalse);
    });

    test('returns an empty list for network and parse failures', () async {
      final networkFailure = ContentPagesRepository(
        client: MockClient((_) async => throw Exception('offline')),
      );
      final parseFailure = ContentPagesRepository(
        client: MockClient((_) async => http.Response('{bad json', 200)),
      );

      expect(await networkFailure.fetchPublishedPages(), isEmpty);
      expect(await parseFailure.fetchPublishedPages(), isEmpty);
    });

    test('uses the fresh cache and force refresh bypasses it', () async {
      var now = DateTime.utc(2026, 1, 1);
      var requests = 0;
      final repository = ContentPagesRepository(
        now: () => now,
        client: MockClient((_) async {
          requests++;
          return http.Response(
            jsonEncode({'status': 'success', 'data': <Object>[]}),
            200,
          );
        }),
      );

      await repository.fetchPublishedPages();
      now = now.add(const Duration(minutes: 9));
      await repository.fetchPublishedPages();
      expect(requests, 1);

      await repository.fetchPublishedPages(forceRefresh: true);
      expect(requests, 2);
    });

    test('encodes the slug and treats missing published as live', () async {
      late http.Request capturedRequest;
      final repository = ContentPagesRepository(
        client: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'status': 'success',
              'data': {
                '_id': '2',
                'type': 'mobile app/policy',
                'title': 'Mobile App Policy',
                'description': '',
                'isSystem': false,
              },
            }),
            200,
          );
        }),
      );

      final page = await repository.fetchPage('mobile app/policy');

      expect(page.published, isTrue);
      expect(
        capturedRequest.url.toString(),
        contains('/content/mobile%20app%2Fpolicy'),
      );
      expect(capturedRequest.headers.containsKey('authorization'), isFalse);
    });

    test('maps 404 and unpublished content to not found', () async {
      final notFound = ContentPagesRepository(
        client: MockClient((_) async => http.Response('{}', 404)),
      );
      final unpublished = ContentPagesRepository(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'status': 'success',
              'data': {
                '_id': '3',
                'type': 'hidden-page',
                'title': 'Hidden',
                'description': '<p>Hidden</p>',
                'isSystem': false,
                'published': false,
              },
            }),
            200,
          ),
        ),
      );

      expect(
        () => notFound.fetchPage('missing'),
        throwsA(isA<ContentPageNotFoundException>()),
      );
      expect(
        () => unpublished.fetchPage('hidden-page'),
        throwsA(isA<ContentPageNotFoundException>()),
      );
    });
  });
}
