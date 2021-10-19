import 'package:cloud_firestore/cloud_firestore.dart';

class ModelData {
  final String nama;
  final String nis;
  final String kelas;
  final double nilai;
  final String keterangan;

  ModelData({this.nama = '', this.nis = '', this.kelas = '', this.nilai = 0.0, this.keterangan = ''});

  factory ModelData.fromJson(DocumentSnapshot doc) => ModelData(
        nis: doc.id,
        kelas: doc.get('kelas'),
        nama: doc.get('nama'),
        nilai: doc.get('nilaiFuzzy'),
        keterangan: doc.get('keterangan'),
      );
}
