import 'package:flutter/material.dart';
import 'package:fullstack_app/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onUpvote,
    this.onDownvote,
  });

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
              // Use the nested community and author objects
              Text(
                  'c/${post.community.name} • Posted by u/${post.author.username}',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(post.title, style: Theme.of(context).textTheme.titleLarge),
              if (post.text != null && post.text!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(post.text!, maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
              // This part for image is commented out as the backend schema does not have it yet
              // if (post.imageUrl != null) ...[
              //   const SizedBox(height: 12),
              //   ClipRRect(
              //     borderRadius: BorderRadius.circular(8),
              //     child: Image.network(post.imageUrl!,
              //         fit: BoxFit.cover, width: double.infinity, height: 150),
              //   ),
              // ],
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
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_upward_outlined),
          onPressed: onUpvote,
        ),
        Text(post.upvotes.toString()),
        IconButton(
          icon: const Icon(Icons.arrow_downward_outlined),
          onPressed: onDownvote,
        ),
      ],
    );
  }
}
