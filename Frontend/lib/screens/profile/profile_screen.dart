import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import the intl package

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the authProvider to get the current user's state
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      // Use a conditional check to show a loader while user data might be loading
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // --- User Info Header ---
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        // Display the first letter of the username
                        child: Text(
                          user.username[0].toUpperCase(),
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'u/${user.username}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (user.createdAt != null)
                        Text(
                          'Joined ${DateFormat.yMMMMd().format(user.createdAt!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                const Divider(),
                // --- Actionable List ---
                ListView(
                  shrinkWrap: true, // Important inside a Column
                  children: [
                    ListTile(
                      leading: Icon(Icons.group_outlined),
                      title: Text('Joined Communities'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => context.push('/profile/my-communities'),
                    ),
                    ListTile(
                      leading: Icon(Icons.article_outlined),
                      title: Text('My Posts'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => context.push('/profile/my-posts'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text('Settings'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red.shade400),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                      onTap: () {
                        ref.read(authProvider.notifier).logout();
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
