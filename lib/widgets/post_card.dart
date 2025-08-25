import 'package:flutter/material.dart';
import 'package:fullstack_app/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('c/${post.communityName} • Posted by u/${post.author}',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(post.title, style: Theme.of(context).textTheme.titleLarge),
              if (post.text != null) ...[
                const SizedBox(height: 8),
                Text(post.text!, maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
              if (post.imageUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(post.imageUrl!,
                      fit: BoxFit.cover, width: double.infinity, height: 150),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildVoteButtons(),
                  Row(
                    children: [
                      const Icon(Icons.comment_outlined, size: 20),
                      const SizedBox(width: 4),
                      Text('${post.commentCount} Comments'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoteButtons() {
    // UI only, logic would be handled by a provider
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_upward_outlined),
            onPressed: () {/* TODO: Call provider to upvote */}),
        Text(post.upvotes.toString()),
        IconButton(
            icon: const Icon(Icons.arrow_downward_outlined),
            onPressed: () {/* TODO: Call provider to downvote */}),
      ],
    );
  }
}
