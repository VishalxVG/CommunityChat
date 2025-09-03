import 'package:flutter/material.dart';
import 'package:fullstack_app/models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // CircleAvatar(radius: 14, child: Text(comment.author[0])),
              const SizedBox(width: 8),
              // Text(comment.author,
              //     style: Theme.of(context).textTheme.titleSmall),
              // const SizedBox(width: 8),
              Text('• 2h ago', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(comment.text),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_upward_outlined, size: 20),
                    onPressed: () {}),
                // Text(comment.upvotes.toString()),
                IconButton(
                    icon: const Icon(Icons.arrow_downward_outlined, size: 20),
                    onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }
}
