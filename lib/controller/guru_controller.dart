import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_website/model/guru.dart';

class GuruController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController nip = TextEditingController();

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
      listGuru.assignAll(result.docs.map((e) => ModelGuru.fromJson(e.data())).toList());
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
      await _store.doc('guru/${nip.text}').set({
        'nip': nip.text,
        'nama': name.text,
        'kelas': kelas.value,
      });
      Get.snackbar('Sukses', 'Data berhasil ditambah');
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
      await _store.doc('guru/$nip').delete();
      Get.snackbar('Sukses', 'Data berhasil dihapus');
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
      await _store.doc('guru/${guru.nip}').update({
        'nip': nip,
        'nama': name.text,
        'kelas': kelas.value,
      });
      Get.snackbar('Sukses', 'Data berhasil diubah');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
