import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../routes/app_routes.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController(this._authService);

  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  Future<void> login(String email, String password) async {
    try {
      loading.value = true;
      error.value = null;
      await _authService.login(email: email, password: password);
      
      Get.offAllNamed(AppRoutes.actingHome);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        error.value = "Identifiants incorrects.";
      } else {
        error.value = "Erreur de connexion. Vérifiez votre réseau.";
      }
    } catch (e) {
      error.value = "Une erreur est survenue.";
    } finally {
      loading.value = false;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    String? address,
    String? birthDate,
  }) async {
    try {
      loading.value = true;
      error.value = null;
      await _authService.register(
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
        address: address,
        birthDate: birthDate,
      );

      // Auto routing vers home après register réussi
      Get.offAllNamed(AppRoutes.actingHome);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        error.value = "Cet email est déjà utilisé.";
      } else {
        error.value = "Erreur lors de l'inscription.";
      }
    } catch (e) {
      error.value = "Une erreur est survenue.";
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.authLogin);
  }
}
