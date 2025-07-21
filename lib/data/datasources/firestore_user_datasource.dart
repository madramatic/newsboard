import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserDatasource {
  final FirebaseFirestore _firestore;
  FirestoreUserDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }
}
