import 'package:flutter/material.dart';
import 'post_class.dart';
import 'profile_pic.dart';
import 'user_name.dart';
import 'post_content/text.dart';
import 'post_content/image.dart';
import 'Row_Icons/icons.dart';
import 'package:fossil/fossil.dart';
import 'package:fossil/single_post/single_post.dart';
import 'dart:async';
import 'Row_Icons/in_reply.dart';
import 'Row_Icons/in_reblog.dart';
import 'post_load.dart';

class PostClass extends StatefulWidget {
  final Fossil fossil;
  final ScrollController? scrollController;

  const PostClass({super.key, required this.fossil, this.scrollController});

  @override
  State<PostClass> createState() => _PostClassState();
}

class _PostClassState extends State<PostClass> {
  final List<Post> posts = [];
  int? _selectedIndex;
  Timer? _timer;
  int previousPostCount = 0;

  @override
  void initState() {
    super.initState();
    loadPosts();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => loadPosts());
  }

  Future<void> loadPosts() async {
    var loader = PostLoader(fossil: widget.fossil, listName: widget.fossil.getPublicTimeline());
    var loadedPosts = await loader.loadPosts();

    setState(() {
      previousPostCount = posts.length;
      posts.clear();
      posts.addAll(loadedPosts);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          controller: widget.scrollController,
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
              if (posts[index].inReplyToId != null) const Row(children: [SizedBox(width: 15),
                InReplyTo()]),
              if (posts[index].isReblogged == true) const Row(children: [SizedBox(width: 15), InReblog()]),
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

            debugPrint(posts[index].profilePic);
            debugPrint(posts[index].userName);

            if (posts[index].content != null && posts[index].content!.isNotEmpty) {
              children.add(ContentText(content: posts[index].content!));
            }

            if (posts[index].imageContent != null) {
              children.add(ContentImage(imagePath: posts[index].imageContent!));
            }

            if (index >= 0) {
              children.add(const SizedBox(height: 10));
            }
             children.add(IconsList(fossil: widget.fossil, isFavourited: posts[index].isFavourited, id: posts[index].id, reblogsCount: posts[index].reblogsCount, isReblogged: posts[index].isReblogged, repliesCount: posts[index].repliesCount, post: posts[index]));

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                debugPrint('$_selectedIndex');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SinglePost(fossil: widget.fossil,post: posts[index]))
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            );
          },
        ),
        if (posts.length != previousPostCount)
          Positioned(
            top: 30,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${posts.length - previousPostCount}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}