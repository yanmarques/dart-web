import 'package:user_spring_frontend/entities/User.dart';
import 'package:user_spring_frontend/http/main.dart';

Future<List<User>> fetchList() async {
  List rawUsers = await getJson('users');
  return rawUsers.map<User>((e) => User.fromMap(e)).toList();
}

Future<User> save(User userToSave) async {
  Map rawUser = await postJson('users', userToSave.toMap());
  return User.fromMap(rawUser);
}

Future<void> delete(User userToDelete) async {
  await deleteJson('users/${userToDelete.id}');
}