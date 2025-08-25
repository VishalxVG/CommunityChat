import 'package:fullstack_app/models/post.dart';
import 'package:fullstack_app/services/dummy_data.dart';

abstract class IPostRepository {
  Future<List<Post>> getHomeFeedPosts();
  Future<Post> getPostDetails(String postId);
  Future<void> upvote(String postId);
  Future<void> downvote(String postId);
  Future<List<Post>> getPostsForCommunity(String communityId);
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
}
