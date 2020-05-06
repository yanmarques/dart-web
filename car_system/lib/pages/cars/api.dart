
import 'dart:convert';

import 'package:car_system/pages/cars/car.dart';
import 'package:car_system/web/web_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiUrl = 'https://carros-springboot.herokuapp.com/api/v1';

class InvalidResponseException implements Exception {
  final http.Response response;

  InvalidResponseException(this.response);
}

Future<List<Car>> fetchCars() async {
  http.Response res = await http.get('$apiUrl/carros}');

  if (res.statusCode != 200) {
    throw InvalidResponseException(res);
  }

  List carsData = json.decode(res.body);
  return carsData.map<Car>((carData) => Car.fromMap(carData)).toList();
}

Future<String> upload(InMemoryFile file, Duration timeLimit) async {
  final params = {
    'fileName': file.name,
    'mimeType': file.mimeType,
    'base64': file.base64
  };
  print(params);
  String payload = json.encode(params);

  final headers = {
    'Content-Type': 'application/json'
  };

  final http.Response res = await http.post(
      '$apiUrl/upload',
        body: payload,
        headers: headers,
  ).timeout(timeLimit);
  print(res.statusCode);
  if (res.statusCode != 200) {
    throw InvalidResponseException(res);
  }

  return json.decode(res.body)['url'];
}
