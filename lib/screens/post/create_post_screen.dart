import 'package:flutter/material.dart';
import 'package:fullstack_app/widgets/custom_button.dart';
import 'package:fullstack_app/widgets/custom_text_filed.dart';

class CreatePostScreen extends StatefulWidget {
  final String communityId;
  const CreatePostScreen({super.key, required this.communityId});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  void _createPost() {
    // TODO: Integrate with provider/backend to create post
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
      }
    });
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
                maxLines: 8),
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
