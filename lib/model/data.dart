import 'package:cloud_firestore/cloud_firestore.dart';

class ModelData {
  final String nama;
  final String nis;
  final String kelas;

  ModelData({this.nama = '', this.nis = '', this.kelas = ''});

  factory ModelData.fromJson(DocumentSnapshot doc) => ModelData(
        nis: doc.id,
        kelas: doc.get('kelas'),
        nama: doc.get('nama'),
      );
}
