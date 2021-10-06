import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/controller/siswa_controller.dart';
import 'package:new_website/routes.dart';
import 'package:new_website/utils/constant.dart';

class PageSiswa extends StatelessWidget {
  const PageSiswa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SiswaController>(
      init: SiswaController(),
      builder: (controller) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Siswa',
              style: Get.textTheme.headline4,
            ),
            const SizedBox(height: 10),
            if (FirebaseAuth.instance.currentUser?.uid == id)
              ElevatedButton(onPressed: () => Get.toNamed(Routes.siswaData), child: const Text('Tambah Data')),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) return const CircularProgressIndicator();
              if (FirebaseAuth.instance.currentUser?.uid == id) {
                return DataTable(
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('NIS')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Kelas')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: List.generate(
                      controller.listSiswa.length,
                      (i) {
                        final data = controller.listSiswa[i];
                        return DataRow(cells: [
                          DataCell(Text((i + 1).toString())),
                          DataCell(Text(data.nis)),
                          DataCell(Text(data.nama)),
                          DataCell(Text(data.kelas)),
                          DataCell(ButtonBar(
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      NavigationController.to.navigateTo(route: Routes.siswaData, arguments: data),
                                  icon: edit),
                              IconButton(onPressed: () => controller.delete(data.nis), icon: delete),
                            ],
                          )),
                        ]);
                      },
                    ));
              }
              return DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('NIS')),
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('Kelas')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(
                    controller.listSiswa.length,
                    (i) {
                      final data = controller.listSiswa[i];
                      return DataRow(cells: [
                        DataCell(Text((i + 1).toString())),
                        DataCell(Text(data.nis)),
                        DataCell(Text(data.nama)),
                        DataCell(Text(data.kelas)),
                        DataCell(ButtonBar(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    NavigationController.to.navigateTo(route: Routes.siswaNilai, arguments: data),
                                icon: edit),
                          ],
                        )),
                      ]);
                    },
                  ));
            })
          ],
        ),
      ),
    );
  }
}
