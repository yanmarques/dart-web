
import 'dart:convert';

import 'package:car_system/pages/cars/car.dart';
import 'package:http/http.dart' as http;

const apiUrl = 'https://carros-springboot.herokuapp.com/api/v1/carros';

class InvalidResponseException implements Exception {
  final http.Response response;

  InvalidResponseException(this.response);
}

Future<List<Car>> fetchCars() async {
  http.Response res = await http.get(apiUrl);

  if (res.statusCode != 200) {
    throw InvalidResponseException(res);
  }

  List carsData = json.decode(res.body);
  return carsData.map<Car>((carData) => Car.fromMap(carData)).toList();
}