import 'package:newsboard/domain/repositories/user_repository.dart';

import '../entities/news.dart';
import '../entities/user.dart';

class SaveUser {
  final UserRepository repository;
  SaveUser(this.repository);

  Future<void> call({
    required User user,
  }) {
    return repository.saveUser(user: user);
  }
}

class GetUser {
  final UserRepository repository;
  GetUser(this.repository);

  Future<User?> call(String uid) {
    return repository.getUser(uid);
  }
}

class SaveArticle {
  final UserRepository repository;
  SaveArticle(this.repository);
  Future<void> call({required String uid, required News article}) {
    return repository.saveArticle(uid: uid, article: article);
  }
}

class FetchSavedArticles {
  final UserRepository repository;
  FetchSavedArticles(this.repository);
  Future<List<News>> call({required String uid}) {
    return repository.fetchSavedArticles(uid: uid);
  }
}

class RemoveSavedArticle {
  final UserRepository repository;
  RemoveSavedArticle(this.repository);
  Future<void> call({required String uid, required String articleId}) {
    return repository.removeSavedArticle(uid: uid, articleId: articleId);
  }
}
