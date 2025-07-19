import 'package:red_social_prueba/features/user/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.email, required super.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}
