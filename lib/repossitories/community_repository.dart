import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/services/dummy_data.dart';
import 'dart:math';

abstract class ICommunityRepository {
  Future<List<Community>> getCommunities();
  Future<Community> getCommunityDetails(String communityId);
  Future<void> createCommunity(String name, String description);
}

class InMemoryCommunityRepository implements ICommunityRepository {
  final List<Community> _communities = List.from(DummyData.communities);

  @override
  Future<List<Community>> getCommunities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _communities;
  }

  @override
  Future<Community> getCommunityDetails(String communityId) async {
    // Add this method
    await Future.delayed(const Duration(milliseconds: 200));
    // Find the community in the updated, in-memory list
    return _communities.firstWhere((community) => community.id == communityId);
  }

  @override
  Future<void> createCommunity(String name, String description) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newCommunity = Community(
      id: Random().nextInt(1000).toString(), // Simple unique ID for now
      name: name,
      description: description,
      memberCount: 1, // The creator is the first member
      imageUrl: 'https://placehold.co/100x100/E0E0E0/000000?text=${name[0]}',
    );
    _communities.add(newCommunity);
  }
}
