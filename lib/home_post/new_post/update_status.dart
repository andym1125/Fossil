import 'package:flutter/material.dart';
import 'package:fossil/home_post/profile_pic.dart';
import 'package:fossil/home_post/user_name.dart';
import 'package:fossil/fossil.dart';

class NewPost extends StatefulWidget {

  final Fossil fossil;
  final String? id;

  const NewPost({super.key, required this.fossil, this.id});

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
                if (widget.id != null) {
                  widget.fossil.createPost(
                    text: newText!,
                    inReplyToStatusId: widget.id,
                  );
                }
                else {
                  widget.fossil.createPost(
                    text: newText!,
                  );
                }
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
            const ProfilePic(imageProvider: 'https://mastodon.andymcdowall.com/system/accounts/avatars/111/378/080/763/125/197/original/5b46021123ce8570.png'),
            const UserNames(userName: 'admin', displayName: 'Fossil'),
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