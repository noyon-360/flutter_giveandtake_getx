import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class QuillHtmlConverter {
  static quill.Document htmlToDocument(String? html) {
    if (html == null || html.trim().isEmpty) {
      return quill.Document();
    }

    final fragment = html_parser.parseFragment(html);
    final ops = <Map<String, dynamic>>[];

    for (final node in fragment.nodes) {
      _appendNode(node, ops, const <String, dynamic>{});
    }

    if (ops.isEmpty || ops.last['insert'] != '\n') {
      ops.add({'insert': '\n'});
    }

    return quill.Document.fromJson(ops);
  }

  static String documentToHtml(quill.Document document) {
    final ops = document.toDelta().toJson();
    final buffer = StringBuffer();
    final inlineBuffer = StringBuffer();

    void flushLine([Map<String, dynamic>? attrs]) {
      final text = inlineBuffer.toString();
      inlineBuffer.clear();
      final currentAttrs = attrs ?? const <String, dynamic>{};

      if (currentAttrs['list'] == 'ordered') {
        buffer.write('<ol><li>${text.isEmpty ? '<br>' : text}</li></ol>');
      } else if (currentAttrs['list'] == 'bullet') {
        buffer.write('<ul><li>${text.isEmpty ? '<br>' : text}</li></ul>');
      } else {
        buffer.write('<p>${text.isEmpty ? '<br>' : text}</p>');
      }
    }

    for (final rawOp in ops) {
      final op = Map<String, dynamic>.from(rawOp as Map);
      final insert = op['insert'];
      final attrs = (op['attributes'] as Map?)?.cast<String, dynamic>() ??
          const <String, dynamic>{};

      if (insert is! String) {
        continue;
      }

      final parts = insert.split('\n');
      for (var i = 0; i < parts.length; i++) {
        final part = parts[i];
        if (part.isNotEmpty) {
          inlineBuffer.write(_wrapInline(part, attrs));
        }

        if (i < parts.length - 1) {
          flushLine(attrs);
        }
      }
    }

    if (inlineBuffer.isNotEmpty) {
      flushLine();
    }

    return buffer.isEmpty ? '<p><br></p>' : buffer.toString();
  }

  static void _appendNode(
    dom.Node node,
    List<Map<String, dynamic>> ops,
    Map<String, dynamic> attrs,
  ) {
    if (node is dom.Text) {
      final text = node.text.replaceAll('\u00a0', ' ');
      if (text.isNotEmpty) {
        ops.add({
          'insert': text,
          if (attrs.isNotEmpty) 'attributes': attrs,
        });
      }
      return;
    }

    if (node is! dom.Element) {
      return;
    }

    final tag = node.localName?.toLowerCase() ?? '';
    final nextAttrs = Map<String, dynamic>.from(attrs);

    if (tag == 'strong' || tag == 'b') nextAttrs['bold'] = true;
    if (tag == 'em' || tag == 'i') nextAttrs['italic'] = true;
    if (tag == 'u') nextAttrs['underline'] = true;
    if (tag == 'a') {
      final href = node.attributes['href'];
      if (href != null && href.isNotEmpty) {
        nextAttrs['link'] = href;
      }
    }

    if (tag == 'br') {
      ops.add({'insert': '\n'});
      return;
    }

    if (tag == 'ul' || tag == 'ol') {
      final listType = tag == 'ol' ? 'ordered' : 'bullet';
      for (final child in node.children.where((element) => element.localName == 'li')) {
        for (final liChild in child.nodes) {
          _appendNode(liChild, ops, nextAttrs);
        }
        ops.add({
          'insert': '\n',
          'attributes': {'list': listType},
        });
      }
      return;
    }

    for (final child in node.nodes) {
      _appendNode(child, ops, nextAttrs);
    }

    if (tag == 'p' || tag == 'div' || tag == 'li') {
      ops.add({'insert': '\n'});
    }
  }

  static String _wrapInline(String text, Map<String, dynamic> attrs) {
    var value = const HtmlEscape(HtmlEscapeMode.element).convert(text);

    final link = attrs['link']?.toString();
    if (link != null && link.isNotEmpty) {
      final href = const HtmlEscape(HtmlEscapeMode.attribute).convert(link);
      value = '<a href="$href">$value</a>';
    }
    if (attrs['underline'] == true) value = '<u>$value</u>';
    if (attrs['italic'] == true) value = '<em>$value</em>';
    if (attrs['bold'] == true) value = '<strong>$value</strong>';

    return value;
  }
}
