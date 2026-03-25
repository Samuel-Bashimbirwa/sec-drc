import '../../../common/api_client.dart';
import '../../../common/storage_service.dart';
import '../model/user_model.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient _api;
  final StorageService _storage;

  AuthService(this._api, this._storage);

  Future<void> register({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? address,
    String? birthDate, // format YYYY-MM-DD
  }) async {
    final response = await _api.post('/auth/register', data: {
      'email': email,
      'password': password,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'address_reference': address,
      'birth_date': birthDate,
    });
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      await _storage.saveToken(data['access_token']);
      if (data['user'] != null) {
        await _storage.saveUser(UserModel.fromJson(data['user']));
      } else {
        await getMe(); // safe fallback
      }
    } else {
      throw DioException(requestOptions: response.requestOptions, response: response);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      await _storage.saveToken(data['access_token']);
      if (data['user'] != null) {
        await _storage.saveUser(UserModel.fromJson(data['user']));
      } else {
        await getMe(); // fetch User profile info
      }
    } else {
      throw DioException(requestOptions: response.requestOptions, response: response);
    }
  }

  Future<UserModel> getMe() async {
    final response = await _api.get('/auth/me');
    if (response.statusCode == 200) {
      final user = UserModel.fromJson(response.data);
      await _storage.saveUser(user);
      return user;
    } else {
      throw DioException(requestOptions: response.requestOptions, response: response);
    }
  }

  Future<void> logout() async {
    try {
      if (_storage.token != null) {
        await _api.post('/auth/logout');
      }
    } catch (e) {
      // Ignore errors on logout
    } finally {
      await _storage.clear();
    }
  }
}
