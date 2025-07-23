import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsboard/presentation/providers/auth_provider.dart';
import 'package:newsboard/presentation/providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
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
      return;
    }
    try {
      await ref.read(saveUserProvider).call(
            user: user.copyWith(
              firstName: _firstName,
              lastName: _lastName,
            ),
          );
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile. Please try again.';
      });
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
