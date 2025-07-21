import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/firestore_user_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirestoreUserDatasource datasource;
  UserProfileRepositoryImpl(this.datasource);

  @override
  Future<void> saveUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
  }) {
    return datasource.saveUserProfile(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    final data = await datasource.getUserProfile(uid);
    if (data == null) return null;
    return UserProfile(
      uid: uid,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
