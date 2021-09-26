class ModelGuru {
  final String nip;
  final String nama;
  final String kelas;

  ModelGuru({this.nip = '', this.nama = '', this.kelas = ''});

  factory ModelGuru.fromJson(Map<String, dynamic> json) => ModelGuru(
        nip: json['nip'],
        nama: json['nama'],
        kelas: json['kelas'],
      );
}
