import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SEC-DRC',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.root,
      getPages: AppPages.pages,
    );
  }
}

