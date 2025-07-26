import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore_user_datasource.dart';
import '../models/user_model.dart';
import '../models/news_model.dart';
import '../../domain/entities/news.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreUserDatasource datasource;
  UserRepositoryImpl(this.datasource);

  @override
  Future<void> saveUser({
    required User user,
  }) {
    return datasource.saveUser(user: UserModel.fromEntity(user));
  }

  @override
  Future<User?> getUser(String uid) async {
    final userModel = await datasource.getUser(uid);
    return userModel?.toEntity();
  }

  @override
  Future<void> saveArticle({required String uid, required News article}) {
    return datasource.saveArticle(
      uid: uid,
      article: NewsModel.fromJson(_newsToJson(article)),
    );
  }

  @override
  Future<List<News>> fetchSavedArticles({required String uid}) async {
    final articles = await datasource.fetchSavedArticles(uid: uid);
    return articles;
  }

  @override
  Future<void> removeSavedArticle(
      {required String uid, required String articleId}) {
    return datasource.removeSavedArticle(uid: uid, articleId: articleId);
  }

  Map<String, dynamic> _newsToJson(News news) {
    // Convert News entity to JSON for NewsModel
    return {
      'article_id': news.articleId,
      'title': news.title,
      'link': news.link,
      'keywords': news.keywords,
      'creator': news.creator,
      'description': news.description,
      'content': news.content,
      'pubDate': news.pubDate,
      'pubDateTZ': news.pubDateTZ,
      'image_url': news.imageUrl,
      'video_url': news.videoUrl,
      'source_id': news.sourceId,
      'source_name': news.sourceName,
      'source_priority': news.sourcePriority,
      'source_url': news.sourceUrl,
      'source_icon': news.sourceIcon,
      'language': news.language,
      'country': news.country,
      'category': news.category,
      'duplicate': news.duplicate,
    };
  }
}
