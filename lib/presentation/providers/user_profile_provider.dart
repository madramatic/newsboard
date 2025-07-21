import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsboard/domain/repositories/user_profile_repository.dart';
import '../../data/datasources/firestore_user_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/usecases/user_profile_usecases.dart';

final firestoreUserDatasourceProvider =
    Provider<FirestoreUserDatasource>((ref) {
  return FirestoreUserDatasource();
});

final userProfileRepositoryProvider =
    Provider<UserProfileRepositoryImpl>((ref) {
  final datasource = ref.watch(firestoreUserDatasourceProvider);
  return UserProfileRepositoryImpl(datasource);
});

final saveUserProfileProvider = Provider<SaveUserProfile>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return SaveUserProfile(repo);
});

final getUserProfileProvider = Provider<GetUserProfile>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return GetUserProfile(repo);
});

final userProfileStateProvider = StateProvider<UserProfile?>((ref) => null);
