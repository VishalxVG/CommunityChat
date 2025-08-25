import 'package:flutter/material.dart';
import 'package:fullstack_app/widgets/custom_button.dart';
import 'package:fullstack_app/widgets/custom_text_filed.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  void _createCommunity() {
    // TODO: Integrate with provider/backend to create community
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
      appBar: AppBar(title: const Text('Create Community')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
                controller: _nameController, hintText: 'Community Name'),
            const SizedBox(height: 16),
            CustomTextField(
                controller: _descriptionController,
                hintText: 'Description',
                maxLines: 4),
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
