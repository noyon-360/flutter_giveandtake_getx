import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:giveandtake/core/services/media_crop_service.dart';
import 'package:image/image.dart' as img;

void main() {
  Uint8List createSourceBytes() {
    final image = img.Image(width: 800, height: 600);
    img.fill(image, color: img.ColorRgb8(12, 34, 56));
    return Uint8List.fromList(img.encodePng(image));
  }

  group('MediaCropService.resizeBytes', () {
    test('avatar preset exports 250x250 jpeg', () {
      final bytes = MediaCropService.resizeBytes(
        createSourceBytes(),
        preset: MediaCropPreset.avatar,
      );

      final decoded = img.decodeJpg(bytes);
      expect(decoded, isNotNull);
      expect(decoded!.width, 250);
      expect(decoded.height, 250);
    });

    test('banner preset exports 1584x396 jpeg', () {
      final bytes = MediaCropService.resizeBytes(
        createSourceBytes(),
        preset: MediaCropPreset.banner,
      );

      final decoded = img.decodeJpg(bytes);
      expect(decoded, isNotNull);
      expect(decoded!.width, 1584);
      expect(decoded.height, 396);
    });
  });
}
