import 'dart:convert';
import 'package:attendence_system/models/coursesectionmodel.dart';
import 'package:attendence_system/models/studentmodel.dart';
import 'package:http/http.dart' as http;

class Enrollementservices {
  final String baseUrl =
      "http://192.168.18.56/AttendenceSystem/api";

  /// 🔹 Get Students
  Future<List<StudentModel>> getStudents() async {
    final response =
        await http.get(Uri.parse('$baseUrl/student/GetStudents'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => StudentModel.fromJson(e)).toList();
    } else {
      throw Exception("Students load failed");
    }
  }

  /// 🔹 Get Course Sections
  Future<List<CourseSectionModel>> getCourseSections() async {
    final response =
        await http.get(Uri.parse('$baseUrl/student/GetCourseSection'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((e) => CourseSectionModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Course section load failed");
    }
  }
  Future<bool> enrollStudent({
    required int courseSectionId,
    required int studentId,
  }) async {
    final url = Uri.parse(
        '$baseUrl/Student/Enrollstudent?CourseSectionId=$courseSectionId&StudentId=$studentId');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        // Successfully enrolled
        return true;
      } else {
        // Enrollment failed
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
