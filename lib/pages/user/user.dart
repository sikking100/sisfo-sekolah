import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/controller/user_controller.dart';
import 'package:new_website/routes.dart';
import 'package:new_website/utils/constant.dart';

class PageUser extends StatelessWidget {
  const PageUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (controller) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User'),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => Get.toNamed(Routes.userData), child: const Text('Tambah Data')),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) return const CircularProgressIndicator();
              return DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('NIP')),
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(
                    controller.listUser.length,
                    (i) {
                      final data = controller.listUser[i];
                      return DataRow(cells: [
                        DataCell(Text((i + 1).toString())),
                        DataCell(Text(data.nip)),
                        DataCell(Text(data.name)),
                        DataCell(Text(data.email)),
                        DataCell(ButtonBar(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    NavigationController.to.navigateTo(route: Routes.siswaData, arguments: data),
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
