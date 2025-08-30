import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/community_providers.dart';
import 'package:fullstack_app/providers/post_providers.dart';
import 'package:fullstack_app/widgets/post_card.dart';
import 'package:go_router/go_router.dart';

class CommunityDetailsScreen extends ConsumerWidget {
  final String communityId;
  const CommunityDetailsScreen({super.key, required this.communityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityAsync = ref.watch(communityDetailsProvider(communityId));
    final postsAsync = ref.watch(postsProvider(communityId));

    return Scaffold(
      body: communityAsync.when(
        data: (community) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(community.name),
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(top: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(community.description,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('${community.memberCount} members'),
                        const SizedBox(height: 16),
                        FilledButton(
                            onPressed: () {}, child: const Text('Join')),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: postsAsync.when(
            data: (posts) => ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  post: post,
                  onTap: () => context.push('/post/${post.id}'),
                  onUpvote: () => ref
                      .read(postsProvider(communityId).notifier)
                      .upvote(post.id),
                  onDownvote: () => ref
                      .read(postsProvider(communityId).notifier)
                      .downvote(post.id),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/community/$communityId/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
