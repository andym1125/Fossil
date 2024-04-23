import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fossil/home_post/post_class.dart';
import 'package:fossil/home_post/profile_pic.dart';
import 'package:fossil/home_post/user_name.dart';
import 'package:fossil/home_post/post_content/image.dart';
import 'package:fossil/home_post/post_content/text.dart';
import 'package:fossil/home_post/Row_Icons/icons.dart';
import 'package:fossil/fossil.dart';
import 'package:fossil/home_post/post_load.dart';
import 'package:fossil/home_post/new_post/update_status.dart';
// import 'package:mastodon_api/mastodon_api.dart' as m;
// import 'package:fossil/single_post/replies.dart';

class SinglePost extends StatefulWidget {
  final Post post;
  final Fossil fossil;

  const SinglePost({super.key, required this.fossil, required this.post});
  
  @override
  State<SinglePost> createState() => _SinglePostStates();
}

class _SinglePostStates extends State<SinglePost> {
  final List<Post> posts = [];
  Timer? _timer;

  Future<void> loadedPosts() async{
    var loader = PostLoader(fossil: widget.fossil, listName: widget.fossil.getDirectReplies(widget.post.id));
    var loadedPosts = await loader.loadPosts();

    setState(() {
      posts.clear();
      posts.add(widget.post);
      posts.addAll(loadedPosts);
    });
  }

  @override
  void initState() {
    super.initState();
    loadedPosts();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      loadedPosts();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: const Color(0xFF8F87EC),
      ),

      //body: PostReplies(fossil: fossil, statusId: posts[0].id)
      body: ListView.builder( 
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 5),
                  ProfilePic(imageProvider: posts[index].profilePic),
                  const SizedBox(width: 10),
                  UserNames(userName: posts[index].userName, displayName: posts[index].displayName),
                ],
              ),
              if (index == 0) const SizedBox(height: 15),
              const SizedBox(height: 5),

              if (posts[index].content != null && posts[index].content!.isNotEmpty) ContentText(content: posts[index].content!),

              if (posts[index].imageContent != null) ContentImage(imagePath: posts[index].imageContent!),


              if (index == 0) const SizedBox(height: 10),


              IconsList(fossil: widget.fossil, isFavourited: posts[index].isFavourited, id: posts[index].id, reblogsCount: posts[index].reblogsCount, isReblogged: posts[index].isReblogged, repliesCount: posts[index].repliesCount, post: posts[index]),
              if (index == 0) const Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Divider()),
              if (index == 0) const SizedBox(height: 10),
              if (index != 0) const Divider(),
            ],
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPost(fossil: widget.fossil, id: widget.post.id))
          );
        },
        child: const Icon(Icons.rocket_launch_outlined)
      ),
    );
  }
}