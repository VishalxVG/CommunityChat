import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/services/api_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final communitiesProvider = FutureProvider<List<Community>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCommunities();
});

final communityDetailsProvider =
    FutureProvider.family<Community, String>((ref, communityId) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCommunityDetails(communityId);
});
