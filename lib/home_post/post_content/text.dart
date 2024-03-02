import 'package:flutter/material.dart';
import 'link.dart';
import 'dart:core';

class ContentText extends StatelessWidget {
  final String content;

  const ContentText({Key? key, required this.content}) : super(key: key);

  List<String> extractParagraphs(String text) {
    return text.split(RegExp(r'<\/?p[^>]*>')).where((element) => element.isNotEmpty).toList();
  }

  bool containsLink(String text) {
    return RegExp(r'<a\s+(?:[^>]*?\s+)?href="([^"]*)"').hasMatch(text);
  }

  String extractLink(String text) {
    final match = RegExp(r'<a\s+(?:[^>]*?\s+)?href="([^"]*)"').firstMatch(text);
    return match?.group(1) ?? '';
  }

  String removeAnchorTag(String text) {
    return text.replaceAll(RegExp(r'<a\b[^>]*>.*?</a>'), '');
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = extractParagraphs(content);
    String link = '';

    for (final paragraph in paragraphs) {
      if (containsLink(paragraph)) {
        link = extractLink(paragraph);
        return Column(
          children: [
            for (final paragraph in paragraphs)
              if (paragraph != '<a href="$link"></a>')
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(removeAnchorTag(paragraph)),
                  ],
                ),
            Row(
              children: [
                const SizedBox(width: 10),
                if (link.isNotEmpty)
                  Expanded(
                    child: Text('$link')
                  ),
              ],
            ),
            if (link.isNotEmpty) ContentLink(link: link),
          ],
        );
      }
    }

    return Row(
      children: [
        const SizedBox(width: 10),
        for (final paragraph in paragraphs)
          Text(removeAnchorTag(paragraph)),
      ],
    );
  }
}
