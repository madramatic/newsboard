import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<User> signUp({required String email, required String password}) {
    return datasource.signUp(email: email, password: password);
  }

  @override
  Future<User> signIn({required String email, required String password}) {
    return datasource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return datasource.signOut();
  }

  @override
  Stream<User?> get user => datasource.user;
}
