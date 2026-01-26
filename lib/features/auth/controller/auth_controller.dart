import '../model/user_model.dart';
import '../service/auth_service.dart';
import '../service/fake_auth_service.dart';

class AuthController {
  final AuthService _service;

  AuthController({AuthService? service}) : _service = service ?? FakeAuthService();

  Future<UserModel> startSession({
    required String alias,
    required String role,
    required String title,
  }) {
    return _service.startSession(alias: alias, role: role, title: title);
  }
}
