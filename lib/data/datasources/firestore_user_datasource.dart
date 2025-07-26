import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/news_model.dart';

class FirestoreUserDatasource {
  final FirebaseFirestore _firestore;
  FirestoreUserDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveUser({
    required UserModel user,
  }) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    data['id'] = uid;
    return UserModel.fromMap(data);
  }

  // Save an article for a user (prevents duplicates)
  Future<void> saveArticle({
    required String uid,
    required NewsModel article,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_articles')
        .doc(article.articleId);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set(article.toJson());
    }
  }

  // Fetch all saved articles for a user
  Future<List<NewsModel>> fetchSavedArticles({
    required String uid,
  }) async {
    final query = await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_articles')
        .get();
    return query.docs.map((doc) => NewsModel.fromJson(doc.data())).toList();
  }

  // Remove a saved article for a user
  Future<void> removeSavedArticle({
    required String uid,
    required String articleId,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_articles')
        .doc(articleId)
        .delete();
  }
}
