class Post {
  final String profilePic;
  final String displayName;
  final String userName;
  final String? content;
  final String? imageContent;
  final String? gifContent;
  final String id;
  final bool isFavourited;
  final bool isReblogged;
  final int reblogsCount;
  final String? inReplyToId;
  final int repliesCount;

  Post({
    required this.repliesCount,
    required this.id,
    required this.profilePic,
    required this.displayName,
    required this.userName,
    required this.isFavourited,
    required this.reblogsCount,
    required this.isReblogged,
    this.content,
    this.imageContent,
    this.gifContent,
    this.inReplyToId
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      repliesCount: json['repliesCount'],
      isReblogged: json['isReblogged'],
      reblogsCount: json['reblogsCount'],
      isFavourited: json['isFavourited'],
      id: json['id'],
      profilePic: json['profilePic'],
      displayName: json['displayName'],
      userName: json['userName'],
      content: json['content'],
      imageContent: json['imageContent'],
      gifContent: json['gifContent'],
      inReplyToId: json['inReplyToId']
    );
  }
}