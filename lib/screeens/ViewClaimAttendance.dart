import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class TeacherClaimsScreen extends StatefulWidget {
  final int teacherId;

  const TeacherClaimsScreen({super.key, required this.teacherId});

  @override
  State<TeacherClaimsScreen> createState() => _TeacherClaimsScreenState();
}

class _TeacherClaimsScreenState extends State<TeacherClaimsScreen> {
  List<ClaimDTO> claimsList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadClaims();
  }

  void loadClaims() async {
    try {
      claimsList = await ClaimService().getTeacherClaims(widget.teacherId);
    } catch (e) {
      errorMessage = e.toString();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Claims"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : claimsList.isEmpty
                  ? const Center(child: Text("No claims found"))
                  : ListView.builder(
                      itemCount: claimsList.length,
                      itemBuilder: (context, index) {
                        final claim = claimsList[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(
                              claim.studentName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date: ${claim.date}"),
                                Text("Subject: ${claim.courseName}"),
                                Text("Reason: ${claim.claimReason}"),
                                Text(
                                  "Status: ${claim.claimStatus}",
                                  style: TextStyle(
                                    color: claim.claimStatus == "Pending"
                                        ? Colors.orange
                                        : claim.claimStatus == "Approved"
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

class ClaimDTO {
  final int claimId;
  final String studentName;
  final String claimReason;
  final String claimStatus;
  final String date;
  final String courseName;

  ClaimDTO({
    required this.claimId,
    required this.studentName,
    required this.claimReason,
    required this.claimStatus,
    required this.date,
    required this.courseName,
  });

  factory ClaimDTO.fromJson(Map<String, dynamic> json) {
    return ClaimDTO(
      claimId: json['ClaimId'],
      studentName: json['StudentName'],
      claimReason: json['ClaimReason'],
      claimStatus: json['ClaimStatus'],
      date: json['Date'],
      courseName: json['CourseName'],
    );
  }
}



class ClaimService {
  

  Future<List<ClaimDTO>> getTeacherClaims(int teacherId) async {
    final url = Uri.parse("http://192.168.18.56/AttendenceSystem/api/SubmitClaim/GetClaimsForTeacher?TeacherId=$teacherId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => ClaimDTO.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch claims");
    }
  }
}
