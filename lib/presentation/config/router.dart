import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../screens/home_screen.dart';
import '../screens/details/news_details_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/info_screen.dart';
import 'package:flutter/material.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    return userProfileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const SigninScreen();
        } else if (profile.firstName == null ||
            profile.firstName!.isEmpty ||
            profile.lastName == null ||
            profile.lastName!.isEmpty) {
          return const InfoScreen();
        } else {
          return const HomeScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final news = state.extra as dynamic;
            return NewsDetailsScreen(news: news);
          },
        ),
        GoRoute(
          path: 'login',
          builder: (context, state) => const SigninScreen(),
        ),
        GoRoute(
          path: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: 'info',
          builder: (context, state) => const InfoScreen(),
        ),
      ],
    ),
  ],
);
