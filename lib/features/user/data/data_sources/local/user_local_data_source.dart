
import 'package:red_social_prueba/features/user/domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<bool> saveUserLocal(User user);
  Future<bool> deleteUserLocal(int id);
  Future<User> getUserLocal(int id);
}
