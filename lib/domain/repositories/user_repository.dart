import '../entities/user.dart';
import '../entities/news.dart';

abstract class UserRepository {
  Future<void> saveUser({required User user});
  Future<User?> getUser(String uid);
  Future<void> saveArticle({required String uid, required News article});
  Future<List<News>> fetchSavedArticles({required String uid});
  Future<void> removeSavedArticle(
      {required String uid, required String articleId});
}
