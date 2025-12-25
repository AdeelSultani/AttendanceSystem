import 'package:attendence_system/screeens/addcoursescreen.dart';
import 'package:attendence_system/screeens/addsectionscreen.dart';
import 'package:flutter/material.dart';


class TeacherDashboard extends StatelessWidget {
  final int userId;
  const TeacherDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Dashboard'),
       backgroundColor: Colors.blue.shade100,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Teacher Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Add Course'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddCourseScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.castle_outlined),
              title: Text('Add Section'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddSectionScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Add Student'),
              onTap: () {
               // Navigator.push(context, MaterialPageRoute(builder: (_) => AddStudentScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Add Timetable'),
              onTap: () {
               // Navigator.push(context, MaterialPageRoute(builder: (_) => AddTimetableScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Mark Attendance'),
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (_) => MarkAttendanceScreen()));
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Welcome Teacher userId: $userId')),
    );
  }
}


