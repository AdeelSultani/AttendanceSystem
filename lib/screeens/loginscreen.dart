import 'dart:convert';

import 'package:attendence_system/apiservices/loginservices.dart';
import 'package:attendence_system/models/user.dart';
import 'package:attendence_system/screeens/TeacherDashboard.dart';
import 'package:attendence_system/screeens/studentdashboard.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void loginUser() async {
    final name = nameController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      var response = await ApiService().login(name, password);
 
      if (response.statusCode == 200) {
        var jsons=jsonDecode(response.body);
        int roleId=jsons['Roleid'];
      final userId = jsons['UserId'];
  if (roleId == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TeacherDashboard(userId: userId)),
        );
      } else {  
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => StudentDashboard(studentId: userId)),
        );
      }
      }else if(response.statusCode==404){
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User Not Exist')),
      );
      } 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Login"),
      backgroundColor: Colors.blue.shade100,
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Text("Login",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
           SizedBox(height: 30,),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
           SizedBox(height: 30,),
            ElevatedButton(
              onPressed: isLoading ? null : loginUser,
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text("Login"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent.shade100
            ),
            ),
          ],
        ),
      ),
    );
  }
}
