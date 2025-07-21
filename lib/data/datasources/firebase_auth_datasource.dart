import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/app_user.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;
  FirebaseAuthDatasource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<AppUser> signUp(
      {required String email, required String password}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return AppUser(uid: user.uid, email: user.email ?? '');
  }

  Future<AppUser> signIn(
      {required String email, required String password}) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return AppUser(uid: user.uid, email: user.email ?? '');
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<AppUser?> get user {
    return _firebaseAuth.authStateChanges().map((user) =>
        user != null ? AppUser(uid: user.uid, email: user.email ?? '') : null);
  }
}
