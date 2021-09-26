import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_website/routes.dart';

class IndexController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever<User?>(user, (u) {
      if (u == null) {
        Get.offNamed(Routes.auth);
        return;
      } else {
        Get.offNamed(Routes.dashboard);
        return;
      }
    });
  }
}
