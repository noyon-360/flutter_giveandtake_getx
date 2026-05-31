import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

enum MediaCropPreset { avatar, banner }

class MediaCropDimensions {
  const MediaCropDimensions({
    required this.ratioX,
    required this.ratioY,
    required this.targetWidth,
    required this.targetHeight,
    required this.toolbarTitle,
    required this.fileSuffix,
  });

  final double ratioX;
  final double ratioY;
  final int targetWidth;
  final int targetHeight;
  final String toolbarTitle;
  final String fileSuffix;
}

class MediaCropService {
  MediaCropService({ImagePicker? imagePicker}) : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  static const Map<MediaCropPreset, MediaCropDimensions> presetDimensions = {
    MediaCropPreset.avatar: MediaCropDimensions(
      ratioX: 1,
      ratioY: 1,
      targetWidth: 250,
      targetHeight: 250,
      toolbarTitle: 'Crop Photo',
      fileSuffix: 'avatar',
    ),
    MediaCropPreset.banner: MediaCropDimensions(
      ratioX: 4,
      ratioY: 1,
      targetWidth: 1584,
      targetHeight: 396,
      toolbarTitle: 'Crop Banner',
      fileSuffix: 'banner',
    ),
  };

  Future<File?> pickAndCropImage({
    required ImageSource source,
    required MediaCropPreset preset,
  }) async {
    XFile? pickedFile;
    try {
      pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 100,
      );
    } catch (e, st) {
      debugPrint('MediaCropService.pickAndCropImage pick failed: $e\n$st');
      return null;
    }
    if (pickedFile == null) return null;

    return cropImageFile(
      File(pickedFile.path),
      preset: preset,
    );
  }

  Future<File?> cropImageFile(
    File file, {
    required MediaCropPreset preset,
  }) async {
    final dimensions = presetDimensions[preset]!;

    CroppedFile? cropped;
    try {
      cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: CropAspectRatio(
          ratioX: dimensions.ratioX,
          ratioY: dimensions.ratioY,
        ),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: dimensions.toolbarTitle,
            toolbarColor: const Color(0xFF2B7FD0),
            toolbarWidgetColor: const Color(0xFFFFFFFF),
            hideBottomControls: false,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: dimensions.toolbarTitle,
            aspectRatioLockEnabled: true,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            resetAspectRatioEnabled: false,
          ),
        ],
      );
    } catch (e, st) {
      // image_cropper can throw (e.g. plugin/UI errors on v11). Never let the
      // crop step crash the app: fall back to the originally picked file so the
      // user can still proceed with an (uncropped) image.
      debugPrint('MediaCropService.cropImageFile crop failed: $e\n$st');
      return _safeResize(file, preset: preset);
    }

    // User cancelled the cropper.
    if (cropped == null) return null;

    return _safeResize(File(cropped.path), preset: preset);
  }

  /// Resizes [file] for [preset], but never throws: if resizing fails the
  /// original file is returned so callers always receive a usable image.
  Future<File?> _safeResize(
    File file, {
    required MediaCropPreset preset,
  }) async {
    try {
      return await resizeCroppedFile(file, preset: preset);
    } catch (e, st) {
      debugPrint('MediaCropService._safeResize failed: $e\n$st');
      return file.existsSync() ? file : null;
    }
  }

  Future<File> resizeCroppedFile(
    File file, {
    required MediaCropPreset preset,
  }) async {
    final bytes = await file.readAsBytes();
    final resizedBytes = resizeBytes(
      bytes,
      preset: preset,
    );
    final dimensions = presetDimensions[preset]!;
    final targetPath = path.join(
      file.parent.path,
      '${path.basenameWithoutExtension(file.path)}_${dimensions.fileSuffix}.jpg',
    );
    final targetFile = File(targetPath);
    await targetFile.writeAsBytes(resizedBytes, flush: true);
    return targetFile;
  }

  static Uint8List resizeBytes(
    Uint8List bytes, {
    required MediaCropPreset preset,
  }) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return bytes;
    }

    final dimensions = presetDimensions[preset]!;
    final resized = img.copyResize(
      decoded,
      width: dimensions.targetWidth,
      height: dimensions.targetHeight,
      interpolation: img.Interpolation.cubic,
    );

    return Uint8List.fromList(
      img.encodeJpg(resized, quality: 92),
    );
  }
}
