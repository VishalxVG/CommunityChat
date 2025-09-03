import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/post.dart';
import 'package:fullstack_app/providers/feed_providers.dart';

final myPostsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final postsJson = await apiService.getMyPosts();
  return (postsJson).map((json) => Post.fromJson(json)).toList();
});
