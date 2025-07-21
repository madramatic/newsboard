import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(signUpProvider).call(email: _email, password: _password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signup successful',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _error = 'Signup failed. Please try again.';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signup failed',
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'newsboard',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/icons/home-fill.png'
                          : 'assets/icons/home-fill.png',
                      width: 28,
                      height: 28,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : null,
                    ),
                    const SizedBox(width: 60),
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/icons/chat-fill.png'
                          : 'assets/icons/chat-fill.png',
                      width: 28,
                      height: 28,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : null,
                    ),
                    const SizedBox(width: 60),
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/icons/save-fill.png'
                          : 'assets/icons/save-fill.png',
                      width: 28,
                      height: 28,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : null,
                    ),
                    const SizedBox(width: 60),
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/icons/user-fill.png'
                          : 'assets/icons/user-fill.png',
                      width: 28,
                      height: 28,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Text('Sign up',
                    style: theme.textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 24),
                CustomTextFormField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => _email = v.trim(),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(v)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: 'Password',
                  obscureText: !_showPassword,
                  onChanged: (v) => _password = v,
                  validator: (v) => v != null && v.length >= 6
                      ? null
                      : 'Password must be at least 6 characters',
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: 'Confirm Password',
                  obscureText: !_showConfirmPassword,
                  onChanged: (v) {},
                  validator: (v) =>
                      v == _password ? null : 'Passwords do not match',
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: TextStyle(color: theme.colorScheme.error)),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Sign Up',
                    onPressed: _loading ? null : _signup,
                    loading: _loading,
                  ),
                ),
                const SizedBox(height: 40),
                const Text("Already have a newsboard account?"),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    "Sign in",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
