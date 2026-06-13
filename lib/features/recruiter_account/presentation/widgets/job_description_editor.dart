import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Rich-text job description editor built on flutter_quill, shared by the
/// Create Job and Edit Job flows so both use the same formatting toolbar.
class JobDescriptionEditor extends StatelessWidget {
  final quill.QuillController controller;
  final double minHeight;
  final String placeholder;

  const JobDescriptionEditor({
    super.key,
    required this.controller,
    this.minHeight = 220,
    this.placeholder = 'Describe the job role...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          quill.QuillSimpleToolbar(
            controller: controller,
            config: const quill.QuillSimpleToolbarConfig(
              showFontFamily: false,
              showFontSize: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: false,
              showCodeBlock: false,
              showQuote: false,
              showIndent: false,
              showInlineCode: false,
              showSubscript: false,
              showSuperscript: false,
              showSearchButton: false,
              showListCheck: false,
              showDividers: false,
              toolbarSectionSpacing: 2,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: quill.QuillEditor.basic(
              controller: controller,
              config: quill.QuillEditorConfig(
                placeholder: placeholder,
                padding: EdgeInsets.zero,
                minHeight: minHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
