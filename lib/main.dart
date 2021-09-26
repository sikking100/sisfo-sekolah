import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/pages/index.dart';
import 'package:new_website/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(NavigationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => PageIndex(widget: child),
      navigatorKey: Get.find<NavigationController>().navKey,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.dashboard,
    );
  }
}
