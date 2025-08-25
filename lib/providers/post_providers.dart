import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/comment.dart';
import 'package:fullstack_app/models/post.dart';
import 'package:fullstack_app/providers/community_providers.dart';
import 'package:fullstack_app/repossitories/post_repository.dart';

final postRepositoryProvider = Provider<IPostRepository>((ref) {
  return InMemoryPostRepository();
});

// 2. Change homeFeedPostsProvider to an AsyncNotifierProvider
final homeFeedPostsProvider =
    AsyncNotifierProvider<HomeFeedPostsNotifier, List<Post>>(() {
  return HomeFeedPostsNotifier();
});

class HomeFeedPostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    // The initial data fetch
    return ref.watch(postRepositoryProvider).getHomeFeedPosts();
  }

  // Method to handle upvoting
  Future<void> upvote(String postId) async {
    final postRepository = ref.read(postRepositoryProvider);

    // Perform the upvote operation
    await postRepository.upvote(postId);

    // Refetch the data to update the UI

    state = await AsyncValue.guard(
      () {
        return build();
      },
    );
  }

  Future<void> downvote(String postId) async {
    final postRepository = ref.read(postRepositoryProvider);
    await postRepository.downvote(postId);
    ref.invalidate(postDetailsProvider(postId));
    state = await AsyncValue.guard(() => build());
  }
}

final postDetailsProvider =
    AsyncNotifierProvider.family<PostDetailsNotifier, Post, String>(() {
  return PostDetailsNotifier();
});

class PostDetailsNotifier extends FamilyAsyncNotifier<Post, String> {
  @override
  Future<Post> build(String arg) async {
    // Fetch the post from the single source of truth: the repository
    return ref.watch(postRepositoryProvider).getPostDetails(arg);
  }

  // Add an upvote method here as well
  Future<void> upvote() async {
    final postId = arg; // 'arg' holds the postId passed to the family
    final postRepository = ref.read(postRepositoryProvider);
    await postRepository.upvote(postId);

    // Invalidate the home feed provider so it also updates when we come back
    ref.invalidate(homeFeedPostsProvider);

    // Refresh this provider's state to show the new upvote count
    state = await AsyncValue.guard(() => build(postId));
  }

  Future<void> downvote() async {
    final postId = arg;
    final postRepository = ref.read(postRepositoryProvider);
    await postRepository.downvote(postId);
    ref.invalidate(homeFeedPostsProvider);
    state = await AsyncValue.guard(() => build(postId));
  }
}

final postsProvider =
    AsyncNotifierProvider.family<PostsNotifier, List<Post>, String>(() {
  return PostsNotifier();
});

class PostsNotifier extends FamilyAsyncNotifier<List<Post>, String> {
  @override
  Future<List<Post>> build(String arg) async {
    // Fetch posts from the repository
    return ref.watch(postRepositoryProvider).getPostsForCommunity(arg);
  }

  // Add an upvote method
  Future<void> upvote(String postId) async {
    final communityId = arg;
    final postRepository = ref.read(postRepositoryProvider);
    await postRepository.upvote(postId);

    // Invalidate other providers to ensure consistency
    ref.invalidate(homeFeedPostsProvider);
    ref.invalidate(postDetailsProvider(postId));

    // Refresh this provider's state
    state = await AsyncValue.guard(() => build(communityId));
  }

  Future<void> downvote(String postId) async {
    final communityId = arg;
    final postRepository = ref.read(postRepositoryProvider);
    await postRepository.downvote(postId);
    ref.invalidate(homeFeedPostsProvider);
    ref.invalidate(postDetailsProvider(postId));
    state = await AsyncValue.guard(() => build(communityId));
  }
}

// final homeFeedPostsProvider = FutureProvider<List<Post>>((ref) async {
//   final apiService = ref.watch(apiServiceProvider);
//   return apiService.getHomeFeedPosts();
// });

// final postsProvider =
//     FutureProvider.family<List<Post>, String>((ref, communityId) async {
//   final apiService = ref.watch(apiServiceProvider);
//   return apiService.getPostsForCommunity(communityId);
// });

// final postDetailsProvider =
//     FutureProvider.family<Post, String>((ref, postId) async {
//   final apiService = ref.watch(apiServiceProvider);
//   return apiService.getPostDetails(postId);
// });

final commentsProvider =
    FutureProvider.family<List<Comment>, String>((ref, postId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCommentsForPost(postId);
});
