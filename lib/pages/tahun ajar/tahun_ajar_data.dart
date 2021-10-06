import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/controller/tahun_ajar_controller.dart';

class PageTahunAjarData extends GetView<TahunAjarController> {
  const PageTahunAjarData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tambah Data',
          style: Get.textTheme.headline4,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller.tahun,
          decoration: const InputDecoration(label: Text('Tahun Ajaran'), hintText: 'ta-20xx-20xx'),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) return const CircularProgressIndicator();
          return ButtonBar(
            children: [
              ElevatedButton(
                onPressed: controller.create,
                child: const Text('Simpan'),
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
