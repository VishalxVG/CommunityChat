import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/community_providers.dart';
import 'package:fullstack_app/widgets/custom_button.dart';
import 'package:fullstack_app/widgets/custom_text_filed.dart';
import 'package:go_router/go_router.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  void _createCommunity() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(communitiesProvider.notifier).createCommunity(
            _nameController.text,
            _descriptionController.text,
          );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        if (kDebugMode) {
          print(e.toString());
        }
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
      appBar: AppBar(title: const Text('Create Community')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              hintText: 'Community Name',
              isObscure: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              hintText: 'Description',
              maxLines: 4,
              isObscure: false,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Create Community',
              onPressed: _createCommunity,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
