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
      students =
          await AttendanceService().getEnrolledStudents(widget.courseSectionId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void submitAttendance() async {
  try {
    for (var student in students) {
      AttendanceModel attendance = AttendanceModel(
        courseSectionId: student.courseSectionId,
        teacherId: widget.teacherId,
        studentId: student.studentId,
        date: selectedDate.toString(),
        status: attendanceStatus[student.studentId] ?? 'Present',
      );

    bool flag=  await AttendanceService().markAttendance(attendance);
    if(flag){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance submitted successfully")),
    );
}
    }


  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
        backgroundColor: Colors.blue.shade100,
      ),
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
                          subtitle: Text(
                              "${student.courseName} - ${student.sectionName}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 📅 Date (inside ListTile)
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
                                  "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),

                              const SizedBox(width: 10),

                              // ✅ Present / Absent Dropdown
                              DropdownButton<String>(
                                value:
                                    attendanceStatus[student.studentId] ??
                                        'Present',
                                items: ['Present', 'Absent']
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    attendanceStatus[student.studentId] = val!;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade100
                    ),
                    onPressed: submitAttendance,
                    child: const Text("Submit Attendance"),
                  ),
                ],
              ),
            ),
    );
  }
}
