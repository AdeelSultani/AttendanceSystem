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


Future<List<CourseModel>> getCourses() async {
  final response = await http.get(
    Uri.parse('http://192.168.18.56/AttendenceSystem/api/course/Getcourse'),
  );

  if (response.statusCode == 200) {
    List jsonData = json.decode(response.body);
    return jsonData.map((e) => CourseModel.fromJson(e)).toList();
  } else {
    throw Exception('No Section Found');
  }
}Future<http.Response> addcoursetosection(
    int? CourseId,
    int? SectionId,
    int TeacherId,
) async { 
    final response = await http.post(
      Uri.parse('http://192.168.18.56/AttendenceSystem/api/course/AddCoursetoSection?CourseId=$CourseId&SectionId=$SectionId&TeacherId=$TeacherId'),
    );

  return response;
}
}