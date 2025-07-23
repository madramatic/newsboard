import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../domain/entities/user.dart';

class FirebaseAuthDatasource {
  final fb_auth.FirebaseAuth _firebaseAuth;
  FirebaseAuthDatasource({fb_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance;

  Future<User> signUp({required String email, required String password}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return User(
      id: user.uid,
      email: user.email ?? '',
    );
  }

  Future<User> signIn({required String email, required String password}) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return User(
      id: user.uid,
      email: user.email ?? '',
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((user) =>
        user != null ? User(id: user.uid, email: user.email ?? '') : null);
  }
}
