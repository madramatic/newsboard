import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? firstName;
  final String? lastName;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.firstName,
    this.lastName,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      firstName: firstName,
      lastName: lastName,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      firstName: user.firstName,
      lastName: user.lastName,
    );
  }
}
