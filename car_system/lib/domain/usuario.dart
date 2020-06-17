class Usuario{
  int id;
  String login;
  String name;
  String email;
  String profileImage;
  String token;
  List roles;

  Usuario({this.id, this.login, this.profileImage, this.token, this.roles});

  Usuario.fromMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.login = data['login'];
    this.profileImage = data['urlFoto'];
    this.token = data['token'];
    this.name = data['nome'];
    this.email = data['email'];
    this.roles = data['roles'];
  }

  bool isAdmin() {
    return roles != null && roles.contains('ROLE_ADMIN');
  }
}