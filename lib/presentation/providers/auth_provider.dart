import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/firebase_auth_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../domain/entities/app_user.dart';
import 'user_profile_provider.dart';

final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  return FirebaseAuthDatasource();
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final datasource = ref.watch(firebaseAuthDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

final signUpProvider = Provider<SignUp>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUp(repo);
});

final signInProvider = Provider<SignIn>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignIn(repo);
});

final signOutProvider = Provider<SignOut>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignOut(repo);
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final stream = repo.user;
  stream.listen((user) async {
    if (user != null) {
      final getUserProfile = ref.read(getUserProfileProvider);
      final profile = await getUserProfile.call(user.uid);
      ref.read(userProfileStateProvider.notifier).state = profile;
    } else {
      ref.read(userProfileStateProvider.notifier).state = null;
    }
  });
  return stream;
});
