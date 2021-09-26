import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/index_controller.dart';
import 'package:new_website/controller/local_navigator.dart';
import 'package:new_website/routes.dart';

class PageIndex extends StatelessWidget {
  const PageIndex({Key? key, required this.widget}) : super(key: key);

  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final routes = ModalRoute.of(context)?.settings.name;
        if (routes == Routes.dashboard) return Future.value(false);
        if (routes == Routes.auth) return Future.value(false);
        return Future.value(true);
      },
      child: GetX<IndexController>(
        init: IndexController(),
        builder: (controller) {
          if (controller.user.value == null) return widget ?? Container();
          return IndexWidget(widget: widget ?? Container());
        },
      ),
    );
  }
}

class IndexWidget extends StatelessWidget {
  final Widget widget;
  const IndexWidget({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: ListTileTheme(
                iconColor: Theme.of(context).colorScheme.onPrimary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                child: ListView(
                  children: [
                    const DrawerHeader(child: Text('Sisfo')),
                    ListTile(
                      onTap: () => NavigationController.to.replaceTo(route: Routes.dashboard),
                      leading: const Icon(Icons.dashboard),
                      title: const Text('Dashboard'),
                    ),
                    ListTile(
                      onTap: () => NavigationController.to.replaceTo(route: Routes.user),
                      leading: const Icon(Icons.verified_user),
                      title: const Text('User'),
                    ),
                    ListTile(
                      onTap: () => NavigationController.to.replaceTo(route: Routes.siswa),
                      leading: const Icon(Icons.person),
                      title: const Text('Siswa'),
                    ),
                    ListTile(
                      onTap: () => NavigationController.to.replaceTo(route: Routes.guru),
                      leading: const Icon(Icons.group),
                      title: const Text('Guru'),
                    ),
                    ListTile(
                      onTap: () => NavigationController.to.replaceTo(route: Routes.tahunAjar),
                      leading: const Icon(Icons.date_range),
                      title: const Text('Tahun Ajaran'),
                    ),
                    ListTile(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        NavigationController.to.navKey.currentState?.pushReplacementNamed(Routes.auth);
                        return;
                      },
                      leading: const Icon(Icons.logout),
                      title: const Text('Keluar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: widget,
            ),
          ),
        ],
      ),
    );
  }
}
