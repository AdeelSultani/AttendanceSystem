import 'dart:convert';
import 'package:attendence_system/models/section.dart';
import 'package:http/http.dart' as http;

class AddSectionServices {
Future<http.Response> registerSection(SectionModel section) async {
  final url = Uri.parse('http://192.168.18.56/AttendenceSystem/api/course/Registersection');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(section.toMap()),
  );

return response;
}
Future<List<SectionModel>> getSections() async {
  final response = await http.get(
    Uri.parse('http://192.168.18.56/AttendenceSystem/api/course/getsection'),
  );

  if (response.statusCode == 200) {
    List jsonData = json.decode(response.body);
    return jsonData.map((e) => SectionModel.fromJson(e)).toList();
  } else {
    throw Exception('No Section Found');
  }
}
}