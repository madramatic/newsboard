import '../repositories/user_profile_repository.dart';

class SaveUserProfile {
  final UserProfileRepository repository;
  SaveUserProfile(this.repository);

  Future<void> call({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
  }) {
    return repository.saveUserProfile(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }
}

class GetUserProfile {
  final UserProfileRepository repository;
  GetUserProfile(this.repository);

  Future<UserProfile?> call(String uid) {
    return repository.getUserProfile(uid);
  }
}
