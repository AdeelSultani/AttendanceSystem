import 'package:attendence_system/apiservices/attendanceservices.dart';
import 'package:attendence_system/models/attendancemodel.dart';
import 'package:attendence_system/models/enrolledstudentmodel.dart';
import 'package:flutter/material.dart';


class MarkAttendanceScreen extends StatefulWidget {
  final int teacherId;
  final int courseSectionId;

  const MarkAttendanceScreen({
    super.key,
    required this.teacherId,
    required this.courseSectionId,
  });

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  List<EnrolledStudent> students = [];
  Map<int, String> attendanceStatus = {}; // studentId -> Present/Absent
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadEnrolledStudents();
  }

  void loadEnrolledStudents() async {
    try {
      students = await AttendanceService().getEnrolledStudents(widget.courseSectionId);
      setState(() {
        //attendanceStatus = {for (var s in students) s.studentId: 'Present'};
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void submitAttendance() async {
    for (var student in students) {
      AttendanceModel attendance = AttendanceModel(
        courseSectionId: student.courseSectionId,
        teacherId: widget.teacherId,
        studentId: student.studentId,
        date: selectedDate.toIso8601String().split('T')[0],
        status: attendanceStatus[student.studentId] ?? 'Present',
      );

      await AttendanceService().markAttendance(attendance);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance submitted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mark Attendance")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return ListTile(
                          title: Text(student.fullName),
                          subtitle: Text("${student.courseName} - ${student.sectionName}"),
                          trailing: DropdownButton<String>(
                            value: attendanceStatus[student.studentId],
                            items: ['Present', 'Absent']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                attendanceStatus[student.studentId] = val!;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  Row(
                    children: [
                      const Text("Date: "),
                      TextButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: Text(
                            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: submitAttendance,
                    child: const Text("Submit Attendance"),
                  ),
                ],
              ),
            ),
    );
  }
}
