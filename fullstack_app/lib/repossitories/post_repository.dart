import 'dart:math';

import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/models/post.dart';
import 'package:fullstack_app/services/dummy_data.dart';

abstract class IPostRepository {
  Future<List<Post>> getHomeFeedPosts();
  Future<Post> getPostDetails(String postId);
  Future<void> upvote(String postId);
  Future<void> downvote(String postId);
  Future<void> incrementCommentCount(String postId);
  Future<List<Post>> getPostsForCommunity(String communityId);
  Future<void> createPost({
    required String communityId,
    required String title,
    required String? text,
  });
}

class InMemoryPostRepository implements IPostRepository {
  // Use a copy of the dummy data to simulate a database
  final List<Post> _posts = List.from(DummyData.posts);

  @override
  Future<List<Post>> getHomeFeedPosts() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _posts;
  }

  @override
  Future<List<Post>> getPostsForCommunity(String communityId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _posts.where((post) => post.communityId == communityId).toList();
  }

  @override
  Future<Post> getPostDetails(String postId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Find the post from the internal, potentially modified list
    return _posts.firstWhere((post) => post.id == postId);
  }

  @override
  Future<void> upvote(String postId) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final oldPost = _posts[index];
      // Create a new Post object with the updated upvote count
      _posts[index] = Post(
        id: oldPost.id,
        communityId: oldPost.communityId,
        communityName: oldPost.communityName,
        author: oldPost.author,
        title: oldPost.title,
        text: oldPost.text,
        imageUrl: oldPost.imageUrl,
        upvotes: oldPost.upvotes + 1, // Increment the upvotes
        commentCount: oldPost.commentCount,
        createdAt: oldPost.createdAt,
      );
    }
  }

  @override
  Future<void> downvote(String postId) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final oldPost = _posts[index];
      // Create a new Post object with the updated upvote count
      _posts[index] = Post(
        id: oldPost.id,
        communityId: oldPost.communityId,
        communityName: oldPost.communityName,
        author: oldPost.author,
        title: oldPost.title,
        text: oldPost.text,
        imageUrl: oldPost.imageUrl,
        upvotes: oldPost.upvotes - 1, // Increment the upvotes
        commentCount: oldPost.commentCount,
        createdAt: oldPost.createdAt,
      );
    }
  }

  @override
  Future<void> createPost({
    required String communityId,
    required String title,
    required String? text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Find the community name to add to the post
    final community = DummyData.communities.firstWhere(
      (c) => c.id == communityId,
      orElse: () => Community(
          id: '',
          name: 'Unknown',
          description: '',
          memberCount: 0,
          imageUrl: ''),
    );

    final newPost = Post(
      id: Random().nextInt(10000).toString(), // Simple unique ID
      communityId: communityId,
      communityName: community.name,
      author: 'currentUser', // Hardcoded for now
      title: title,
      text: text,
      upvotes: 1,
      commentCount: 0,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, newPost); // Add to the beginning of the list
  }

  @override
  Future<void> incrementCommentCount(String postId) async {
    // Add this method
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final oldPost = _posts[index];
      _posts[index] = Post(
        // ... (copy all existing properties)
        id: oldPost.id,
        communityId: oldPost.communityId,
        communityName: oldPost.communityName,
        author: oldPost.author,
        title: oldPost.title,
        upvotes: oldPost.upvotes,
        // Increment the comment count
        commentCount: oldPost.commentCount + 1,
        createdAt: oldPost.createdAt,
      );
    }
  }
}
