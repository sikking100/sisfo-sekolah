import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/tahun_ajar_controller.dart';
import 'package:new_website/routes.dart';

class PageTahunAjar extends StatelessWidget {
  const PageTahunAjar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TahunAjarController>(
      init: TahunAjarController(),
      builder: (controller) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tahun Ajaran',
              style: Get.textTheme.headline4,
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => Get.toNamed(Routes.tahunAjarData), child: const Text('Tambah Data')),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) return const CircularProgressIndicator();
              return DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Tahun Ajaran')),
                  ],
                  rows: List.generate(
                    controller.listTahunAjar.length,
                    (i) {
                      final data = controller.listTahunAjar[i];
                      return DataRow(cells: [
                        DataCell(Text((i + 1).toString())),
                        DataCell(Text(data.tahunAjar)),
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
