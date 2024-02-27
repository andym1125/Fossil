import 'package:flutter/material.dart';
import 'package:any_link_preview/any_link_preview.dart';

class ContentLink extends StatefulWidget {

  final String link;

  const ContentLink({super.key, required this.link});

  @override
  State<ContentLink> createState() => _ContentLinkState();
}

class _ContentLinkState extends State<ContentLink> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          AnyLinkPreview(
            link: widget.link,
            showMultimedia: true,
            bodyMaxLines: 5,
            bodyTextOverflow: TextOverflow.ellipsis,
            titleStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          )
        ]
      )
    );
  }
}