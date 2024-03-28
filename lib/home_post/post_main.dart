import 'package:flutter/material.dart';
import 'post_class.dart';
import 'profile_pic.dart';
import 'user_name.dart';
import 'post_content/text.dart';
import 'post_content/image.dart';
import 'Row_Icons/icons.dart';
import 'package:fossil/fossil.dart';
// import 'package:mastodon_api/mastodon_api.dart' as m;
import 'package:fossil/single_post/single_post.dart';

class PostClass extends StatefulWidget {
  final Fossil fossil;

  const PostClass({super.key, required this.fossil});

  @override
  State<PostClass> createState() => _PostClassState();
}

class _PostClassState extends State<PostClass> {
  final List<Post> posts = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    var publicTimeline = await widget.fossil.getPublicTimeline();
    for (var status in publicTimeline) {
      String profilePic = status.account.avatar;
      String displayName = status.account.displayName;
      String userName = status.account.username;
      String? content = status.content;
      String? imageContent;

      if (status.mediaAttachments.isNotEmpty) {
        for (var attachment in status.mediaAttachments) {
          imageContent = attachment.url;
        }
      }

      Post post = Post(
        profilePic: profilePic,
        displayName: displayName,
        userName: userName,
        content: content,
        imageContent: imageContent,
      );

      posts.add(post);
    }

    // Call setState to rebuild the widget tree with the fetched posts
    setState(() {});
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
            children: <Widget>[
              const SizedBox(width: 5),
              ProfilePic(imageProvider: posts[index].profilePic),
              const SizedBox(width: 10),
              UserNames(userName: posts[index].userName, displayName: posts[index].displayName),
            ],
          ),
          const SizedBox(height: 15),
        ];

        if (posts[index].content != null && posts[index].content!.isNotEmpty) {
          children.add(ContentText(content: posts[index].content!));
        }

        if (posts[index].imageContent != null) {
          children.add(ContentImage(imagePath: posts[index].imageContent!));
        }

        if (index >= 0) {
          children.add(const SizedBox(height: 10));
        }

        if (index >= 0) {
          children.add(const IconsList());
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            debugPrint('$_selectedIndex');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SinglePost(post: posts[index]))
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }
}
