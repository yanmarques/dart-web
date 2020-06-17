import 'package:user_spring_frontend/entities/City.dart';

class User {
  int id;
  String name;
  City city;

  User({this.id, this.name, this.city});

  User.fromMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
    if (data['city'] != null) {
      this.city = City.fromMap(data['city']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city == null ? null : city.toMap()
    };
  }

  String toString() => 'User[id=$id name=$name] city=$city';
}