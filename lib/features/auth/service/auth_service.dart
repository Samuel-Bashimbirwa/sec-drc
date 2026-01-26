import '../model/user_model.dart';

abstract class AuthService {
  Future<UserModel> startSession({
    required String alias,
    required String role,
    required String title,
  });
}
