import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_website/model/tahunajar.dart';

class TahunAjarController extends GetxController {
  final TextEditingController tahun = TextEditingController();

  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;

  final RxList<ModelTahunAjar> listTahunAjar = <ModelTahunAjar>[].obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onClose() {
    super.onClose();
    tahun.dispose();
  }

  void getData() async {
    try {
      isLoading.value = true;
      final result = await _store.collection('tahun-ajaran').get();
      listTahunAjar.assignAll(result.docs.map((e) => ModelTahunAjar.fromJson(e.data())).toList());
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
      await _store.doc('tahun-ajaran/${tahun.text}').set(
        {'tahun-ajaran': tahun.text},
      );
      getData();
      Get.snackbar('Sukses', 'Data berhasil ditambah');

      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
