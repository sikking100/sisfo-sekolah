class ModelGuru {
  final String nip;
  final String nama;
  final String kelas;
  final String email;

  ModelGuru({this.nip = '', this.nama = '', this.kelas = '', this.email = ''});

  factory ModelGuru.fromJson(Map<String, dynamic> json) => ModelGuru(
        nip: json['nip'],
        nama: json['nama'],
        kelas: json['kelas'],
        email: json['email'],
      );
}
