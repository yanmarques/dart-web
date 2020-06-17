
import 'dart:convert';

import 'package:car_system/app_model.dart';
import 'package:car_system/domain/usuario.dart';
import 'package:car_system/pages/cars/car.dart';
import 'package:car_system/web/web_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const apiUrl = 'https://carros-springboot.herokuapp.com/api/v2';

class InvalidResponseException implements Exception {
  final http.Response response;

  InvalidResponseException(this.response);
}

Future<List<Car>> fetchCars(BuildContext context) async {
  http.Response res = await http.get(
      '$apiUrl/carros',
        headers: buildAuthHeaders(context)
  );

  if (res.statusCode != 200) {
    throw InvalidResponseException(res);
  }

  List carsData = json.decode(res.body);
  return carsData.map<Car>((carData) => Car.fromMap(carData)).toList();
}

Future<String> upload(BuildContext context, InMemoryFile file, Duration timeLimit) async {
  final params = {
    'fileName': file.name,
    'mimeType': file.mimeType,
    'base64': file.base64
  };

  String payload = json.encode(params);

  final headers = {
    'Content-Type': 'application/json'
  };

  final http.Response res = await http.post(
      '$apiUrl/upload',
        body: payload,
        headers: buildAuthHeaders(context, headers: headers),
  ).timeout(timeLimit);

  if (res.statusCode != 200) {
    throw InvalidResponseException(res);
  }

  return json.decode(res.body)['url'];
}

Future<Usuario> login(String username, String password) async {
  final payload = json.encode({
    'username': username,
    'password': password,
  });

  final headers = {
    'Content-Type': 'application/json',
  };

  http.Response res = await http.post(
    '$apiUrl/login',
      headers: headers,
      body: payload,
  );

  if (res.statusCode != 200) {
    throw new InvalidResponseException(res);
  }

  Map<String, dynamic> data = json.decode(res.body);
  return Usuario.fromMap(data);
}

Future<void> storeCar(BuildContext context,
    String name,
    String description,
    String type,
    [String url]) async {

  final payload = {
    'nome': name,
    'descricao': description,
    'tipo': type,
  };

  if (url != null) {
    payload['urlFoto'] = url;
  }

  final headers = {
    'Content-Type': 'application/json',
  };

  http.Response res = await http.post(
      '$apiUrl/carros',
      body: json.encode(payload),
      headers: buildAuthHeaders(context, headers: headers)
  );

  if (res.statusCode != 201) {
    throw InvalidResponseException(res);
  }
}

Map<String, String> buildAuthHeaders(BuildContext ctx, {Map<String, String> headers}) {
  final authHeaders = {
    'Authorization': 'Bearer ${Provider.of<LoginModel>(ctx).currentUser.token}'
  };

  if (headers != null) {
    authHeaders.addAll(headers);
  }

  return authHeaders;
}