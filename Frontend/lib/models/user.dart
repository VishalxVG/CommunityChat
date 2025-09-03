class User {
  final int id;
  final String username;
  final String email;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      // Add a null check here as well.
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
