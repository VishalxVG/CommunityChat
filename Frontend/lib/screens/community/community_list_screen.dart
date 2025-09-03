import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:fullstack_app/providers/community_providers.dart';
import 'package:fullstack_app/widgets/community__card.dart';
import 'package:go_router/go_router.dart';

class CommunityListScreen extends ConsumerWidget {
  const CommunityListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesAsync = ref.watch(communitiesProvider);
    final joinedCommunityIds = ref.watch(authProvider).joinedCommunityIds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: communitiesAsync.when(
        data: (communities) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(communitiesProvider);
          },
          child: ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final community = communities[index];
              final bool isJoined = joinedCommunityIds.contains(community.id);

              return CommunityCard(
                community: community,
                onTap: () => context.push('/community/${community.id}'),
                isJoined: isJoined,
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-community'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
