class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? firstName;
  final String? lastName;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.firstName,
    this.lastName,
  });

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? firstName,
    String? lastName,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
