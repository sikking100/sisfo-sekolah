import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/controller/siswa_controller.dart';
import 'package:new_website/model/siswa.dart';
import 'package:new_website/utils/constant.dart';

class PageSiswaData extends GetView<SiswaController> {
  const PageSiswaData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      final data = Get.arguments as ModelSiswa;
      controller.name.text = data.nama;
      controller.nis.text = data.nis;
      controller.kelas.value = data.kelas;
    }
    return Column(
      children: [
        Text(
          Get.arguments != null ? 'Edit Data Siswa' : 'Tambah Data Siswa',
          style: Get.textTheme.headline4,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller.nis,
          decoration: const InputDecoration(
            label: Text('NIS'),
          ),
          enabled: Get.arguments != null ? false : true,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.name,
          decoration: const InputDecoration(
            label: Text('Nama'),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => DropdownButton<String>(
            value: controller.kelas.value,
            items: listKelas
                .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            hint: const Text('Pilih kelas'),
            onChanged: (value) => controller.kelas.value = value.toString(),
            isExpanded: true,
          ),
        ),
        Obx(() {
          if (controller.isLoading.value) return const CircularProgressIndicator();
          return ButtonBar(
            children: [
              ElevatedButton(
                onPressed: Get.arguments == null ? controller.create : controller.updates,
                child: Text(Get.arguments != null ? 'Update' : 'Simpan'),
              ),
              ElevatedButton(
                onPressed: NavigationController.to.goBack,
                child: const Text('Kembali'),
              ),
            ],
          );
        })
      ],
    );
  }
}
