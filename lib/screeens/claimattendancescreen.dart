import 'dart:convert';

import 'package:attendence_system/screeens/submitclaimscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class ClaimAttendanceScreen extends StatefulWidget {
  final int studentId;

  const ClaimAttendanceScreen({super.key, required this.studentId});

  @override
  State<ClaimAttendanceScreen> createState() =>
      _ClaimAttendanceScreenState();
}

class _ClaimAttendanceScreenState extends State<ClaimAttendanceScreen> {
  List<StudentAttendanceModel> attendanceList = [];
  bool isLoading = true;
  String? errorMessage;
  int? AttendanceId;
  int? TeacherId;

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
                      TeacherId=item.teacherId;
                      AttendanceId=item.AttendanceId;
                        return GestureDetector(
                          onTap: () {
                           Navigator.push(context, MaterialPageRoute(
                            builder:
                             (context)=>AddClaimScreen(StudentId:widget.studentId, AttendanceId:AttendanceId! , TeacherId: TeacherId!)));
                          },
                          child: Card(
                            elevation: 5,
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
                          ),
                        );
                      },
                    ),
    );
  }
}
class StudentAttendanceModel {
  final int AttendanceId;
  final String teacherName;
   final int teacherId;
  final String studentName;
  final String date;
  final String status;

  StudentAttendanceModel({
    required this.AttendanceId,
    required this. teacherId,
    required this.teacherName,
    required this.studentName,
    required this.date,
    required this.status,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      AttendanceId:json['AttendanceId'],
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
