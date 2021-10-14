import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_website/model/guru.dart';
import 'package:new_website/routes.dart';
import 'package:new_website/utils/constant.dart';

class IndexController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final Rx<ModelGuru> guru = ModelGuru().obs;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingDashboard = true.obs;
  final RxString tahun = ''.obs;

  static IndexController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever<User?>(user, (u) async {
      if (u == null) {
        Get.offNamed(Routes.auth);
        return;
      } else {
        try {
          isLoading.value = true;
          log(u.uid);
          if (u.uid == id) {
            Get.offNamed(Routes.dashboard);
            return;
          }
          final result = await _store.doc('guru/${u.uid}').get();
          guru.value = ModelGuru.fromJson(result);
          Get.offNamed(Routes.dashboard);
          return;
        } catch (e) {
          log(e.toString());

          return;
        } finally {
          isLoading.value = false;
        }
      }
    });
  }
}
