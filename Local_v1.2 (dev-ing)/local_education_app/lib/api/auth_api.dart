import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_education_app/constants/api_constant.dart';

Future<dynamic> authLogin(String userName, String password) async {
  try {
    final response = await http.post(
      Uri.parse(ApiEndpoint.authLogin),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': userName,
        'password': password,
      }),
    );
    debugPrint(response.statusCode.toString());
    final body = response.body;
    debugPrint(body);
    return jsonDecode(body);
  } catch (e) {
    debugPrint("There is error while posting $e");
    return null;
  }
}

Future<dynamic> authRegister(
  String name,
  String username,
  String email,
  String password,
) async {
  try {
    final response = await http.post(
      Uri.parse(ApiEndpoint.authRegister),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    final body = response.body;
    return jsonDecode(body);
  } catch (e) {
    debugPrint("There is error while posting $e");
  }
}

Future<dynamic> authGetProfile(String token) async {
  try {
    final response = await http
        .get(Uri.parse(ApiEndpoint.authGetProfile), headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final body = response.body;
    debugPrint(body);
    return jsonDecode(body);
  } catch (e) {
    debugPrint("There is error while getting profile: $e");
  }
}
