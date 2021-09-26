import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingForgetPassword = false.obs;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void login() async {
    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      return;
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        middleText: e.toString(),
        confirm: TextButton(
          onPressed: Get.back,
          child: const Text('Ok'),
        ),
      );
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void forgetPassword() async {
    try {
      isLoadingForgetPassword.value = true;
      if (email.text.isEmpty) throw 'Isi alamat email sebelumnya';
      await auth.sendPasswordResetEmail(email: email.text);
      return;
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        middleText: e.toString(),
        confirm: TextButton(
          onPressed: Get.back,
          child: const Text('Ok'),
        ),
      );
      return;
    } finally {
      isLoadingForgetPassword.value = false;
    }
  }
}
