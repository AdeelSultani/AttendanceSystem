import 'package:attendence_system/apiservices/enrollementservices.dart';
import 'package:attendence_system/models/coursesectionmodel.dart';
import 'package:attendence_system/models/studentmodel.dart';
import 'package:flutter/material.dart';

class EnrollementScreen extends StatefulWidget {
  const EnrollementScreen({super.key});

  @override
  State<EnrollementScreen> createState() => _EnrollementScreenState();
}

class _EnrollementScreenState extends State<EnrollementScreen> {
  StudentModel? selectedStudent;
  CourseSectionModel? selectedCourseSection;

  List<StudentModel> students = [];
  List<CourseSectionModel> courseSections = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    students = await Enrollementservices().getStudents();
    courseSections = await Enrollementservices().getCourseSections();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Student"),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [

                  /// 🔽 Student Dropdown
                  DropdownButtonFormField<StudentModel>(
                    value: selectedStudent,
                    hint: const Text("Select Student"),
                    items: students.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.fullName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStudent = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 🔽 Course + Section Dropdown
                  DropdownButtonFormField<CourseSectionModel>(
                    value: selectedCourseSection,
                    hint: const Text("Select Course & Section"),
                    items: courseSections.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(
                            "${c.courseName} - ${c.sectionName}"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCourseSection = value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  /// ✅ Button
                ElevatedButton(
  onPressed: () async {
    if (selectedStudent != null && selectedCourseSection != null) {
      bool success = await Enrollementservices().enrollStudent(
        courseSectionId: selectedCourseSection!.courseSectionId,
        studentId: selectedStudent!.userId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selectedStudent!.fullName} enrolled to ${selectedCourseSection!.courseName}',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enrollment failed!'),
          ),
        );
      }
    }
  },
  child: const Text('Enroll Student'),
)

                ],
              ),
      ),
    );
  }
}
