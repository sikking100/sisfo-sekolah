import 'package:flutter/material.dart';
import 'package:new_website/pages/auth.dart';
import 'package:new_website/pages/dashboard.dart';
import 'package:new_website/pages/guru/guru.dart';
import 'package:new_website/pages/guru/guru_data.dart';
import 'package:new_website/pages/siswa/siswa.dart';
import 'package:new_website/pages/siswa/siswa_data.dart';
import 'package:new_website/pages/tahun%20ajar/tahun_ajar.dart';
import 'package:new_website/pages/tahun%20ajar/tahun_ajar_data.dart';
import 'package:new_website/pages/user/user.dart';
import 'package:new_website/pages/user/user_data.dart';

class Routes {
  static const String auth = '/auth';
  static const String dashboard = '/';
  static const String user = '/user';
  static const String userData = '/user-data';
  static const String guru = '/guru';
  static const String guruData = '/guru-data';
  static const String siswa = '/siswa';
  static const String siswaData = '/siswa-data';
  static const String tahunAjar = '/tahun-ajar';
  static const String tahunAjarData = '/tahun-ajar-data';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return _route(const PageAuth(), settings);
      case dashboard:
        return _route(const PageDashboard(), settings);
      case user:
        return _route(const PageUser(), settings);
      case userData:
        return _route(const PageUserData(), settings);
      case siswa:
        return _route(const PageSiswa(), settings);
      case siswaData:
        return _route(const PageSiswaData(), settings);
      case guru:
        return _route(const PageGuru(), settings);
      case guruData:
        return _route(const PageGuruData(), settings);
      case tahunAjar:
        return _route(const PageTahunAjar(), settings);
      case tahunAjarData:
        return _route(const PageTahunAjarData(), settings);
      default:
        return _route(
          const Center(
            child: Text('Tidak ada tampilan'),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _route(Widget widget, RouteSettings settings) =>
      MaterialPageRoute(builder: (context) => widget, settings: settings);
}
