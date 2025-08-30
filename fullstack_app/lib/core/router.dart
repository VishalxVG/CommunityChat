import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/core/scaffold_nav_bar.dart';
import 'package:fullstack_app/screens/community/community_details_screen.dart';
import 'package:fullstack_app/screens/community/community_list_screen.dart';
import 'package:fullstack_app/screens/community/create_community_screen.dart';
import 'package:fullstack_app/screens/create/create_screen.dart';
import 'package:fullstack_app/screens/home/home_screen.dart';
import 'package:fullstack_app/screens/inbox/inbox_screen.dart';
import 'package:fullstack_app/screens/post/create_post_screen.dart';
import 'package:fullstack_app/screens/post/post_details_screen.dart';
import 'package:fullstack_app/screens/profile/profile_screen.dart';
import 'package:fullstack_app/screens/auth/login_screen.dart'; // Import login
import 'package:fullstack_app/screens/auth/signup_screen.dart'; // Import signup
import 'package:go_router/go_router.dart';

// Private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/', // Start at the login screen
      routes: [
        // Routes that should NOT have the bottom navigation bar
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // This ShellRoute wraps all its child routes with the ScaffoldWithNavBar
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            // These routes WILL have the bottom navigation bar
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
          path: '/community/:id',
          builder: (context, state) {
            final communityId = state.pathParameters['id']!;
            return CommunityDetailsScreen(communityId: communityId);
          },
        ),
        GoRoute(
          path: '/create-community',
          builder: (context, state) => const CreateCommunityScreen(),
        ),
        GoRoute(
          path: '/community/:id/create-post',
          builder: (context, state) {
            final communityId = state.pathParameters['id']!;
            return CreatePostScreen(communityId: communityId);
          },
        ),
        GoRoute(
          path: '/post/:id',
          builder: (context, state) {
            final postId = state.pathParameters['id']!;
            return PostDetailsScreen(postId: postId);
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  },
);
