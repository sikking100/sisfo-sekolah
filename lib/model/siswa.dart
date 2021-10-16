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

class ModelNilai {
  final String semester;
  final num rapor;
  final num spiritual;
  final num sosial;

  ModelNilai({this.semester = '', this.rapor = 0.0, this.spiritual = 0.0, this.sosial = 0.0});

  factory ModelNilai.fromJson(Map<String, dynamic> json) => ModelNilai(
        semester: json['semester'],
        rapor: json['rapor'],
        spiritual: json['spiritual'],
        sosial: json['sosial'],
      );
}
