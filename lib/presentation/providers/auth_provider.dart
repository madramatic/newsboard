import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/firebase_auth_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../domain/entities/app_user.dart';

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
  return repo.user;
});
