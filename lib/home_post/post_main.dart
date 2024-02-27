import 'package:flutter/material.dart';
import 'post_class.dart';
import 'profile_pic.dart';
import 'user_name.dart';
import 'post_content/text.dart';
import 'post_content/image.dart';
//import 'post_content/gif.dart';
import 'Row_Icons/icons.dart';

final List<Post> posts = [
  Post.fromJson({
    'profilePic': 'images/profile_pic.png',
    'displayName': 'Aryan Patel',
    'userName': 'Aryan_Patel',
    'content': 'Hello World!',
    'imageContent': null,
    'gifContent': null,
  }),
  Post.fromJson({
    'profilePic': 'images/profile_pic.png',
    'displayName': 'Aryan Patel',
    'userName': 'Aryan_Patel',
    'content': 'Hello Worldddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd! https://www.theverge.com/2024/2/12/24067370/microsoft-xbox-playstation-switch-games-future-hardware',
    'imageContent': null,
    'gifContent': null,
  }),
  /*
  Post.fromJson({
    'profilePic': 'images/profile_pic.png',
    'displayName': 'Aryan Patel',
    'userName': 'Aryan_Patel',
    'content': 'GIFFFFFFFFFFFFF',
    'imageContent': null,
    'gifContent': 'images/giphy.gif',
  }),
  */
  Post.fromJson({
    'profilePic': 'images/profile_pic.png',
    'displayName': 'Aryan Patel',
    'userName': 'Aryan_Patel',
    'content': 'Wallpaper',
    'imageContent': 'images/wallpaper.png',
    'gifContent': null,
  }),
];

class PostClass extends StatefulWidget {
  const PostClass({super.key});

  @override
  State<PostClass> createState() => _PostClassState();
}

class _PostClassState extends State<PostClass> {

  void addItem(Post newItem) {
    setState(() {
      posts.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: posts.length,
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(),
        );
      },
      itemBuilder: (context, index) {
        List<Widget> children = [
          const SizedBox(height: 10),
          Row(
            children: <Widget> [
              const SizedBox(width: 5),
              ProfilePic(imageProvider: posts[index].profilePic),
              const SizedBox(width: 10),
              UserNames(userName: posts[index].userName, displayName: posts[index].displayName)
            ]
          ),
          const SizedBox(height: 15),
        ];

        if (posts[index].content != null && posts[index].content!.isNotEmpty) {
          children.add(ContentText(content: posts[index].content!));
        }

        if (posts[index].imageContent != null) {
          children.add(ContentImage(imagePath: posts[index].imageContent!));
        }

        /*
        if (posts[index].gifContent !=  null) {
          children.add(ContentGif(gifPath: posts[index].gifContent!));
        }
        */

        if (index >= 0) {
          children.add(const SizedBox(height: 10));
        }

        if (index >= 0) {
          children.add(const IconsList());
        }
        
        return GestureDetector(
          onTap: () {

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ) 
          /*
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          )
          */
        );
        /*
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        );
        */
      },
    );
  }
}