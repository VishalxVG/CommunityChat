import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/post.dart';
import 'package:fullstack_app/providers/auth_providers.dart';

// Re-export the apiServiceProvider for easy access
export 'package:fullstack_app/providers/auth_providers.dart'
    show apiServiceProvider;

final feedProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  // Watch the auth state. If the user logs out, this provider will be disposed.
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated) {
    return []; // Return empty list if not authenticated
  }

  final apiService = ref.read(apiServiceProvider);
  final feedData = await apiService.getFeed();

  // Parse the JSON list into a List of Post objects
  return (feedData).map((postJson) => Post.fromJson(postJson)).toList();
});
