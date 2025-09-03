import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/core/scaffold_nav_bar.dart';
import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:fullstack_app/screens/community/community_details_screen.dart';
import 'package:fullstack_app/screens/community/community_list_screen.dart';
import 'package:fullstack_app/screens/community/create_community_screen.dart';
import 'package:fullstack_app/screens/create/create_screen.dart';
import 'package:fullstack_app/screens/home/home_screen.dart';
import 'package:fullstack_app/screens/inbox/inbox_screen.dart';
import 'package:fullstack_app/screens/post/create_post_screen.dart';
import 'package:fullstack_app/screens/post/post_details_screen.dart';
import 'package:fullstack_app/screens/profile/my_communities_screen.dart';
import 'package:fullstack_app/screens/profile/my_post_screen.dart';
import 'package:fullstack_app/screens/profile/profile_screen.dart';
import 'package:fullstack_app/screens/auth/login_screen.dart';
import 'package:fullstack_app/screens/auth/signup_screen.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isAuthenticated && !isLoggingIn) return '/login';
      if (isAuthenticated && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/communities',
            builder: (context, state) => const CommunityListScreen(),
          ),
          GoRoute(
            path: '/create',
            builder: (context, state) => const CreateScreen(),
          ),
          GoRoute(
            path: '/inbox',
            builder: (context, state) => const InboxScreen(),
          ),
        ],
      ),
      // Other top-level routes that appear over the shell (no nav bar)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey, // Add this
        path: '/community/:id',
        builder: (context, state) {
          final communityId = state.pathParameters['id']!;
          return CommunityDetailsScreen(communityId: communityId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey, // Add this
        path: '/create-community',
        builder: (context, state) => const CreateCommunityScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey, // Add this
        path: '/community/:id/create-post',
        builder: (context, state) {
          final communityId = state.pathParameters['id']!;
          return CreatePostScreen(communityId: communityId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey, // Add this
        path: '/post/:id',
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return PostDetailsScreen(postId: postId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey, // Add this
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        // ADD THESE NESTED ROUTES
        routes: [
          GoRoute(
            path: 'my-communities', // This becomes /profile/my-communities
            builder: (context, state) => const MyCommunitiesScreen(),
          ),
          GoRoute(
            path: 'my-posts', // This becomes /profile/my-posts
            builder: (context, state) => const MyPostsScreen(),
          ),
        ],
      ),
    ],
  );
});
