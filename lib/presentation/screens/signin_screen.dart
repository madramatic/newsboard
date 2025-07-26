import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newsboard/presentation/providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text_form_field.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;
  bool _showPassword = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userCred = await ref
          .read(signInProvider)
          .call(email: _email, password: _password);
      if (!mounted) return;
      final getUser = ref.read(getUserProvider);
      final userProfile = await getUser.call(userCred.id);
      if (!mounted) return;
      final name = userProfile != null &&
              (userProfile.firstName != null || userProfile.lastName != null)
          ? 'Welcome ${userProfile.firstName ?? ''}${userProfile.lastName != null ? ' ${userProfile.lastName}' : ''}!'
          : 'Welcome!';
      CustomSnackbar.show(context, message: name);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      setState(() {
        _error = 'Login failed. Please check your credentials.';
      });
      if (!mounted) return;
      CustomSnackbar.show(context, message: 'Login failed', isError: true);
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
                Text('Sign in',
                    style: theme.textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 24),
                CustomTextFormField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => _email = v.trim(),
                  validator: (v) => v != null && v.contains('@')
                      ? null
                      : 'Enter a valid email',
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
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: TextStyle(color: theme.colorScheme.error)),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Sign In',
                    onPressed: _loading ? null : _login,
                    loading: _loading,
                  ),
                ),
                const SizedBox(height: 40),
                const Text("Don't have a newsboard account?"),
                TextButton(
                  onPressed: _loading ? null : () => context.go('/signup'),
                  child: Text(
                    "Sign up",
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
