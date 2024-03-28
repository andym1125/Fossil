import 'package:flutter/material.dart';
import 'package:fossil/home_post/post_class.dart';
import 'package:fossil/home_post/profile_pic.dart';
import 'package:fossil/home_post/user_name.dart';
import 'package:fossil/home_post/post_content/image.dart';
import 'package:fossil/home_post/post_content/text.dart';
import 'package:fossil/home_post/Row_Icons/icons.dart';

class SinglePost extends StatelessWidget {
  final Post post;

  const SinglePost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {

    final List<Post> posts = [
      Post.fromJson({
        'profilePic': post.profilePic,
        'displayName': post.displayName,
        'userName': post.userName,
        'content': post.content,
        'imageContent': post.imageContent,
        'gifContent': post.gifContent,
      })
    ];

    List<Widget> children = [
      const SizedBox(height: 15),
      Row(
        children: <Widget>[
          const SizedBox(width: 5),
          ProfilePic(imageProvider: posts[0].profilePic),
          const SizedBox(width: 10),
          UserNames(userName: posts[0].userName, displayName: posts[0].displayName),
        ],
      ),
      const SizedBox(height: 15),
    ];

    if (posts[0].content != null && posts[0].content!.isNotEmpty) {
      children.add(ContentText(content: posts[0].content!));
    }

    if (posts[0].imageContent != null) {
      children.add(ContentImage(imagePath: posts[0].imageContent!));
    }

    if (0 >= 0) {
      children.add(const SizedBox(height: 10));
    }

    if (0 >= 0) {
      children.add(const IconsList());
    }

    children.add(const Divider());

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: const Color(0xFF8F87EC),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      )
    );
  }
}