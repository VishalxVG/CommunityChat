import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:fullstack_app/widgets/custom_button.dart';
import 'package:fullstack_app/widgets/custom_text_filed.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).login(
          _usernameController.text,
          _passwordController.text,
        );
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the authProvider for changes (errors, success)
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
        if (kDebugMode) {
          print(next.error);
        }
      }
      if (next.isAuthenticated) {
        // Use context.go to replace the navigation stack
        context.go('/');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _usernameController,
              hintText: 'Username',
              isObscure: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              isObscure: true, // Hide password text
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Login',
              onPressed: _loginUser,
              isLoading: _isLoading,
            ),
            TextButton(
              onPressed: () => context.push('/signup'),
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
