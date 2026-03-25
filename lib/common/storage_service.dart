import 'package:get_storage/get_storage.dart';
import '../../features/auth/model/user_model.dart';

class StorageService {
  final _box = GetStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  // --- TOKEN ---
  String? get token => _box.read(_tokenKey);

  Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  // --- USER ---
  UserModel? get user {
    final map = _box.read(_userKey);
    if (map == null) return null;
    return UserModel.fromJson(map);
  }

  Future<void> saveUser(UserModel user) async {
    await _box.write(_userKey, user.toJson());
  }

  // --- MISC ---
  bool get isLoggedIn => token != null && user != null;

  Future<void> clear() async {
    await _box.remove(_tokenKey);
    await _box.remove(_userKey);
  }
}
