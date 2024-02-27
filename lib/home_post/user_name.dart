import 'package:flutter/material.dart';

class UserNames extends StatelessWidget {

  final String userName;
  final String displayName;

  const UserNames({super.key, required this.userName, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Text(
          displayName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        ),
        Text(
          '@$userName',
          style: const TextStyle(
            color: Colors.grey
          )
        )
      ],
    );
  }
}