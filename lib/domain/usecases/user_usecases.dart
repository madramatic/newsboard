import 'package:newsboard/domain/repositories/user_repository.dart';

import '../entities/user.dart';

class SaveUser {
  final UserRepository repository;
  SaveUser(this.repository);

  Future<void> call({
    required User user,
  }) {
    return repository.saveUser(user: user);
  }
}

class GetUser {
  final UserRepository repository;
  GetUser(this.repository);

  Future<User?> call(String uid) {
    return repository.getUser(uid);
  }
}
