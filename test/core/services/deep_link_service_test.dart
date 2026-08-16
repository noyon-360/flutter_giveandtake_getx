import 'package:flutter_test/flutter_test.dart';
import 'package:giveandtake/core/services/deep_link_service.dart';

void main() {
  group('customPageSlugFromUri', () {
    test('matches the EVPitch custom page URL', () {
      expect(
        customPageSlugFromUri(
          Uri.parse('https://evpitch.com/pages/community-guidelines'),
        ),
        'community-guidelines',
      );
    });

    test('decodes the route segment', () {
      expect(
        customPageSlugFromUri(
          Uri.parse('https://evpitch.com/pages/mobile%20policy'),
        ),
        'mobile policy',
      );
    });

    test('ignores other hosts and routes', () {
      expect(
        customPageSlugFromUri(
          Uri.parse('https://example.com/pages/community-guidelines'),
        ),
        isNull,
      );
      expect(
        customPageSlugFromUri(Uri.parse('https://evpitch.com/about')),
        isNull,
      );
    });
  });
}
