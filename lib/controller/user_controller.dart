import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_website/model/guru.dart';
import 'package:new_website/model/user.dart';

class UserController extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController nama = TextEditingController();

  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isLoading = false.obs;
  final RxString nip = ''.obs;
  final RxList<ModelUser> listUser = <ModelUser>[].obs;
  final RxList<ModelGuru> listGuru = <ModelGuru>[].obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onClose() {
    super.onClose();
    email.dispose();
    password.dispose();
  }

  void getData() async {
    try {
      isLoading.value = true;
      final result = await Future.wait([
        _store.collection('users').get(),
        _store.collection('guru').get(),
      ]);
      log(result[1].docs.length.toString());
      listUser.assignAll(result[0].docs.map((e) => ModelUser.fromJson(e.data())));
      listGuru.assignAll(result[1].docs.map((e) => ModelGuru.fromJson(e)));
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void create() async {
    try {
      isLoading.value = true;
      final result = await _auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
      final uid = result.user?.uid;
      await _store.doc('users/$uid').set({
        'nip': nip.value,
        'nama': nama.text,
        'email': email.text,
      });
      Get.snackbar('Sukses', 'Berhasil menambah data');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void delete(String nip) async {
    try {
      isLoading.value = true;
      await _store.doc('users/$nip').delete();
      Get.snackbar('Sukses', 'Berhasil menambah data');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
