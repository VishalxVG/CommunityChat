import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/models/user.dart';
import 'package:fullstack_app/providers/community_providers.dart';
import 'package:fullstack_app/providers/feed_providers.dart';
import 'package:fullstack_app/services/api_services.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider));
});

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final User? user;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.user,
    this.error,
  });

  Set<String> get joinedCommunityIds =>
      user?.communities.map((c) => c.id).toSet() ?? {};
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._apiService) : super(AuthState()) {
    _loadTokenAndUser();
  }

  Future<void> _loadTokenAndUser() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _apiService.setAuthToken(token);
      try {
        final userJson = await _apiService.getMe();
        final user = User.fromJson(userJson);
        state = AuthState(isAuthenticated: true, token: token, user: user);
      } catch (e) {
        // Token might be invalid, log out
        logout();
      }
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      final token = response['access_token'];
      await _storage.write(key: 'auth_token', value: token);
      _apiService.setAuthToken(token);
      final userJson = await _apiService.getMe();
      final user = User.fromJson(userJson);

      state = AuthState(
        isAuthenticated: true,
        token: token,
        user: user,
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> signUp(
      {required String username,
      required String email,
      required String password}) async {
    try {
      await _apiService.signUp(
          username: username, email: email, password: password);
      // After successful signup, log the user in
      await login(username, password);
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _apiService.setAuthToken('');
    state = AuthState();
  }

  Future<void> refreshUser() async {
    // Only refresh if the user is authenticated.
    if (state.isAuthenticated) {
      try {
        final userJson = await _apiService.getMe();
        final user = User.fromJson(userJson);
        // Update the state with the new user data, but keep the existing token.
        state =
            AuthState(isAuthenticated: true, token: state.token, user: user);
      } catch (e) {
        // If refreshing the user fails, it might mean the token is expired.
        // For simplicity, we can just print the error. A more robust app might log the user out.
        print("Failed to refresh user data: $e");
      }
    }
  }
}
