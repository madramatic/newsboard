import '../entities/user.dart';

abstract class UserRepository {
  Future<void> saveUser({required User user});
  Future<User?> getUser(String uid);
}
