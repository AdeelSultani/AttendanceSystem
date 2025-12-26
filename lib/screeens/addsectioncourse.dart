import 'package:attendence_system/apiservices/addcourseservices.dart';
import 'package:attendence_system/apiservices/addsectionservices.dart';
import 'package:attendence_system/models/course.dart';
import 'package:attendence_system/models/section.dart';
import 'package:flutter/material.dart';

class SectionCourseScreen extends StatefulWidget {
  int teacherid;
  SectionCourseScreen({super.key, required this.teacherid});

  @override
  State<SectionCourseScreen> createState() => _SectionCourseScreenState();
}

class _SectionCourseScreenState extends State<SectionCourseScreen> {
  SectionModel? selectedSection;
  CourseModel? selectedCourse;

   int? teacherid;

  List<SectionModel> sectionList = [];
  List<CourseModel> courseList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    sectionList = await AddSectionServices().getSections();
    courseList = await Addcourseservices().getCourses();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    teacherid = widget.teacherid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Section & Course'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 🔽 Section Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<SectionModel>(
                      value: selectedSection,
                      hint: const Text('Select Section'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: sectionList
                          .map(
                            (s) => DropdownMenuItem<SectionModel>(
                              value: s,
                              child: Text(s.sectionName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSection = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<CourseModel>(
                      value: selectedCourse,
                      hint: const Text('Select Course'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: courseList
                          .map(
                            (c) => DropdownMenuItem<CourseModel>(
                              value: c,
                              child: Text(c.CourseName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCourse = value;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async{
                      if (selectedSection != null &&
                          selectedCourse != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Section: ${selectedSection!.sectionId}, '
                              'Course: ${selectedCourse!.CourseId}',
                            ),
                          ),

                        );
                        int? cid=selectedCourse!.CourseId;
                        int? sid=selectedSection!.sectionId;
                        
                        var response= await Addcourseservices().addcoursetosection(cid,sid,teacherid!);
                        if(response.statusCode==200){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Course successfully assigned to the Section '))
    );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade100,
                    ),
                    child: const Text('Add Course Section'),
                  ),
                ],
              ),
      ),
    );
  }
}
