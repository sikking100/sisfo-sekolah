class ModelUser {
  final String name;
  final String nip;
  final String email;

  ModelUser({this.name = '', this.nip = '', this.email = ''});

  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
        name: json['nama'],
        email: json['email'],
        nip: json['nip'],
      );
}
