import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEC-DRC',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.auth,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

