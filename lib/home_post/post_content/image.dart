import 'package:flutter/material.dart';

class ContentImage extends StatelessWidget {

  final String imagePath;

  const ContentImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 1000
        ),
        child: Image(image: NetworkImage(imagePath))
      )
    );
  }
}