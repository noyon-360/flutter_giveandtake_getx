import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../data/models/content_page.dart';
import '../../data/repositories/content_pages_repository.dart';
import '../../domain/content_page_filter.dart';

class ContentPageScreen extends StatefulWidget {
  const ContentPageScreen({super.key, required this.slug});

  final String slug;

  @override
  State<ContentPageScreen> createState() => _ContentPageScreenState();
}

class _ContentPageScreenState extends State<ContentPageScreen> {
  late final ContentPagesRepository _repository;
  ContentPage? _page;
  Object? _error;
  bool _isLoading = true;
  bool _isNotFound = false;

  @override
  void initState() {
    super.initState();
    _repository = Get.find<ContentPagesRepository>();
    _loadPage();
  }

  @override
  void didUpdateWidget(covariant ContentPageScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      _page = null;
      _loadPage();
    }
  }

  Future<void> _loadPage({bool forceRefresh = false}) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
        _isNotFound = false;
      });
    }

    try {
      final page = await _repository.fetchPage(
        widget.slug,
        forceRefresh: forceRefresh,
      );
      if (!isCustomPage(page)) throw const ContentPageNotFoundException();
      if (!mounted) return;
      setState(() => _page = page);
    } on ContentPageNotFoundException {
      if (!mounted) return;
      setState(() {
        _page = null;
        _isNotFound = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _page?.title ?? 'Page',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _page == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isNotFound) {
      return const Center(child: Text('Page not found'));
    }
    if (_error != null && _page == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Unable to load this page'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _loadPage(forceRefresh: true),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    final page = _page;
    if (page == null) {
      return const Center(child: Text('Page not found'));
    }

    return RefreshIndicator(
      onRefresh: () => _loadPage(forceRefresh: true),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(17),
          child: Html(
            data: page.description,
            extensions: const [TableHtmlExtension()],
            onLinkTap: (url, _, _) => unawaited(_openExternalLink(url)),
            style: {
              'body': Style(
                margin: Margins.zero,
                color: const Color(0xFF545454),
                fontSize: FontSize(12),
                lineHeight: const LineHeight(1.6),
              ),
              'h1': _headingStyle(20),
              'h2': _headingStyle(16),
              'h3': _headingStyle(14),
              'h4': _headingStyle(13),
              'p': Style(
                color: const Color(0xFF545454),
                fontSize: FontSize(12),
                lineHeight: const LineHeight(1.6),
              ),
              'ul': _bodyStyle(),
              'ol': _bodyStyle(),
              'li': _bodyStyle(),
              'a': Style(
                color: const Color(0xFF2B7FD0),
                textDecoration: TextDecoration.underline,
              ),
              'blockquote': Style(
                color: const Color(0xFF545454),
                backgroundColor: const Color(0xFFF5F7FA),
                border: const Border(
                  left: BorderSide(color: Color(0xFF2B7FD0), width: 3),
                ),
              ),
              'table': Style(fontSize: FontSize(12)),
              'th': Style(fontWeight: FontWeight.w700),
              'td': Style(fontSize: FontSize(12)),
            },
          ),
        ),
      ),
    );
  }

  Style _headingStyle(double size) {
    return Style(
      color: Colors.black,
      fontSize: FontSize(size),
      fontWeight: FontWeight.bold,
      lineHeight: const LineHeight(1.35),
    );
  }

  Style _bodyStyle() {
    return Style(
      color: const Color(0xFF545454),
      fontSize: FontSize(12),
      lineHeight: const LineHeight(1.6),
    );
  }

  Future<void> _openExternalLink(String? value) async {
    if (value == null || value.trim().isEmpty) return;

    final parsed = Uri.tryParse(value.trim());
    if (parsed == null) return;
    final uri = parsed.hasScheme
        ? parsed
        : Uri.parse(ApiConstants.webBaseUrl).resolveUri(parsed);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
