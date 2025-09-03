import 'package:fullstack_app/models/user.dart';

class Comment {
  final String id;
  final User author; // Changed from String to User
  final String text;
  final DateTime createdAt;
  // Upvotes are not in the backend schema yet, so we remove it for now.
  // final int upvotes;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'].toString(),
      author: User.fromJson(json['author']),
      text: json['content'], // Backend uses 'content'
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
