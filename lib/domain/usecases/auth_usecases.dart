import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;
  SignUp(this.repository);

  Future<AppUser> call({required String email, required String password}) {
    return repository.signUp(email: email, password: password);
  }
}

class SignIn {
  final AuthRepository repository;
  SignIn(this.repository);

  Future<AppUser> call({required String email, required String password}) {
    return repository.signIn(email: email, password: password);
  }
}

class SignOut {
  final AuthRepository repository;
  SignOut(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}

class AuthStateChanges {
  final AuthRepository repository;
  AuthStateChanges(this.repository);

  Stream<AppUser?> call() => repository.user;
}
