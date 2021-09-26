class ModelTahunAjar {
  final String tahunAjar;

  ModelTahunAjar({this.tahunAjar = ''});

  factory ModelTahunAjar.fromJson(Map<String, dynamic> json) => ModelTahunAjar(tahunAjar: json['tahun-ajaran']);
}
