import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/guru_controller.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/model/guru.dart';
import 'package:new_website/utils/constant.dart';

class PageGuruData extends GetView<GuruController> {
  const PageGuruData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      final data = Get.arguments as ModelGuru;
      controller.name.text = data.nama;
      controller.nip.text = data.nip;
      controller.kelas.value = data.kelas;
      controller.email.text = data.email;
    }
    return Column(
      children: [
        Text(
          Get.arguments != null ? 'Edit Data Guru' : 'Tambah Data Guru',
          style: Get.textTheme.headline4,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller.nip,
          decoration: const InputDecoration(
            label: Text('NIP'),
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
        TextField(
          controller: controller.email,
          decoration: const InputDecoration(
            label: Text('Email'),
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
