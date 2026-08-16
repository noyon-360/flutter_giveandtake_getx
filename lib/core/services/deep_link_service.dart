import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

String? customPageSlugFromUri(Uri uri) {
  if (uri.scheme.toLowerCase() != 'https' ||
      uri.host.toLowerCase() != 'evpitch.com' ||
      uri.pathSegments.length != 2 ||
      uri.pathSegments.first != 'pages') {
    return null;
  }

  final slug = uri.pathSegments[1].trim();
  return slug.isEmpty ? null : slug;
}

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  StreamSubscription<Uri>? _subscription;
  String? _pendingCustomPageSlug;
  bool _isAppReady = false;

  void initialize() {
    if (_subscription != null) return;
    _subscription = AppLinks().uriLinkStream.listen(
      _handleUri,
      onError: (_) {},
    );
  }

  void markAppReady() {
    _isAppReady = true;
    _openPendingPage();
  }

  void _handleUri(Uri uri) {
    final slug = customPageSlugFromUri(uri);
    if (slug == null) return;

    _pendingCustomPageSlug = slug;
    _openPendingPage();
  }

  void _openPendingPage() {
    final slug = _pendingCustomPageSlug;
    if (!_isAppReady || slug == null) return;

    _pendingCustomPageSlug = null;
    final route = '/pages/${Uri.encodeComponent(slug)}';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != route) Get.toNamed(route);
    });
  }
}
