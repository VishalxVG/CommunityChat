import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/comment.dart';
import 'package:fullstack_app/models/post.dart';
import 'package:fullstack_app/providers/community_providers.dart';

import 'package:fullstack_app/providers/feed_providers.dart';

// Provider to get details for a single post
final postDetailsProvider =
    FutureProvider.autoDispose.family<Post, String>((ref, postId) async {
  final apiService = ref.watch(apiServiceProvider);
  final postJson = await apiService.getPostDetails(postId);
  return Post.fromJson(postJson);
});

// Provider to manage the comments for a post
final commentsProvider = StateNotifierProvider.autoDispose
    .family<CommentsNotifier, AsyncValue<List<Comment>>, String>((ref, postId) {
  return CommentsNotifier(ref, postId);
});

class CommentsNotifier extends StateNotifier<AsyncValue<List<Comment>>> {
  final Ref _ref;
  final String _postId;

  CommentsNotifier(this._ref, this._postId)
      : super(const AsyncValue.loading()) {
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      final commentsJson = await apiService.getComments(_postId);
      final comments =
          (commentsJson).map((json) => Comment.fromJson(json)).toList();
      state = AsyncValue.data(comments);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> addComment({required String text}) async {
    final apiService = _ref.read(apiServiceProvider);
    try {
      // Add the comment via API
      final newCommentJson = await apiService.addComment(_postId, text);
      final newComment = Comment.fromJson(newCommentJson);

      // Add the new comment to the top of the list without re-fetching everything
      state.whenData((comments) {
        state = AsyncValue.data([newComment, ...comments]);
      });

      // Invalidate providers to update comment counts elsewhere
      _ref.invalidate(postDetailsProvider(_postId));
      _ref.invalidate(feedProvider);
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }
}

// Provider to handle voting actions
final voteProvider = Provider((ref) => VoteController(ref));

class VoteController {
  final Ref _ref;
  VoteController(this._ref);

  Future<void> vote(String postId, bool isUpvote) async {
    final apiService = _ref.read(apiServiceProvider);
    try {
      // Call the API to vote
      await apiService.voteOnPost(postId, isUpvote);

      // Invalidate providers to refetch and show the new vote count
      _ref.invalidate(postDetailsProvider(postId));
      _ref.invalidate(feedProvider); // To update the feed screen as well
    } catch (e) {
      // Handle potential errors, e.g., show a snackbar
      print("Error voting: $e");
    }
  }
}

final postActionsProvider = Provider((ref) => PostActionsController(ref));

class PostActionsController {
  final Ref _ref;
  PostActionsController(this._ref);

  Future<void> createPost({
    required String communityId,
    required String title,
    required String? text,
  }) async {
    final apiService = _ref.read(apiServiceProvider);
    try {
      // Call the API to create the post
      await apiService.createPost(communityId, title, text!);

      // After creation, invalidate providers that show lists of posts
      // so they refetch and display the new post.
      _ref.invalidate(feedProvider);
      _ref.invalidate(communityDetailsProvider(communityId));
    } catch (e) {
      // Let the UI handle the error
      rethrow;
    }
  }
}
