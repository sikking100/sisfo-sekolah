import 'dart:developer';
import 'dart:math' hide log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_website/controller/index_controller.dart';
import 'package:new_website/model/siswa.dart';
import 'package:new_website/model/tahunajar.dart';
import 'package:new_website/utils/constant.dart';

class SiswaController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController nis = TextEditingController();
  final TextEditingController spiritual1 = TextEditingController();
  final TextEditingController sosial1 = TextEditingController();
  final TextEditingController rapor1 = TextEditingController();
  final TextEditingController spiritual2 = TextEditingController();
  final TextEditingController sosial2 = TextEditingController();
  final TextEditingController rapor2 = TextEditingController();

  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final RxString kelas = ''.obs;
  final RxString tahunAjaran = ''.obs;
  // final RxString semester = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingTahun = false.obs;
  final RxList<ModelSiswa> listSiswa = <ModelSiswa>[].obs;
  final RxList<ModelTahunAjar> listTahunAjar = <ModelTahunAjar>[].obs;

  @override
  void onInit() {
    log(IndexController.to.guru.value.kelas);

    super.onInit();
    getData();
    if (FirebaseAuth.instance.currentUser?.uid != id) {
      getTahunAjar();
    }
  }

  @override
  void onClose() {
    super.onClose();
    name.dispose();
    nis.dispose();
    spiritual1.dispose();
    sosial1.dispose();
    rapor1.dispose();
    spiritual2.dispose();
    sosial2.dispose();
    rapor2.dispose();
  }

  void clear() {
    name.clear();
    nis.clear();
    spiritual1.clear();
    sosial1.clear();
    rapor1.clear();
    spiritual2.clear();
    sosial2.clear();
    rapor2.clear();
  }

  void getTahunAjar() async {
    try {
      isLoading.value = true;
      final result = await _store.collection('tahun-ajaran').get();
      listTahunAjar.assignAll(result.docs.map((e) => ModelTahunAjar.fromJson(e.data())).toList());
      return;
    } catch (e) {
      log(e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void getData() async {
    try {
      isLoading.value = true;
      log(IndexController.to.guru.value.kelas);
      QuerySnapshot<Map<String, dynamic>> result;
      if (FirebaseAuth.instance.currentUser?.uid == id) {
        result = await _store.collection('siswa').get();
      } else {
        result = await _store.collection('siswa').where('kelas', isEqualTo: IndexController.to.guru.value.kelas).get();
      }
      listSiswa.assignAll(result.docs.map((e) => ModelSiswa.fromJson(e.data())).toList());
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void create() async {
    try {
      isLoading.value = true;
      await _store.doc('siswa/${nis.text}').set({
        'nama': name.text,
        'nis': nis.text,
        'kelas': kelas.value,
      });
      getData();
      name.clear();
      nis.clear();
      kelas.value = '';
      Get.snackbar('Sukses', 'Data berhasil ditambah');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void updates() async {
    try {
      final data = Get.arguments as ModelSiswa;
      final String _nis = data.nis;
      isLoading.value = true;
      await _store.doc('siswa/$_nis').update({
        'nama': name.text,
        'nis': _nis,
        'kelas': kelas.value,
      });
      getData();
      Get.snackbar('Sukses', 'Data berhasil diubah');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void delete(String nis) async {
    try {
      isLoading.value = true;
      await _store.doc('siswa/$nis').delete();
      getData();
      Get.snackbar('Sukses', 'Data berhasil dihapus');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void createNilai() async {
    try {
      isLoading.value = true;
      final siswa = Get.arguments as ModelSiswa;
      final fuzzy1 = fuzzyLogic(
        nilaiRapor: double.parse(rapor1.text),
        nilaiSpiritual: double.parse(spiritual1.text),
        nilaiSosial: double.parse(sosial1.text),
      );
      final fuzzy2 = fuzzyLogic(
        nilaiRapor: double.parse(rapor2.text),
        nilaiSpiritual: double.parse(spiritual2.text),
        nilaiSosial: double.parse(sosial2.text),
      );
      final total = (fuzzy1 + fuzzy2) / 2;
      String keterangan = '';
      if (73 <= total && total <= 80) {
        keterangan = 'Berprestasi';
      } else {
        keterangan = 'Tidak Berprestasi';
      }
      await _store.doc('siswa/${siswa.nis}/tahun-ajaran/${tahunAjaran.value}').set(
        {
          'semester-1': {
            'spiritual': double.parse(spiritual1.text),
            'sosial': double.parse(sosial1.text),
            'rapor': double.parse(rapor1.text),
            'nilaiFuzzy': fuzzy1,
          },
          'semester-2': {
            'spiritual': double.parse(spiritual2.text),
            'sosial': double.parse(sosial2.text),
            'rapor': double.parse(rapor2.text),
            'nilaiFuzzy': fuzzy2,
          },
        },
      );
      await _store.doc('tahun-ajaran/${tahunAjaran.value}/siswa/${siswa.nis}').set(
        {
          'nama': siswa.nama,
          'kelas': siswa.kelas,
          'semester-1': {
            'nilaiFuzzy': fuzzy1,
          },
          'semester-2': {
            'nilaiFuzzy': fuzzy2,
          },
          'total': total,
          'keterangan': keterangan
        },
      );
      await _store.doc('tahun-ajaran/${tahunAjaran.value}/${siswa.kelas}/${siswa.nis}').set(
        {
          'nama': siswa.nama,
          'kelas': siswa.kelas,
          'semester-1': {
            'nilaiFuzzy': fuzzy1,
          },
          'semester-2': {
            'nilaiFuzzy': fuzzy2,
          },
          'total': total,
          'keterangan': keterangan
        },
      );
      Get.back();
      clear();
      Get.snackbar('Sukses', 'Data berhasil ditambah');
      return;
    } catch (e) {
      Get.defaultDialog(middleText: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }

  double fuzzyLogic({required double nilaiRapor, required double nilaiSpiritual, required double nilaiSosial}) {
    //Rule
    //[R1] Jika nilai rapor RENDAH dan nilai sosial RENDAH dan nilai spiritual RENDAH maka prestasi BIASA
    //[R2] Jika nilai rapor RENDAH dan nilai sosial RENDAH dan nilai spiritual SEDANG maka prestasi BIASA
    //[R3] Jika nilai rapor RENDAH dan nilai sosial RENDAH dan nilai spiritual TINGGI maka prestasi BIASA
    //[R4] Jika nilai rapor RENDAH dan nilai sosial SEDANG dan nilai spiritual RENDAH maka prestasi BIASA
    //[R5] Jika nilai rapor RENDAH dan nilai sosial SEDANG dan nilai spiritual SEDANG maka prestasi BIASA
    //[R6] Jika nilai rapor RENDAH dan nilai sosial SEDANG dan nilai spiritual TINGGI maka prestasi BIASA
    //[R7] Jika nilai rapor RENDAH dan nilai sosial tinggi dan nilai spiritual rendah maka prestasi BIASA
    //[R8] Jika nilai rapor RENDAH dan nilai sosial tinggi dan nilai spiritual sedang maka prestasi BIASA
    //[R9] jika nilai rapor RENDAH dan nilai sosial tinggi dan nilai spiritual tinggi maka prestasi BIASA
    //[R10] jika nilai rapor SEDANG dan nilai sosial RENDAH dan nilai spiritual RENDAH maka prestasi BIASA
    //[R11] jika nilai rapor SEDANG dan nilai sosial RENDAH dan nilai spiritual SEDANG maka prestasi BIASA
    //[R12] jika nilai rapor SEDANG dan nilai sosial RENDAH dan nilai spiritual tinggi maka prestasi BIASA
    //[R13] jika nilai rapor SEDANG dan nilai sosial SEDANG dan nilai spiritual RENDAH maka prestasi BIASA
    //[R14] jika nilai rapor SEDANG dan nilai sosial SEDANG dan nilai spiritual SEDANG maka prestasi LUAR BIASA
    //[R15] jika nilai rapor SEDANG dan nilai sosial SEDANG dan nilai spiritual tinggi maka prestasi LUAR BIASA
    //[R16] jika nilai rapor SEDANG dan nilai sosial TINGGI dan nilai spiritual RENDAH maka prestasi BIASA
    //[R17] jika nilai rapor SEDANG dan nilai sosial TINGGI dan nilai spiritual SEDANG maka prestasi LUAR BIASA
    //[R18] jika nilai rapor SEDANG dan nilai sosial TINGGI dan nilai spiritual TINGGI maka prestasi LUAR BIASA
    //[R19] jika nilai rapor TINGGI dan nilai sosial RENDAH dan nilai spiritual RENDAH maka prestasi BIASA
    //[R20] jika nilai rapor TINGGI dan nilai sosial RENDAH dan nilai spiritual SEDANG maka prestasi BIASA
    //[R21] jika nilai rapor TINGGI dan nilai sosial RENDAH dan nilai spiritual TINGGI maka prestasi BIASA
    //[R22] jika nilai rapor TINGGI dan nilai sosial SEDANG dan nilai spiritual RENDAH maka prestasi BIASA
    //[R23] jika nilai rapor TINGGI dan nilai sosial SEDANG dan nilai spiritual SEDANG maka prestasi LUAR BIASA
    //[R24] jika nilai rapor TINGGI dan nilai sosial SEDANG dan nilai spiritual TINGGI maka prestasi LUAR BIASA
    //[R25] jika nilai rapor TINGGI dan nilai sosial TINGGI dan nilai spiritual RENDAH maka prestasi BIASA
    //[R26] jika nilai rapor TINGGI dan nilai sosial TINGGI dan nilai spiritual SEDANG maka prestasi LUAR BIASA
    //[R27] jika nilai rapor TINGGI dan nilai sosial TINGGI dan nilai spiritual TINGGI maka prestasi LUAR BIASA

    // variabel rules
    double r1 = 0.0;
    double r2 = 0.0;
    double r3 = 0.0;
    double r4 = 0.0;
    double r5 = 0.0;
    double r6 = 0.0;
    double r7 = 0.0;
    double r8 = 0.0;
    double r9 = 0.0;
    double r10 = 0.0;
    double r11 = 0.0;
    double r12 = 0.0;
    double r13 = 0.0;
    double r14 = 0.0;
    double r15 = 0.0;
    double r16 = 0.0;
    double r17 = 0.0;
    double r18 = 0.0;
    double r19 = 0.0;
    double r20 = 0.0;
    double r21 = 0.0;
    double r22 = 0.0;
    double r23 = 0.0;
    double r24 = 0.0;
    double r25 = 0.0;
    double r26 = 0.0;
    double r27 = 0.0;

    //variabel fungsi keanggotaan
    double muRaporRendah = 0.0;
    double muRaporSedang = 0.0;
    double muRaporTinggi = 0.0;
    double muSosialRendah = 0.0;
    double muSosialSedang = 0.0;
    double muSosialTinggi = 0.0;
    double muSpiritualRendah = 0.0;
    double muSpiritualSedang = 0.0;
    double muSpiritualTinggi = 0.0;

    //fungsi keanggotaan nilai rapor rendah
    if (nilaiRapor <= 40) {
      muRaporRendah = 1;
    } else if (40 <= nilaiRapor && nilaiRapor <= 60) {
      muRaporRendah = (60 - nilaiRapor) / (60 - 40);
    } else if (nilaiRapor >= 60) {
      muRaporRendah = 0;
    }

    print('Mu Rapor Rendah = ' + muRaporRendah.toString());

    //fungsi keanggotaan nilai rapor sedang
    if (nilaiRapor <= 40 || nilaiRapor >= 80) {
      muRaporSedang = 0;
    } else if (40 <= nilaiRapor && nilaiRapor <= 60) {
      muRaporSedang = (nilaiRapor - 40) / (60 - 40);
    } else if (60 <= nilaiRapor && nilaiRapor <= 80) {
      muRaporSedang = (80 - nilaiRapor) / (80 - 60);
    }

    print('Mu Rapor Sedang = ' + muRaporSedang.toString());

    //fungsi keanggotaan nilai rapor tinggi
    if (nilaiRapor <= 60) {
      muRaporTinggi = 0;
    } else if (60 <= nilaiRapor && nilaiRapor <= 80) {
      muRaporTinggi = (nilaiRapor - 60) / (80 - 60);
    } else if (nilaiRapor >= 80) {
      muRaporTinggi = 1;
    }

    print('Mu Rapor Tinggi = ' + muRaporTinggi.toString());

    //fungsi keanggotaan nilai sosial rendah
    if (nilaiSosial <= 40) {
      muSosialRendah = 1;
    } else if (40 <= nilaiSosial && nilaiSosial <= 60) {
      muSosialRendah = (60 - nilaiSosial) / (60 - 40);
    } else if (nilaiSosial >= 60) {
      muSosialRendah = 0;
    }

    print('Mu Sosial Rendah = ' + muSosialRendah.toString());

    //fungsi keanggotaan nilai sosial sedang
    if (nilaiSosial <= 40 || nilaiSosial >= 80) {
      muSosialSedang = 0;
    } else if (40 <= nilaiSosial && nilaiSosial <= 60) {
      muSosialSedang = (nilaiSosial - 40) / (60 - 40);
    } else if (60 <= nilaiSosial && nilaiSosial <= 80) {
      muSosialSedang = (80 - nilaiSosial) / (80 - 60);
    }

    print('Mu Sosial Sedang = ' + muSosialSedang.toString());

    //fungsi keanggotaan nilai sosial tinggi
    if (nilaiSosial <= 60) {
      muSosialTinggi = 0;
    } else if (60 <= nilaiSosial && nilaiSosial <= 80) {
      muSosialTinggi = (nilaiSosial - 60) / (80 - 60);
    } else if (nilaiSosial >= 80) {
      muSosialTinggi = 1;
    }

    print('Mu Sosial Tinggi = ' + muSosialTinggi.toString());

    //fungsi keanggotaan nilai spiritual rendah
    if (nilaiSpiritual <= 40) {
      muSpiritualSedang = 1;
    } else if (40 <= nilaiSpiritual && nilaiSpiritual <= 60) {
      muSpiritualSedang = (60 - nilaiSpiritual) / (60 - 40);
    } else if (nilaiSpiritual >= 60) {
      muSpiritualSedang = 0;
    }

    print('Mu Spiritual Rendah = ' + muSpiritualRendah.toString());

    //fungsi keanggotaan nilai spiritual sedang
    if (nilaiSpiritual <= 40 || nilaiSpiritual >= 80) {
      muSpiritualSedang = 0;
    } else if (40 <= nilaiSpiritual && nilaiSpiritual <= 60) {
      muSpiritualSedang = (nilaiSpiritual - 40) / (60 - 40);
    } else if (60 <= nilaiSpiritual && nilaiSpiritual <= 80) {
      muSpiritualSedang = (80 - nilaiSpiritual) / (80 - 60);
    }

    print('Mu Spiritual Sedang = ' + muSpiritualSedang.toString());

    //fungsi keanggotaan nilai spiritual tinggi
    if (nilaiSpiritual <= 60) {
      muSpiritualTinggi = 0;
    } else if (60 <= nilaiSpiritual && nilaiSpiritual <= 80) {
      muSpiritualTinggi = (nilaiSpiritual - 60) / (80 - 60);
    } else if (nilaiSpiritual >= 80) {
      muSpiritualTinggi = 1;
    }

    print('Mu Spiritual Tinggi = ' + muSpiritualTinggi.toString());

    //minnya dicari
    r1 = [muRaporRendah, muSosialRendah, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r2 = [muRaporRendah, muSosialRendah, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r3 = [muRaporRendah, muSosialRendah, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r4 = [muRaporRendah, muSosialSedang, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r5 = [muRaporRendah, muSosialSedang, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r6 = [muRaporRendah, muSosialSedang, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r7 = [muRaporRendah, muSosialTinggi, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r8 = [muRaporRendah, muSosialTinggi, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r9 = [muRaporRendah, muSosialTinggi, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r10 = [muRaporSedang, muSosialRendah, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r11 = [muRaporSedang, muSosialRendah, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r12 = [muRaporSedang, muSosialRendah, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r13 = [muRaporSedang, muSosialSedang, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r14 = [muRaporSedang, muSosialSedang, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r15 = [muRaporSedang, muSosialSedang, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r16 = [muRaporSedang, muSosialTinggi, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r17 = [muRaporSedang, muSosialTinggi, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r18 = [muRaporSedang, muSosialTinggi, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r19 = [muRaporTinggi, muSosialRendah, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r20 = [muRaporTinggi, muSosialRendah, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r21 = [muRaporTinggi, muSosialRendah, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r22 = [muRaporTinggi, muSosialSedang, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r23 = [muRaporTinggi, muSosialSedang, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r24 = [muRaporTinggi, muSosialSedang, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);
    r25 = [muRaporTinggi, muSosialTinggi, muSpiritualRendah]
        .reduce((value, element) => value < element ? value : element);
    r26 = [muRaporTinggi, muSosialTinggi, muSpiritualSedang]
        .reduce((value, element) => value < element ? value : element);
    r27 = [muRaporTinggi, muSosialTinggi, muSpiritualTinggi]
        .reduce((value, element) => value < element ? value : element);

    // mengelompokkan output kedalam kategori dan mencari yang paling besar antar kategori
    double maxBiasa = [r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r16, r19, r20, r21, r22, r25]
        .reduce((value, element) => value > element ? value : element);

    print('MaxBiasa = ' + maxBiasa.toString());

    double maxLuarBiasa =
        [r14, r15, r17, r18, r23, r24, r26, r27].reduce((value, element) => value > element ? value : element);

    print('maxLuarBiasa = ' + maxLuarBiasa.toString());

    //mencari nilai z untuk dengan menentukan nilai titik t1 dan t2
    double t1 = (maxBiasa * 20) + 60;

    print('t1 = ' + t1.toString());

    double t2 = (maxLuarBiasa * 20) + 60;

    print('t2 = ' + t2.toString());

    // mencari momen
    //integral tentu 0 - t1
    double m1 = (maxBiasa * 1 / 2 * pow(t1, 2)) - (maxBiasa * 1 / 2 * pow(0, 2));

    print('m1 = ' + m1.toString());

    // mencari momen
    //integral tentu t1 - t2

    double m2 = ((0.05 * 1 / 3 * pow(t2, 3)) - (3 * 1 / 2 * pow(t2, 2))) -
        ((0.05 * 1 / 3 * pow(t1, 3)) - (3 * 1 / 2 * pow(t1, 2)));

    print('m2 = ' + m2.toString());

    // mencari momen
    //integral tentu t2 - 80
    double m3 = (maxLuarBiasa * 1 / 2 * pow(80, 2)) - (maxLuarBiasa * 1 / 2 * pow(t2, 2));

    print('m3 = ' + m3.toString());

    //menghitung luas
    //integral tentu 0 - 1
    double a1 = (maxBiasa * t1) - (maxBiasa * 0);

    print('a1 = ' + a1.toString());

    //menghitung luas
    //integral tentu t1 - t2

    double a2 = ((0.05 * 1 / 2 * pow(t2, 2)) - (3 * t2)) - ((0.05 * 1 / 2 * pow(t1, 2)) - (3 * t1));
    // double a2 = (((0.5 * 1 / 2 * pow(t2, 2)) - (3 * t2)) - ((0.5 * 1 / 2 * pow(t1, 2)) - (3 * t1)));

    print('a2 = ' + a2.toString());

    //menghtiung luas
    //integral tentu t2 - 80
    double a3 = (maxLuarBiasa * 80) - (maxLuarBiasa * t2);

    print('a3 = ' + a3.toString());

    return (m1 + m2 + m3) / (a1 + a2 + a3);
  }
}
