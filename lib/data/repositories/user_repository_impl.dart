import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore_user_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreUserDatasource datasource;
  UserRepositoryImpl(this.datasource);

  @override
  Future<void> saveUser({
    required User user,
  }) {
    return datasource.saveUser(user: UserModel.fromEntity(user));
  }

  @override
  Future<User?> getUser(String uid) async {
    final userModel = await datasource.getUser(uid);
    return userModel?.toEntity();
  }
}
