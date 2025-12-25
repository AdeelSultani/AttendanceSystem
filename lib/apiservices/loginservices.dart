
import 'dart:convert';

import 'package:attendence_system/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService{

   static String baseurl="http://192.168.18.56/AttendenceSystem/api";

  Future<http.Response> login(String fullName, String password) async {
    //final url = Uri.parse('$baseurl/student/login');
    final resp = await http.post(
      Uri.parse('http://192.168.18.56/AttendenceSystem/api/student/login?username=${fullName}&password=${password}'),
    );

   return resp;

  }
}