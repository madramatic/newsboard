import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsboard/data/repositories/user_repository_impl.dart';
import 'package:newsboard/domain/usecases/user_usecases.dart';
import '../../data/datasources/firestore_user_datasource.dart';
import '../../domain/entities/user.dart';

final firestoreUserDatasourceProvider =
    Provider<FirestoreUserDatasource>((ref) {
  return FirestoreUserDatasource();
});

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final datasource = ref.watch(firestoreUserDatasourceProvider);
  return UserRepositoryImpl(datasource);
});

final saveUserProvider = Provider<SaveUser>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return SaveUser(repo);
});

final getUserProvider = Provider<GetUser>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return GetUser(repo);
});

final userStateProvider = StateProvider<User?>((ref) => null);
