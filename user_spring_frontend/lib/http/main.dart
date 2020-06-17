import 'dart:convert';

import 'package:http/http.dart' as http;

const url = 'http://127.0.0.1:8080';

class InvalidResponseException implements Exception {
  final http.Response response;

  InvalidResponseException(this.response);
}

void ensureStatuses(http.Response response, List<int> codes) {
  if (! codes.contains(response.statusCode)) {
    throw InvalidResponseException(response);
  }
}

Future<http.Response> httpCall(
  dynamic method,
  String request, 
    {Map<String, String> headers, String body, List<int> codes}
  ) async {
  Map<Symbol, dynamic> options = {};
  
  if (headers != null) {
    options[Symbol('headers')] = headers;
  }

  if (body != null) {
    options[Symbol('body')] = body;
  }

  http.Response response = await Function.apply(method, ['$url/$request'], options);
  ensureStatuses(response, codes == null ? const [200] : codes);
  return response;
}

Future<dynamic> jsonHttpCall(
  dynamic method,
  String request, 
    {Map<String, dynamic> payload,
    Map<String, String> headers = const {}, 
    List<int> codes}
  ) async {
  String body;

  if (payload != null) {
    body = json.encode(payload);
    headers = headers == null ? Map<String, String>() : headers;
    headers.putIfAbsent('Content-Type', () => 'application/json');
  }

  http.Response response = await httpCall(method, request, headers: headers, body: body);
  return json.decode(response.body);
}

Future<dynamic> getJson(
  String endpoint, 
    {Map<String, String> headers, String body, List<int> codes}
  ) async {
  return await jsonHttpCall(
    http.get, 
    endpoint, 
      headers: headers, codes: codes);
}

Future<dynamic> postJson(
  String endpoint,
  Map<String, dynamic> payload,
    {Map<String, String> headers, List<int> codes}
  ) async {
  return await jsonHttpCall(
    http.post, 
    endpoint, 
      headers: headers, payload: payload, codes: codes);
}

Future<dynamic> putJson(
  String endpoint,
  Map<String, dynamic> payload,
    {Map<String, String> headers, List<int> codes}
  ) async {
  return await jsonHttpCall(
    http.put, 
    endpoint, 
      headers: headers, payload: payload, codes: codes);
}

Future<dynamic> deleteJson(
  String endpoint,
    {Map<String, String> headers, List<int> codes}
  ) async {
  return await jsonHttpCall(
    http.delete, 
    endpoint, 
      headers: headers, codes: codes);
}
