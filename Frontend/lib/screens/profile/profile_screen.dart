import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          // TODO: Fetch user data from backend
          const ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text('Joined Communities'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text('My Posts'),
            trailing: Icon(Icons.chevron_right),
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
              // Call the logout method from the AuthNotifier
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
