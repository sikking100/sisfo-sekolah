import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/dashboard_controller.dart';
import 'package:new_website/controller/index_controller.dart';
import 'package:new_website/model/tahunajar.dart';
import 'package:new_website/utils/constant.dart';

class PageDashboard extends StatelessWidget {
  const PageDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) => SizedBox(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Get.textTheme.headline4,
              ),
              const SizedBox(height: 30),
              Obx(
                () {
                  if (controller.isLoading.value) return const LinearProgressIndicator();
                  return DropdownButton<String>(
                    value: controller.tahuns.value.isEmpty ? null : controller.tahuns.value,
                    items: controller.lists
                        .map((element) => DropdownMenuItem<String>(
                              child: Text(element.tahunAjar),
                              value: element.tahunAjar,
                            ))
                        .toList(),
                    onChanged: controller.onChanged,
                    isExpanded: true,
                    hint: const Text('Pilih Tahun Ajaran'),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text('Siswa yang berprestasi'),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.tahuns.value.isEmpty) return Container();
                if (controller.isLoadingData.value) return const LinearProgressIndicator();
                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Nis')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Kelas')),
                    ],
                    rows: List.generate(
                      controller.listData.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(Text(controller.listData[index].nis)),
                          DataCell(Text(controller.listData[index].nama)),
                          DataCell(Text(controller.listData[index].kelas)),
                        ],
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
