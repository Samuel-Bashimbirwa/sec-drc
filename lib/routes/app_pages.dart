import 'package:get/get.dart';

import '../core/di/app_bindings.dart';
import '../features/acting/view/acting_home_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.root,
      page: () => const ActingHomePage(),
      binding: AppBindings(),
    ),
    GetPage(
      name: AppRoutes.actingHome,
      page: () => const ActingHomePage(),
      binding: AppBindings(),
    ),
  ];
}