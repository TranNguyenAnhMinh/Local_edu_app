import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_education_app/constants/api_constant.dart';

Future<dynamic> getCourses({String keyword = ''}) async {
  try {
    final response = await http.get(
        Uri.parse(ApiEndpoint.getCourse(keyword: keyword)),
        headers: <String, String>{
          'Content-Type': 'application.json',
        });
    final body = response.body;
    return jsonDecode(body);
  } catch (e) {
    debugPrint('There is error while getting courses');
  }

  //TODO: Add GetAll Method
}

Future<dynamic> getCourseBySlug(String slug) async {
  try {
    final response = await http.get(
        Uri.parse(
          ApiEndpoint.getCourseBySlug(slug),
        ),
        headers: <String, String>{
          'Content-Type': 'application.json',
        });
    final body = response.body;
    return jsonDecode(body);
  } catch (e, stack) {
    debugPrint("There is error while getting courses: $e");
    debugPrintStack(stackTrace: stack);
  }
}
