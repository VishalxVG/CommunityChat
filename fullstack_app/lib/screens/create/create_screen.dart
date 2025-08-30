import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpo
import 'package:fullstack_app/providers/community_providers.dart'; // Import providers
import 'package:go_router/go_router.dart';

// Change to a ConsumerWidget
class CreateScreen extends ConsumerWidget {
  const CreateScreen({super.key});

  // Method to show the community picker bottom sheet
  void _showCommunityPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Use a Consumer to fetch the communities list
        return Consumer(
          builder: (context, ref, child) {
            final communitiesAsync = ref.watch(communitiesProvider);
            return communitiesAsync.when(
              data: (communities) => ListView.builder(
                itemCount: communities.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = communities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(community.imageUrl),
                    ),
                    title: Text('c/${community.name}'),
                    onTap: () {
                      // Dismiss the bottom sheet
                      Navigator.of(context).pop();
                      // Navigate to the create post screen for the selected community
                      context.push('/community/${community.id}/create-post');
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Where would you like to post?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the function to show the picker
                _showCommunityPicker(context, ref);
              },
              child: const Text('Choose a Community'),
            )
          ],
        ),
      ),
    );
  }
}
