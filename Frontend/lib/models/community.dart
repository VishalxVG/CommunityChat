import 'package:fullstack_app/models/post.dart';

class Community {
  final String id;
  final String name;
  final String? description;
  final int? memberCount;
  final String imageUrl; // We'll keep generating this on the client
  final List<Post>? posts; // Add this to hold posts in the detail view

  Community({
    required this.id,
    required this.name,
    this.description,
    this.memberCount,
    required this.imageUrl,
    this.posts,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    // Parse the nested list of posts if it exists
    final List<Post> posts = json['posts'] != null
        ? (json['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList()
        : [];

    return Community(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      // The backend provides member_count in the detail view
      memberCount: json['member_count'],
      imageUrl:
          'https://placehold.co/100x100/E0E0E0/000000?text=${json['name'][0]}',
      posts: posts,
    );
  }
}
