import 'package:fullstack_app/models/community.dart'; // Import Community model

class User {
  final int id;
  final String username;
  final String email;
  final DateTime? createdAt; // Made nullable as per your update
  final List<Community> communities; // Add this list

  User({
    required this.id,
    required this.username,
    required this.email,
    this.createdAt,
    this.communities = const [], // Default to empty list
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final List<Community> communities = json['communities'] != null
        ? (json['communities'] as List)
            .map((communityJson) => Community.fromJson(communityJson))
            .toList()
        : [];

    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      communities: communities,
    );
  }
}
