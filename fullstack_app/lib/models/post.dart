class Post {
  final String id;
  final String communityId;
  final String communityName;
  final String author;
  final String title;
  final String? text;
  final String? link;
  final String? imageUrl;
  final int upvotes;
  final int commentCount;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.communityId,
    required this.communityName,
    required this.author,
    required this.title,
    this.text,
    this.link,
    this.imageUrl,
    required this.upvotes,
    required this.commentCount,
    required this.createdAt,
  });
}
