import 'package:flutter/material.dart';
import 'package:fossil/home_post/profile_pic.dart';
import 'package:fossil/home_post/user_name.dart';
import 'package:fossil/fossil.dart';

class NewPost extends StatefulWidget {

  final Fossil fossil;

  const NewPost({super.key, required this.fossil});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  String? newText;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    
    return Scaffold(

      appBar: AppBar(
        title: const Text('New post'),
        actions: [
          TextButton.icon(
            onPressed: () {
              if (newText != null && newText!.isNotEmpty) {
                widget.fossil.createPost(
                  text: newText!,
                );
                Navigator.pop(context);
              }
            }, 
            icon: const Icon(Icons.send_outlined),
            label: const Text('send')
          )
        ]
      ),

      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            const ProfilePic(imageProvider: 'images/profile_pic.png'),
            const UserNames(userName: 'Aryan_Patel', displayName: 'Aryan Patel'),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 400,
                    minHeight: 400,
                    maxHeight: 1000,
                  ),
                  child: TextField(
                    focusNode: _focusNode,
                    onChanged: (text) {
                      newText = text;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your post...',
                      border: InputBorder.none,
                    ),
                    maxLength: 500,
                    maxLines: null,
                  )
                ),
              )
            )
          ]
        )
      ),
    );
  }
}