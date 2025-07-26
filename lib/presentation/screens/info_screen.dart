// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsboard/presentation/providers/auth_provider.dart';
import 'package:newsboard/presentation/providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_snackbar.dart';
import 'package:go_router/go_router.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  bool _loading = false;
  String? _error;
  bool _signupSnackShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_signupSnackShown) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == 'signup_success') {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Sign up successful',
                style: TextStyle(color: isDark ? Colors.black : Colors.white),
              ),
              backgroundColor: isDark ? Colors.white : Colors.black,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        _signupSnackShown = true;
      }
    }
  }

  void _continue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final user = ref.read(authStateChangesProvider).asData?.value;
    if (user == null) {
      setState(() {
        _error = 'User not found.';
        _loading = false;
      });
      CustomSnackbar.show(context, message: 'User not found', isError: true);
      return;
    }
    try {
      final updatedUser = user.copyWith(
        firstName: _firstName,
        lastName: _lastName,
      );
      await ref.read(saveUserProvider).call(user: updatedUser);
      if (!mounted) return;
      ref.read(userStateProvider.notifier).state = updatedUser;
      await ref.refresh(currentUserProfileProvider.future);
      if (!mounted) return;
      final name = (updatedUser.firstName != null ||
              updatedUser.lastName != null)
          ? 'Welcome ${updatedUser.firstName ?? ''}${updatedUser.lastName != null ? ' ${updatedUser.lastName}' : ''}!'
          : 'Welcome!';
      CustomSnackbar.show(context, message: name);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile. Please try again.';
      });
      if (!mounted) return;
      CustomSnackbar.show(context,
          message: 'Failed to save profile', isError: true);
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
                Text('Tell us about you',
                    style: theme.textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 24),
                CustomTextFormField(
                  hintText: 'First Name',
                  onChanged: (v) => _firstName = v.trim(),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'First name is required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: 'Last Name',
                  onChanged: (v) => _lastName = v.trim(),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Last name is required' : null,
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
                    label: 'Continue',
                    onPressed: _loading ? null : _continue,
                    loading: _loading,
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
