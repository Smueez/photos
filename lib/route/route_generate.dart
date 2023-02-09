import 'package:flutter/material.dart';
import 'package:photos/screens/gallery/ui/home_ui.dart';
import 'package:photos/screens/login/ui/login_ui.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeUi.routeName:
        return MaterialPageRoute(builder: (_) => const HomeUi());
      default:
        return MaterialPageRoute(builder: (_) => const LoginUI());
    }
  }
}