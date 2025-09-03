import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:fullstack_app/providers/community_providers.dart';
import 'package:fullstack_app/widgets/post_card.dart';
import 'package:go_router/go_router.dart';

// 1. Change to a ConsumerStatefulWidget
class CommunityDetailsScreen extends ConsumerStatefulWidget {
  final String communityId;
  const CommunityDetailsScreen({super.key, required this.communityId});

  @override
  ConsumerState<CommunityDetailsScreen> createState() =>
      _CommunityDetailsScreenState();
}

// 2. Create the State class
class _CommunityDetailsScreenState
    extends ConsumerState<CommunityDetailsScreen> {
  // 3. Add a local loading state variable
  bool _isJoining = false;

  @override
  Widget build(BuildContext context) {
    // Use widget.communityId to access the property
    final communityAsync =
        ref.watch(communityDetailsProvider(widget.communityId));
    final isJoined = ref.watch(authProvider.select(
        (auth) => auth.joinedCommunityIds.contains(widget.communityId)));

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
                        Text(community.description ?? '',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('${community.memberCount ?? 0} members'),
                        const SizedBox(height: 16),
                        // 4. Update the button logic
                        isJoined
                            ? FilledButton.tonal(
                                onPressed:
                                    null, // Disable button if already joined
                                child: const Text('Joined'),
                              )
                            : FilledButton(
                                onPressed:
                                    _isJoining // Disable button while loading
                                        ? null
                                        : () async {
                                            setState(() => _isJoining = true);
                                            try {
                                              await ref
                                                  .read(
                                                      communityActionsProvider)
                                                  .joinCommunity(
                                                      widget.communityId);
                                            } finally {
                                              if (mounted) {
                                                setState(
                                                    () => _isJoining = false);
                                              }
                                            }
                                          },
                                child: _isJoining
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : const Text('Join'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: community.posts?.length ?? 0,
            itemBuilder: (context, index) {
              final post = community.posts![index];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/community/${widget.communityId}/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
