import 'package:flutter/material.dart';
import 'fossil.dart';
import 'package:mastodon_api/mastodon_api.dart' as m;
import 'home_drawer/drawer_list.dart';
import 'home_navbar/profile_page.dart';
import 'home_post/post_main.dart';
// import 'home_post/new_post/update_status.dart';
// import 'home_post/post_class.dart';

class HomePage extends StatefulWidget {

  final Fossil fossil;

  const HomePage({super.key, required this.fossil});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      key: _scaffoldKey,

      body: PostClass(fossil: widget.fossil),

      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          // Assuming you have received the public timeline list as publicTimeline
          List<m.Status> publicTimeline = await widget.fossil.getPublicTimeline();

          // Iterate through the list and print information about each status
          for (var status in publicTimeline) {
            debugPrint('-------------START----------------');
            debugPrint('In Reply to: ${status.inReplyToAccountId}');
            debugPrint('userName: ${status.account.username}');
            debugPrint('displayName: ${status.account.displayName}');
            debugPrint('In Reply to: ${status.account.avatar}');
            debugPrint('In Reply to: ${status.inReplyToId}');
            debugPrint('url: ${status.url}');
            debugPrint('content: ${status.content}');
            debugPrint('id: ${status.id}');
            debugPrint('spolier text: ${status.spoilerText}');
            debugPrint('uri: ${status.uri}');
            debugPrint('created at: ${status.createdAt}');
            debugPrint('emojis: ${status.emojis}');
            debugPrint('favorite count: ${status.favouritesCount}');
            debugPrint('hash code: ${status.hashCode}');
            debugPrint('is bookmarked: ${status.isBookmarked}');
            debugPrint('is favourited: ${status.isFavourited}');
            debugPrint('is muted: ${status.isMuted}');
            // debugPrint('media attachments: ${status.mediaAttachments}');
            if (status.mediaAttachments != m.Empty()) {
              for (var attachment in status.mediaAttachments) {
                debugPrint('Media Attachment ID: ${attachment.id}');
                debugPrint('Type: ${attachment.type}');
                debugPrint('URL: ${attachment.url}');
                debugPrint('Preview URL: ${attachment.previewUrl}');
                debugPrint('Description: ${attachment.description ?? "No description available"}');
                debugPrint('-----------------------------');
              }
            }
            debugPrint('poll: ${status.poll}');
            debugPrint('reblog: ${status.reblog}');
            debugPrint('reblog count: ${status.reblogsCount}');
            debugPrint('replies count: ${status.repliesCount}');
            debugPrint('runtime type: ${status.runtimeType}');
            debugPrint('spoiler text: ${status.spoilerText}');
            debugPrint('tags: ${status.tags}');
            debugPrint('visibility: ${status.visibility}');
            debugPrint('----------------END-------------\n\n\n');
          }
        },

        /*
        onPressed: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPost(

                onSubmit: (text) {
                  setState(() {
                    posts.add(Post(
                      profilePic: 'images/profile_pic.png',
                      displayName: 'Aryan Patel',
                      userName: 'Aryan_Patel',
                      content: text,
                      imageContent: null,
                      gifContent: null,
                    ));
                  });
                }
              )
            )
          );
        },
        */
        child: const Icon(Icons.rocket_launch_outlined),
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top:Radius.circular(20.0), bottom: Radius.circular(20.0)),

        child: BottomAppBar(
          elevation: 90,
          color: Colors.white,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              IconButton(
                tooltip: 'Open side bar',
                icon: const Icon(Icons.menu_rounded),
                onPressed: _openDrawer
              ),
              IconButton(
                tooltip: 'Home button',
                icon: const Icon(Icons.home_rounded),
                onPressed: () {

                },
              ),

              IconButton(
                tooltip: 'OpenProfile',
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage())
                  );
                }
              ),
            ],
          )
        )
      ),

      drawer: const Drawer(
        backgroundColor: Colors.white,
        child: DrawerColumn(),
      )
    );
  }
}

/*
class HomePage extends StatefulWidget {
  final Fossil fossil;

  const HomePage({Key? key, required this.fossil}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Assuming you have received the public timeline list as publicTimeline
            List<m.Status> publicTimeline = await widget.fossil.getPublicTimeline();

            // Iterate through the list and print information about each status
            for (var status in publicTimeline) {
              debugPrint('-------------START----------------');
              debugPrint('In Reply to: ${status.inReplyToAccountId}');
              debugPrint('In Reply to: ${status.account.avatar}');
              debugPrint('In Reply to: ${status.inReplyToId}');
              debugPrint('url: ${status.url}');
              debugPrint('content: ${status.content}');
              debugPrint('id: ${status.id}');
              debugPrint('spolier text: ${status.spoilerText}');
              debugPrint('uri: ${status.uri}');
              debugPrint('created at: ${status.createdAt}');
              debugPrint('emojis: ${status.emojis}');
              debugPrint('favorite count: ${status.favouritesCount}');
              debugPrint('hash code: ${status.hashCode}');
              debugPrint('is bookmarked: ${status.isBookmarked}');
              debugPrint('is favourited: ${status.isFavourited}');
              debugPrint('is muted: ${status.isMuted}');
              // debugPrint('media attachments: ${status.mediaAttachments}');
              if (status.mediaAttachments != m.Empty()) {
                for (var attachment in status.mediaAttachments) {
                  debugPrint('Media Attachment ID: ${attachment.id}');
                  debugPrint('Type: ${attachment.type}');
                  debugPrint('URL: ${attachment.url}');
                  debugPrint('Preview URL: ${attachment.previewUrl}');
                  debugPrint('Description: ${attachment.description ?? "No description available"}');
                  debugPrint('-----------------------------');
                }
              }
              debugPrint('poll: ${status.poll}');
              debugPrint('reblog: ${status.reblog}');
              debugPrint('reblog count: ${status.reblogsCount}');
              debugPrint('replies count: ${status.repliesCount}');
              debugPrint('runtime type: ${status.runtimeType}');
              debugPrint('spoiler text: ${status.spoilerText}');
              debugPrint('tags: ${status.tags}');
              debugPrint('visibility: ${status.visibility}');
              debugPrint('----------------END-------------\n\n\n');
            }
          },
          child: const Text('Get Public Timeline'),
        ),
      ),
    );
  }
}
*/
