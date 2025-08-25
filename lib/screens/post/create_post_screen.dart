import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:fullstack_app/providers/post_providers.dart'; // Import providers
import 'package:fullstack_app/widgets/custom_button.dart';
import 'package:fullstack_app/widgets/custom_text_filed.dart';

// Change to a ConsumerStatefulWidget
class CreatePostScreen extends ConsumerStatefulWidget {
  final String communityId;
  const CreatePostScreen({super.key, required this.communityId});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  void _createPost() async {
    if (_titleController.text.trim().isEmpty) return; // Basic validation

    setState(() => _isLoading = true);

    // Call the notifier method to create the post
    await ref.read(postsProvider(widget.communityId).notifier).createPost(
          title: _titleController.text.trim(),
          text: _contentController.text.trim().isEmpty
              ? null
              : _contentController.text.trim(),
        );

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: _titleController, hintText: 'Title'),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _contentController,
              hintText: 'Text (optional)',
              maxLines: 8,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Post',
              onPressed: _createPost,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
