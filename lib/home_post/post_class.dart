class Post {
  final String profilePic;
  final String displayName;
  final String userName;
  final String? content;
  final String? imageContent;
  final String? gifContent;

  Post({
    required this.profilePic,
    required this.displayName,
    required this.userName,
    this.content,
    this.imageContent,
    this.gifContent,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      profilePic: json['profilePic'],
      displayName: json['displayName'],
      userName: json['userName'],
      content: json['content'],
      imageContent: json['imageContent'],
      gifContent: json['gifContent'],
    );
  }
}