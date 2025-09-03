import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/community.dart'; // Import Community model
import 'package:fullstack_app/providers/auth_providers.dart'; // Import auth provider
import 'package:go_router/go_router.dart';

class CreateScreen extends ConsumerWidget {
  const CreateScreen({super.key});

  // Method to show the community picker bottom sheet
  void _showCommunityPicker(BuildContext context, WidgetRef ref) {
    // Get the list of joined communities directly from the auth provider's state.
    final List<Community> joinedCommunities =
        ref.read(authProvider).user?.communities ?? [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (joinedCommunities.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'You have not joined any communities yet. Join a community to post.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: joinedCommunities.length,
          itemBuilder: (BuildContext context, int index) {
            final community = joinedCommunities[index];
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
