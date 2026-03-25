import 'package:get/get.dart';

import '../../common/api_client.dart';
import '../../common/storage_service.dart';
import '../../contracts/alert_service.dart';
import '../../features/acting/controller/alert_controller.dart';
import '../../features/acting/controller/location_controller.dart';
import '../../features/acting/service/alert_service_impl.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/service/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put(StorageService(), permanent: true);
    Get.put(ApiClient(Get.find<StorageService>()), permanent: true);

    // Feature Services
    Get.put(AuthService(Get.find<ApiClient>(), Get.find<StorageService>()), permanent: true);
    Get.put<AlertService>(
      AlertServiceImpl(Get.find<ApiClient>()), 
      permanent: true
    );

    // Controllers
    Get.put(AuthController(Get.find<AuthService>()), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(AlertController(Get.find<AlertService>()), permanent: true);
  }
}