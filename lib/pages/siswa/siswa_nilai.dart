import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/controller/siswa_controller.dart';
import 'package:new_website/model/siswa.dart';

class PageSiswaNilai extends GetView<SiswaController> {
  const PageSiswaNilai({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      final data = Get.arguments as ModelSiswa;
      controller.nis.text = data.nis;
      controller.name.text = data.nama;
    }

    return Column(
      children: [
        Text(
          'Edit Nilai Siswa',
          style: Get.textTheme.headline4,
        ),
        const SizedBox(height: 20),
        Obx(
          () {
            if (controller.isLoadingTahun.value) return const LinearProgressIndicator();
            return DropdownButton<String>(
              value: controller.tahunAjaran.value.isEmpty ? null : controller.tahunAjaran.value,
              items: controller.listTahunAjar
                  .map((element) => element.tahunAjar)
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ),
                  )
                  .toList(),
              hint: const Text('Pilih Tahun Ajaran'),
              onChanged: (value) => controller.tahunAjaran.value = value.toString(),
              isExpanded: true,
            );
          },
        ),
        const SizedBox(height: 10),
        Obx(
          () => DropdownButton<String>(
            value: controller.semester.value.isEmpty ? null : controller.semester.value,
            items: const [
              DropdownMenuItem(
                child: Text('Semester 1'),
                value: 'semester-1',
              ),
              DropdownMenuItem(
                child: Text('Semester 2'),
                value: 'semester-2',
              )
            ],
            hint: const Text('Pilih Semester'),
            onChanged: controller.onChangeNilai,
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 10),
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
          enabled: Get.arguments != null ? false : true,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.spiritual,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              try {
                final text = newValue.text;
                if (text.isNotEmpty) double.parse(text);
                return newValue;
              } catch (e) {
                log(e.toString());
              }
              return oldValue;
            }),
          ],
          decoration: const InputDecoration(
            label: Text('Nilai Sikap Spiritual'),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.sosial,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              try {
                final text = newValue.text;
                if (text.isNotEmpty) double.parse(text);
                return newValue;
              } catch (e) {
                log(e.toString());
              }
              return oldValue;
            }),
          ],
          decoration: const InputDecoration(
            label: Text('Nilai Sikap Sosial'),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller.rapor,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              try {
                final text = newValue.text;
                if (text.isNotEmpty) double.parse(text);
                return newValue;
              } catch (e) {
                log(e.toString());
              }
              return oldValue;
            }),
          ],
          decoration: const InputDecoration(
            label: Text('Nilai Rapor'),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) return const CircularProgressIndicator();
          return ButtonBar(
            children: [
              ElevatedButton(
                onPressed: controller.createNilai,
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
