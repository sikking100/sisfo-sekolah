import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/model/guru.dart';
import 'package:new_website/routes.dart';

class GuruController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController nip = TextEditingController();
  final TextEditingController email = TextEditingController();

  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final RxString kelas = ''.obs;

  final RxList<ModelGuru> listGuru = <ModelGuru>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    try {
      isLoading.value = true;
      final result = await _store.collection('guru').get();
      listGuru.assignAll(result.docs.map((e) => ModelGuru.fromJson(e)).toList());
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
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: '123456');
      await _store.doc('guru/${result.user?.uid}').set({
        'nip': nip.text,
        'nama': name.text,
        'kelas': kelas.value,
        'email': email.text,
      });
      getData();
      Get.snackbar('Sukses', 'Data berhasil ditambah');

      await FirebaseAuth.instance.signOut();
      NavigationController.to.replaceTo(route: Routes.auth);

      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void delete(String id) async {
    try {
      isLoading.value = true;
      await _store.doc('guru/$id').delete();
      Get.snackbar('Sukses', 'Data berhasil dihapus');
      getData();

      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void updates() async {
    try {
      final guru = Get.arguments as ModelGuru;
      isLoading.value = true;
      await _store.doc('guru/${guru.id}').update({
        'nip': nip,
        'nama': name.text,
        'kelas': kelas.value,
      });
      Get.snackbar('Sukses', 'Data berhasil diubah');
      getData();

      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
