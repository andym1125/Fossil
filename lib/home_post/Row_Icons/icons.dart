import 'package:flutter/material.dart';

class IconsList extends StatelessWidget {
  const IconsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          onPressed: () {

          }, 
          icon: const Icon(Icons.comment_outlined)
        ),
        IconButton(
          onPressed: () {

          }, 
          icon: const Icon(Icons.cached)
        ),
        IconButton(
          onPressed: () {

          }, 
          icon: const Icon(Icons.favorite_border)
        ),
        IconButton(
          onPressed: () {

          }, 
          icon: const Icon(Icons.share_outlined)
        )
      ],
    );
  }
}