abstract class UserProfileRepository {
  Future<void> saveUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
  });
  Future<UserProfile?> getUserProfile(String uid);
}

class UserProfile {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;

  UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}
