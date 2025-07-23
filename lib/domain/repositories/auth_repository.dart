import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp({required String email, required String password});
  Future<User> signIn({required String email, required String password});
  Future<void> signOut();
  Stream<User?> get user;
}
