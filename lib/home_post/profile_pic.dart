import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {

  final String imageProvider;

  const ProfilePic({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: AssetImage(imageProvider),
    );
  }
}