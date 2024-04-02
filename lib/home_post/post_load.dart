import 'package:fossil/fossil.dart';
import 'post_class.dart';

class PostLoader {
  final Fossil fossil;
  dynamic listName;

  PostLoader({required this.fossil, required this.listName});

  Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    var publicTimeline = await listName;

    for (var status in publicTimeline) {
      String? inReplyToId = status.inReplyToId;
      String id = status.id;
      String profilePic = status.account.avatar;
      String displayName = status.account.displayName;
      String userName = status.account.username;
      String? content = status.content;
      String? imageContent;
      bool isFavourited = status.isFavourited as bool;
      int reblogsCount = status.reblogsCount;
      bool isReblogged = status.isReblogged as bool;
      int repliesCount = status.repliesCount;

      if (status.mediaAttachments.isNotEmpty) {
        for (var attachment in status.mediaAttachments) {
          imageContent = attachment.url;
        }
      }

      Post post = Post(
        repliesCount: repliesCount,
        isReblogged: isReblogged,
        reblogsCount: reblogsCount,
        isFavourited: isFavourited,
        id: id,
        profilePic: profilePic,
        displayName: displayName,
        userName: userName,
        content: content,
        imageContent: imageContent,
        inReplyToId: inReplyToId,
      );

      posts.add(post);
    }

    return posts;
  }
}