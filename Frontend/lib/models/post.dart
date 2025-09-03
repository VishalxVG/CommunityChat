import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/models/user.dart';

class Post {
  final String id;
  final Community community;
  final User author;
  final String title;
  final String? text;
  final int upvotes;
  final int commentCount;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.community,
    required this.author,
    required this.title,
    this.text,
    required this.upvotes,
    required this.commentCount,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      community: Community.fromJson(json['community']),
      author: User.fromJson(json['author']),
      title: json['title'],
      text: json['content'],
      upvotes: json['votes'],
      commentCount: json['comments']?.length ?? 0,
      // Add a null check here. Use current time as a fallback.
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
