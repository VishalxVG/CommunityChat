import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/post_providers.dart'; // Ensure this is imported
import 'package:fullstack_app/widgets/custom_button.dart';
import 'package:fullstack_app/widgets/custom_text_filed.dart';
import 'package:go_router/go_router.dart'; // Import for context.pop()

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
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Use the new postActionsProvider to call the createPost method
      await ref.read(postActionsProvider).createPost(
            communityId: widget.communityId,
            title: _titleController.text.trim(),
            text: _contentController.text.trim().isEmpty
                ? null
                : _contentController.text.trim(),
          );

      // If successful, pop the screen to return to the community page
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            CustomTextField(
              controller: _titleController,
              hintText: 'Title',
              isObscure: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _contentController,
              hintText: 'Text (optional)',
              maxLines: 8,
              isObscure: false,
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
