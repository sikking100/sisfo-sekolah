import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/controller/user_controller.dart';

class PageUserData extends GetView<UserController> {
  const PageUserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Tambah Data User'),
        const SizedBox(height: 20),
        Obx(
          () => DropdownButton<String>(
            value: controller.nip.value.isEmpty ? controller.listGuru.first.nip : controller.nip.value,
            items: controller.listGuru
                .map((element) => element.nip)
                .toList()
                .map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            hint: const Text('Pilih NIP Guru'),
            onChanged: (value) => controller.nip.value = value.toString(),
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          controller.nama.text = controller.nip.value.isEmpty
              ? ''
              : controller.listGuru.firstWhere((element) => element.nip == controller.nip.value).nama;
          return TextField(
            controller: controller.nama,
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
            enabled: false,
          );
        }),
        const SizedBox(height: 10),
        TextField(
          controller: controller.email,
          decoration: const InputDecoration(
            label: Text('Email'),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.password,
          decoration: const InputDecoration(
            label: Text('Password'),
          ),
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
