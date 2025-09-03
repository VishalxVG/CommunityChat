import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullstack_app/providers/auth_providers.dart';
import 'package:fullstack_app/widgets/custom_button.dart';
import 'package:fullstack_app/widgets/custom_text_filed.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _signupUser() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).signUp(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        context.go('/');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
              controller: _emailController,
              hintText: 'Email',
              isObscure: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                isObscure: true),
            const SizedBox(height: 24),
            CustomButton(
                text: 'Sign Up', onPressed: _signupUser, isLoading: _isLoading),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
