import 'dart:math';
import 'auth_service.dart';
import '../model/user_model.dart';

class FakeAuthService implements AuthService {
  @override
  Future<UserModel> startSession({
    required String alias,
    required String role,
    required String title,
  }) async {
    // Simulation réseau
    await Future.delayed(const Duration(milliseconds: 600));

    final id = 'dev-${Random().nextInt(999999).toString().padLeft(6, '0')}';

    return UserModel(
      id: id,
      alias: alias.isEmpty ? 'Utilisateur' : alias,
      role: role,
      title: title.isEmpty ? (role == 'acteur' ? 'Acteur' : 'Superviseur') : title,
    );
  }
}

