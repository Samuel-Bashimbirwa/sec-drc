import 'package:get/get.dart';

import '../../contracts/alert_service.dart';
import '../../backends/fake/fake_alert_service.dart';

import '../../features/acting/controller/alert_controller.dart';
import '../../features/acting/controller/location_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services (fake backend)
    Get.lazyPut<AlertService>(() => FakeAlertService(), fenix: true);

    // Controllers
    Get.put(AlertController(Get.find<AlertService>()), permanent: true);

    // Ton LocationController existe déjà (ChangeNotifier). On le garde, mais on l’injecte.
    Get.put(LocationController(), permanent: true);
  }
}