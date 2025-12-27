import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../apiservices/attendanceservices.dart';


class StudentAttendanceScreen extends StatefulWidget {
  final int studentId;

  const StudentAttendanceScreen({super.key, required this.studentId});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  List<StudentAttendanceModel> attendanceList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  void loadAttendance() async {
    try {
      attendanceList =
          await AttendanceService().getStudentAttendance(widget.studentId);
    } catch (e) {
      errorMessage = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Attendance"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : attendanceList.isEmpty
                  ? const Center(child: Text("No attendance found"))
                  : ListView.builder(
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        final item = attendanceList[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(
                              "Teacher: ${item.teacherName}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Student: ${item.studentName}"),
                                Text("Date: ${item.date}"),
                                Text(
                                  "Status: ${item.status}",
                                  style: TextStyle(
                                    color: item.status == "Present"
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
class StudentAttendanceModel {
  final String teacherName;
   final int teacherId;
  final String studentName;
  final String date;
  final String status;

  StudentAttendanceModel({
    required this. teacherId,
    required this.teacherName,
    required this.studentName,
    required this.date,
    required this.status,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      teacherId: json['TeacherId'],
      teacherName: json['TeacherName'],
      studentName: json['StudentName'],
      date: json['Date'],
      status: json['Status'],
    );
  }
}



class AttendanceService {
  static const String baseUrl =
      "http://192.168.18.56/AttendenceSystem/api";

  Future<List<StudentAttendanceModel>> getStudentAttendance(int studentId) async {
    final url = Uri.parse(
        "$baseUrl/attendance/getstudentattendance?studentid=$studentId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data
          .map((e) => StudentAttendanceModel.fromJson(e))
          .toList();
    } else {
      throw Exception("No attendance data found");
    }
  }
}
