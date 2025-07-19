
import 'dart:convert';

import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/user/data/data_sources/local/user_local_data_source.dart';
import 'package:red_social_prueba/features/user/data/models/user_model.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferenceDataSourceImpl implements UserLocalDataSource {
  @override
  Future<bool> deleteUserLocal(int id) async {
    try {
      final shared = await SharedPreferences.getInstance();
      return await shared.remove(id.toString());
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<bool> saveUserLocal(User user) async {
    try {
      final shared = await SharedPreferences.getInstance();
      final userModel =
          UserModel(id: user.id, email: user.email, password: user.password);
      final userJson = jsonEncode(userModel.toJson());
      return await shared.setString(user.id.toString(), userJson);
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<User> getUserLocal(int id) async {
    final shared = await SharedPreferences.getInstance();
    final userJson = shared.getString(id.toString());
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    } else {
      throw LocalFailure();
    }
  }
}
