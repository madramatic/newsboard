import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsboard/data/repositories/user_repository_impl.dart';
import 'package:newsboard/domain/usecases/user_usecases.dart';
import 'package:newsboard/presentation/providers/auth_provider.dart';
import '../../data/datasources/firestore_user_datasource.dart';
import '../../domain/entities/user.dart';
import 'package:newsboard/domain/entities/news.dart';

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

final currentUserProfileProvider = FutureProvider<User?>((ref) async {
  final authState = await ref.watch(authStateChangesProvider.future);
  if (authState == null) return null;
  final getUser = ref.read(getUserProvider);
  return getUser.call(authState.id);
});

final saveArticleProvider = Provider<SaveArticle>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return SaveArticle(repo);
});

final fetchSavedArticlesProvider = Provider<FetchSavedArticles>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return FetchSavedArticles(repo);
});

final removeSavedArticleProvider = Provider<RemoveSavedArticle>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return RemoveSavedArticle(repo);
});

final savedArticlesListProvider =
    FutureProvider.family<List<News>, String>((ref, uid) async {
  final fetchSaved = ref.watch(fetchSavedArticlesProvider);
  return fetchSaved.call(uid: uid);
});

final articleSaveLoadingProvider =
    StateProvider<Map<String, bool>>((ref) => {});
