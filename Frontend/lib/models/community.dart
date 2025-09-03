class Community {
  final String id;
  final String name;
  // These fields might not be in all API responses, so make them nullable
  final String? description;
  final int? memberCount;
  final String? imageUrl;

  Community({
    required this.id,
    required this.name,
    this.description,
    this.memberCount,
    this.imageUrl,
  });

  // Factory to create a Community from JSON
  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      // FastAPI returns integer IDs, so we convert them to String
      id: json['id'].toString(),
      name: json['name'],
      // Check for null values for optional fields
      description: json['description'],
      memberCount: json['member_count'],
      imageUrl:
          'https://placehold.co/100x100/E0E0E0/000000?text=${json['name'][0]}',
    );
  }
}
