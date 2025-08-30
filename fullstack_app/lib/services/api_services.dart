import 'package:flutter/foundation.dart';
import 'package:fullstack_app/models/comment.dart';
import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/services/dummy_data.dart';
import '../models/post.dart';

class ApiService {
  Future<List<Post>> getHomeFeedPosts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final joinedIds = DummyData.joinedCommunityIds;
    final feedPosts = DummyData.posts
        .where((post) => joinedIds.contains(post.communityId))
        .toList();
    feedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return feedPosts;
  }

  Future<List<Community>> getCommunities() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.communities;
  }

  Future<Community> getCommunityDetails(String communityId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.communities.firstWhere((c) => c.id == communityId);
  }

  Future<void> createCommunity(String name, String description) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (kDebugMode) {
      print('Community "$name" created.');
    }
  }

  Future<List<Post>> getPostsForCommunity(String communityId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.posts.where((p) => p.communityId == communityId).toList();
  }

  Future<Post> getPostDetails(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.posts.firstWhere((p) => p.id == postId);
  }

  Future<List<Comment>> getCommentsForPost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyData.comments;
  }

  Future<void> createPost(
      String communityId, String title, String? text) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (kDebugMode) {
      print('Post "$title" created in community $communityId.');
    }
  }

  Future<void> vote(String postId, bool isUpvote) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (kDebugMode) {
      print('Voted on post $postId');
    }
  }
}
