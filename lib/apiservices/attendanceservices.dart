import 'dart:convert';
import 'package:attendence_system/models/attendancemodel.dart';
import 'package:attendence_system/models/enrolledstudentmodel.dart';
import 'package:http/http.dart' as http;


class AttendanceService {
  final String baseUrl = "http://192.168.18.56/AttendenceSystem/api";
 Future<List<EnrolledStudent>> getEnrolledStudents(int courseSectionId) async {
    final url = Uri.parse('$baseUrl/Attendance/GetEnrolledStudents?courseSectionId=$courseSectionId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => EnrolledStudent.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch enrolled students');
    }
  }





  /// Mark Attendance
  Future<bool> markAttendance(AttendanceModel attendance) async {
    final url = Uri.parse('$baseUrl/Attendance/MarkAttendance');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(attendance.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
