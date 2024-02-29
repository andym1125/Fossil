/*
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class ContentGif extends StatefulWidget {
  final String gifPath;

  const ContentGif({super.key, required this.gifPath});

  @override
  State<ContentGif> createState() => _ContentGifState();
}

class _ContentGifState extends State<ContentGif> with SingleTickerProviderStateMixin {
  late GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 1000
          ),
          child: Gif(
            image: AssetImage(widget.gifPath),
            controller: _controller,
            autostart: Autostart.loop,
            placeholder: (context) => const Text('Loading...'),
            onFetchCompleted: () {
              _controller.reset();
              _controller.forward();
            },
          )
        )
      )
    );
  }
}
*/