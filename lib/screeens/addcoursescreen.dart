
import 'package:attendence_system/apiservices/addcourseservices.dart';
import 'package:attendence_system/models/course.dart';
import 'package:flutter/material.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {

  final _formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final CourseCodeController = TextEditingController();
  bool isLoading = false;

  void addCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final course = CourseModel(
      courseName: courseController.text.trim(),
      CourseCode: CourseCodeController.text.trim(),
    );

  try{
       var response=await Addcourseservices().registerCourse(course);
       if(response.statusCode==200){
       ScaffoldMessenger.of(context).showSnackBar(  const SnackBar(content: Text('Course Added Successfully')),);
       }
  }catch(e){
 ScaffoldMessenger.of(context).showSnackBar(  const SnackBar(content: Text('Something Wrong ')),);
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Course'),
      backgroundColor: Colors.blue.shade100),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter course name' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: CourseCodeController,
                decoration: const InputDecoration(
                  labelText: 'CourseCode',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter CourseCode' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: isLoading ? null : addCourse,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
