import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:fullstack_app/widgets/community__card.dart';
import 'package:go_router/go_router.dart';

class MyCommunitiesScreen extends ConsumerWidget {
  const MyCommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Data is fetched directly from the auth state, no new API call needed
    final communities = ref.watch(authProvider).user?.communities ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('My Communities')),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          final community = communities[index];
          return CommunityCard(
            community: community,
            isJoined:
                true, // User is always joined to communities on this screen
            onTap: () => context.push('/community/${community.id}'),
          );
        },
      ),
    );
  }
}
