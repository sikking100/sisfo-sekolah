import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_website/model/data.dart';
import 'package:new_website/model/tahunajar.dart';

class DashboardController extends GetxController {
  final RxString tahuns = ''.obs;
  final RxString semester = ''.obs;
  final RxList<ModelTahunAjar> lists = <ModelTahunAjar>[].obs;
  final RxList<ModelData> listData = <ModelData>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingData = true.obs;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    getTahunAjar();
  }

  void getTahunAjar() async {
    try {
      isLoading.value = true;
      final request = await _store.collection('tahun-ajaran').get();
      lists.assignAll(request.docs.map((e) => ModelTahunAjar.fromJson(e.data())).toList());
      return;
    } catch (e) {
      log(e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void onChanged(String? v) {
    tahuns.value = v.toString();
    return;
  }

  void onChangedSemester(String? v) {
    semester.value = v.toString();
    getData();
    return;
  }

  void getData() async {
    try {
      isLoadingData.value = true;

      //tidak berurut
      // final result = await _store.collection('tahun-ajaran/${tahuns.value}/${semester.value}').get();

      //mengurutkan
      final result = await _store
          .collection('tahun-ajaran/${tahuns.value}/${semester.value}')
          .orderBy('keterangan', descending: false)
          .orderBy('nilaiFuzzy', descending: true)
          .get();
      listData.assignAll(result.docs.map((e) => ModelData.fromJson(e)).toList());
      return;
    } catch (e) {
      print(e);
      log(e.toString());
      return;
    } finally {
      isLoadingData.value = false;
    }
  }
}
