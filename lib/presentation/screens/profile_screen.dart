import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);
    final theme = Theme.of(context);
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'No user information available.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 60,
              backgroundColor:
                  theme.colorScheme.primary.withAlpha((0.08 * 255).toInt()),
              backgroundImage:
                  user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
              child: user.photoUrl == null || user.photoUrl!.isEmpty
                  ? Icon(Icons.person,
                      size: 48, color: theme.colorScheme.primary)
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              (user.firstName ?? '') +
                  (user.lastName != null ? ' ${user.lastName}' : ''),
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (user.displayName != null && user.displayName!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                user.displayName!,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.email,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Logout',
              onPressed: () async {
                await ref.read(signOutProvider).call();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Logged out successfully',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.surface,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
