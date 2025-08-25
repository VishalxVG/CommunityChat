import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // TODO: Replace with a community selector that navigates
            // to the create post screen for that community.
            ElevatedButton(
              onPressed: () {
                // For now, navigates to create a post in a default community
                context.push('/community/1/create-post');
              },
              child: const Text('Choose a Community'),
            )
          ],
        ),
      ),
    );
  }
}
