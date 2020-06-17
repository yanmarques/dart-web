import 'package:user_spring_frontend/entities/City.dart';
import 'package:user_spring_frontend/http/main.dart';

Future<City> save(City cityToSave) async {
  Map rawCity = await postJson('cities', cityToSave.toMap());
  return City.fromMap(rawCity);
}