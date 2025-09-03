import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/providers/feed_providers.dart';

// Provider to manage the list of all communities
final communitiesProvider =
    StateNotifierProvider<CommunitiesNotifier, AsyncValue<List<Community>>>(
        (ref) {
  return CommunitiesNotifier(ref);
});

class CommunitiesNotifier extends StateNotifier<AsyncValue<List<Community>>> {
  final Ref _ref;
  CommunitiesNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchCommunities();
  }

  Future<void> _fetchCommunities() async {
    try {
      final apiService = _ref.read(apiServiceProvider);
      final communitiesJson = await apiService.getCommunitites();
      final communities =
          (communitiesJson).map((json) => Community.fromJson(json)).toList();
      state = AsyncValue.data(communities);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> createCommunity(String name, String description) async {
    final apiService = _ref.read(apiServiceProvider);
    try {
      await apiService.createCommunity(name, description);

      // THE FIX: Instead of invalidating, just re-run the fetch logic.
      // This will update the state with the new list, including the community you just created.

      await _ref.read(authProvider.notifier).refreshUser();

      await _fetchCommunities();
    } catch (e) {
      // Re-throw the error so the UI can catch it and show a message.
      rethrow;
    }
  }
}

// Provider to get details for a single community
final communityDetailsProvider = FutureProvider.autoDispose
    .family<Community, String>((ref, communityId) async {
  final apiService = ref.watch(apiServiceProvider);
  final communityJson = await apiService.getCommunityDetails(communityId);
  return Community.fromJson(communityJson);
});

// Provider for Join Community action
final communityActionsProvider =
    Provider((ref) => CommunityActionsController(ref));

class CommunityActionsController {
  final Ref _ref;
  CommunityActionsController(this._ref);

  Future<void> joinCommunity(String communityId) async {
    final apiService = _ref.read(apiServiceProvider);
    try {
      await apiService.joinCommunity(communityId);

      // THIS IS THE FIX: Refresh the user's profile to get the updated list of joined communities.
      await _ref.read(authProvider.notifier).refreshUser();

      // These invalidations are still useful to update member count and the feed.
      _ref.invalidate(communityDetailsProvider(communityId));
      // REMOVE THE LINE BELOW. The feedProvider will update automatically
      // when the authProvider state changes.
      // _ref.invalidate(feedProvider);
    } catch (e) {
      rethrow;
    }
  }
}
