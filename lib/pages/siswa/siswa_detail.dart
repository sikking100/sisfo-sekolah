import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/siswa_controller.dart';
import 'package:new_website/model/siswa.dart';

class PageSiswaDetail extends GetView<SiswaController> {
  const PageSiswaDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as ModelSiswa;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Siswa',
          style: Get.textTheme.headline4,
        ),
        const SizedBox(height: 20),
        Text('Nis : ${data.nis}'),
        const SizedBox(height: 10),
        Text('Nama : ${data.nama}'),
        const SizedBox(height: 10),
        Text('Kelas : ${data.kelas}'),
        const SizedBox(height: 10),
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
              onChanged: (value) {
                controller.tahunAjaran.value = value.toString();
                controller.getDetailSiswa();
              },
              isExpanded: true,
            );
          },
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) return const LinearProgressIndicator();
          if (controller.listNilai.isEmpty) return Container();
          return Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final data = controller.listNilai[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Semester : ${data.semester}'),
                    const SizedBox(height: 5),
                    Text('Nilai Rata-rata Rapor : ${data.rapor}'),
                    const SizedBox(height: 5),
                    Text('Nilai Rata-rata Spiritual : ${data.spiritual}'),
                    const SizedBox(height: 5),
                    Text('Nilai Rata-rata Sosial : ${data.sosial}'),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: controller.listNilai.length,
            ),
          );
        }),
      ],
    );
  }
}
