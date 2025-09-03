import 'package:flutter/material.dart';
import 'package:fullstack_app/models/community.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback onTap;
  final bool isJoined; // Add this

  const CommunityCard(
      {super.key,
      required this.community,
      required this.onTap,
      required this.isJoined});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(community.imageUrl),
                onBackgroundImageError: (_, __) {}, // Handle image load error
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(community.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('${community.memberCount} members',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (isJoined)
                Icon(Icons.check_circle, color: Colors.green.shade600),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
