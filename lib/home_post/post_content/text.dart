import 'package:flutter/material.dart';
import 'link.dart';

class ContentText extends StatelessWidget {
  
  final String content;

  const ContentText({super.key, required this.content});

  bool containsLink(String text) {
    RegExp regExp = RegExp(
      r"https?://(?:www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(?:\/\S*)?",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(text);
  }

  String extractLink(String text) {
    RegExp regExp = RegExp(
      r"https?://(?:www\.)?[a-zA-Z0-9-]+\.[a-zA-Z]{2,}(?:\/\S*)?",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.stringMatch(text) ?? '';
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> children = [
      Row(
        children: <Widget>[
          const SizedBox(width: 5),
          Expanded(
            child: Text(content)
          )
        ],
      ),
    ];

    if (containsLink(content) == true) {
      String link = extractLink(content);
      children.add(ContentLink(link: link));
    }

    return Column(
      children: children,
    );
  }
}