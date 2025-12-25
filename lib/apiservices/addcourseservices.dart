import 'dart:convert';

import 'package:attendence_system/models/course.dart';
import 'package:http/http.dart' as http;

class Addcourseservices {
Future<http.Response> registerCourse(CourseModel course) async {
  final url = Uri.parse('http://192.168.18.56/AttendenceSystem/api/course/Registercourse');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(course.toMap()),
  );

return response;
}

}