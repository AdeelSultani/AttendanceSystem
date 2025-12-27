import 'package:attendence_system/screeens/claimattendancescreen.dart';
import 'package:attendence_system/screeens/studentattendancescreen.dart';
import 'package:flutter/material.dart';


class StudentDashboard extends StatelessWidget {
  final int studentId;
  const StudentDashboard({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Dashboard'),
      backgroundColor: Colors.blue.shade100,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Student Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('View Attendance'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentAttendanceScreen(studentId: studentId)));
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Claim Attendance'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ClaimAttendanceScreen(studentId: studentId)));
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Welcome Student id: $studentId')),
    );
  }
}
