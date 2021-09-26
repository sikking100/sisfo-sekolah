class ModelSiswa {
  final String nama;
  final String nis;
  final String kelas;

  ModelSiswa({this.nama = '', this.nis = '', this.kelas = ''});

  factory ModelSiswa.fromJson(Map<String, dynamic> json) => ModelSiswa(
        nama: json['nama'],
        kelas: json['kelas'],
        nis: json['nis'],
      );
}
