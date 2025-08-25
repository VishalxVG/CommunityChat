import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/repossitories/community_repository.dart';
import 'package:fullstack_app/services/api_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// final communitiesProvider = FutureProvider<List<Community>>((ref) async {
//   final apiService = ref.watch(apiServiceProvider);
//   return apiService.getCommunities();
// });

// 1. Create a provider for the repository
final communityRepositoryProvider = Provider<ICommunityRepository>((ref) {
  return InMemoryCommunityRepository();
});

// 2. Convert 'communitiesProvider' to an AsyncNotifierProvider
final communitiesProvider =
    AsyncNotifierProvider<CommunitiesNotifier, List<Community>>(() {
  return CommunitiesNotifier();
});

class CommunitiesNotifier extends AsyncNotifier<List<Community>> {
  @override
  Future<List<Community>> build() async {
    return ref.watch(communityRepositoryProvider).getCommunities();
  }

  // 3. Add a method to create a community
  Future<void> createCommunity(String name, String description) async {
    final communityRepository = ref.read(communityRepositoryProvider);
    await communityRepository.createCommunity(name, description);

    // Refresh the list to show the new community
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final communityDetailsProvider =
    FutureProvider.family<Community, String>((ref, communityId) async {
  // Change the source from apiServiceProvider to the repository
  final communityRepository = ref.watch(communityRepositoryProvider);
  return communityRepository.getCommunityDetails(communityId);
});
