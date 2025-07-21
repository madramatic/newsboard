import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<AppUser> signUp({required String email, required String password}) {
    return datasource.signUp(email: email, password: password);
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) {
    return datasource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return datasource.signOut();
  }

  @override
  Stream<AppUser?> get user => datasource.user;
}
