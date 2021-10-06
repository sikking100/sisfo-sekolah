import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/guru_controller.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/routes.dart';
import 'package:new_website/utils/constant.dart';

class PageGuru extends StatelessWidget {
  const PageGuru({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuruController>(
      init: GuruController(),
      builder: (controller) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guru',
              style: Get.textTheme.headline4,
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => Get.toNamed(Routes.guruData), child: const Text('Tambah Data')),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) return const CircularProgressIndicator();
              return DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('NIP')),
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('Kelas')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(
                    controller.listGuru.length,
                    (i) {
                      final data = controller.listGuru[i];
                      return DataRow(cells: [
                        DataCell(Text((i + 1).toString())),
                        DataCell(Text(data.nip)),
                        DataCell(Text(data.nama)),
                        DataCell(Text(data.kelas)),
                        DataCell(Text(data.email)),
                        DataCell(ButtonBar(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    NavigationController.to.navigateTo(route: Routes.guruData, arguments: data),
                                icon: edit),
                            IconButton(onPressed: () => controller.delete(data.nip), icon: delete),
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
