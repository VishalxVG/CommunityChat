import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/post_providers.dart';
import 'package:fullstack_app/widgets/comment_title.dart';
import 'package:fullstack_app/widgets/post_card.dart';

class PostDetailsScreen extends ConsumerStatefulWidget {
  final String postId;
  const PostDetailsScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends ConsumerState<PostDetailsScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _postComment() {
    if (_commentController.text.trim().isEmpty) return;

    ref
        .read(commentsProvider(widget.postId).notifier)
        .addComment(text: _commentController.text.trim());

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postDetailsProvider(widget.postId));
    final commentsAsync = ref.watch(commentsProvider(widget.postId));

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            postAsync.when(
              data: (post) => PostCard(
                post: post,
                onTap: () {},
                // Use the new VoteController provider
                onUpvote: () =>
                    ref.read(voteProvider).vote(widget.postId, true),
                onDownvote: () =>
                    ref.read(voteProvider).vote(widget.postId, false),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text(e.toString())),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _postComment,
                  ),
                ),
              ),
            ),
            commentsAsync.when(
              data: (comments) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) =>
                    CommentTile(comment: comments[index]),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text(e.toString())),
            ),
          ],
        ),
      ),
    );
  }
}
