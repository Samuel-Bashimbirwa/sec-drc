import 'package:get/get.dart';

import '../../backends/fake/fake_alert_service.dart';
import '../../contracts/alert_service.dart';
import '../../features/acting/controller/alert_controller.dart';
import '../../features/acting/controller/location_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<AlertService>(FakeAlertService(), permanent: true);

    // Controllers
    Get.put(LocationController(), permanent: true);
    Get.put(AlertController(Get.find<AlertService>()), permanent: true);
  }
}