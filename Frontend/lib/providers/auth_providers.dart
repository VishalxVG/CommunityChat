import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fullstack_app/models/user.dart';
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
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._apiService) : super(AuthState()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _apiService.setAuthToken(token);
      state = AuthState(isAuthenticated: true, token: token);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      final token = response['access_token'];
      await _storage.write(key: 'auth_token', value: token);
      _apiService.setAuthToken(token);
      state = AuthState(isAuthenticated: true, token: token);
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
}
