import 'package:cloud_firestore/cloud_firestore.dart';

class ModelGuru {
  final String id;
  final String nip;
  final String nama;
  final String kelas;
  final String email;

  ModelGuru({this.id = '', this.nip = '', this.nama = '', this.kelas = '', this.email = ''});

  factory ModelGuru.fromJson(DocumentSnapshot doc) => ModelGuru(
        id: doc.id,
        nip: doc.get('nip'),
        nama: doc.get('nama'),
        kelas: doc.get('kelas'),
        email: doc.get('email'),
      );
}
