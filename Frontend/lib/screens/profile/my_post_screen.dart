import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/profile_provider.dart';
import 'package:fullstack_app/widgets/post_card.dart';
import 'package:go_router/go_router.dart';

class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPostsAsync = ref.watch(myPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Posts')),
      body: myPostsAsync.when(
        data: (posts) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(myPostsProvider),
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                post: post,
                onTap: () => context.push('/post/${post.id}'),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
