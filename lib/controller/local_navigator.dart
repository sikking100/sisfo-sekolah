import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/routes.dart';

Navigator localNavigator() => Navigator(
      initialRoute: Routes.dashboard,
      key: NavigationController.to.navKey,
      onGenerateRoute: Routes.generateRoute,
    );

class NavigationController extends GetxService {
  static NavigationController get to => Get.find();

  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo({required String route, dynamic arguments}) => navKey.currentState!.pushNamed(
        route,
        arguments: arguments,
      );
  Future<dynamic> replaceTo({required String route, dynamic arguments}) => navKey.currentState!.pushReplacementNamed(
        route,
        arguments: arguments,
      );

  goBack() => navKey.currentState!.pop();
}
