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
    } on FirebaseAuthException catch (e) {
      String err = '';
      switch (e.code) {
        case 'user-not-found':
          err = 'Tidak ada data pengguna yang sesuai dengan pengenal yang diberikan.';
          break;
        case 'invalid-password':
          err =
              'Nilai yang diberikan untuk properti pengguna password tidak valid. Harus berupa string dengan minimal 6 karakter.';
          break;
        case 'invalid-email':
          err = 'Nilai yang diberikan untuk properti pengguna email tidak valid. Harus berupa alamat email string.';
          break;
        default:
          '';
      }

      Get.defaultDialog(
        title: 'Error',
        middleText: err.toString(),
        confirm: TextButton(
          onPressed: Get.back,
          child: const Text('Ok'),
        ),
      );
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
