import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/comment.dart';
import 'package:fullstack_app/models/post.dart';
import 'package:fullstack_app/providers/community_providers.dart';

final homeFeedPostsProvider = FutureProvider<List<Post>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getHomeFeedPosts();
});

final postsProvider =
    FutureProvider.family<List<Post>, String>((ref, communityId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPostsForCommunity(communityId);
});

final postDetailsProvider =
    FutureProvider.family<Post, String>((ref, postId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPostDetails(postId);
});

final commentsProvider =
    FutureProvider.family<List<Comment>, String>((ref, postId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCommentsForPost(postId);
});
