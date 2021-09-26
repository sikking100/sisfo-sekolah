import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_website/model/siswa.dart';

class SiswaController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController nis = TextEditingController();

  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final RxString kelas = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<ModelSiswa> listSiswa = <ModelSiswa>[].obs;

  @override
  void onInit() {
    super.onInit();

    getData();
  }

  @override
  void onClose() {
    super.onClose();
    name.dispose();
    nis.dispose();
  }

  void getData() async {
    try {
      isLoading.value = true;
      final result = await _store.collection('siswa').get();
      listSiswa.assignAll(result.docs.map((e) => ModelSiswa.fromJson(e.data())).toList());
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
      await _store.doc('siswa/${nis.text}').set({
        'nama': name.text,
        'nis': nis.text,
        'kelas': kelas.value,
      });
      getData();
      name.clear();
      nis.clear();
      kelas.value = '';
      Get.snackbar('Sukses', 'Data berhasil ditambah');
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
      final data = Get.arguments as ModelSiswa;
      final String _nis = data.nis;
      isLoading.value = true;
      await _store.doc('siswa/$_nis').update({
        'nama': name.text,
        'nis': _nis,
        'kelas': kelas.value,
      });
      getData();
      Get.snackbar('Sukses', 'Data berhasil diubah');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void delete(String nis) async {
    try {
      isLoading.value = true;
      await _store.doc('siswa/$nis').delete();
      getData();
      Get.snackbar('Sukses', 'Data berhasil dihapus');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
