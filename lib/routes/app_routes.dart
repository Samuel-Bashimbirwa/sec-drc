import 'package:flutter/material.dart';
import '../features/auth/view/auth_page.dart';
import '../features/acting/view/acting_home_page.dart';

class AppRoutes {
  static const auth = '/auth';
  static const actingHome = '/acting/home';

  static Map<String, WidgetBuilder> routes = {
    auth: (_) => const AuthPage(),
    actingHome: (_) => const ActingHomePage(),
  };
}

