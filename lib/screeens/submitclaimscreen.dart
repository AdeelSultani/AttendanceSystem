import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddClaimScreen extends StatefulWidget {
  final int AttendanceId;
  final int StudentId;
  final int TeacherId;

  const AddClaimScreen({
    super.key,
    required this.AttendanceId,
    required this.StudentId,
    required this.TeacherId,
  });

  @override
  State<AddClaimScreen> createState() => _AddClaimScreenState();
}

class _AddClaimScreenState extends State<AddClaimScreen> {
  final TextEditingController _reasonController = TextEditingController();
  bool isSubmitting = false;

  void submitClaim() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter claim reason")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      ClaimModel claim = ClaimModel(
        attendanceId: widget.AttendanceId,
        studentId: widget.StudentId,
        teacherId: widget.TeacherId,
        claimReason: _reasonController.text.trim(),
      );

    var flage=  await ClaimService().submitClaim(claim);
if(flage){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Claim submitted successfully")),
      );
}
     // Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Attendance Claim"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Claim Reason",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Enter reason for attendance claim",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue.shade100
                ),
                onPressed: isSubmitting ? null : submitClaim,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Claim"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ClaimModel {
  final int attendanceId;
  final int studentId;
  final int teacherId;
  final String claimReason;

  ClaimModel({
    required this.attendanceId,
    required this.studentId,
    required this.teacherId,
    required this.claimReason,
  });

  Map<String, dynamic> toJson() {
    return {
      "attendanceId": attendanceId,
      "studentId": studentId,
      "teacherId": teacherId,
      "claimReason": claimReason,
    };
  }
}


class ClaimService {
  static const String baseUrl =
      "http://192.168.18.56/AttendenceSystem/api";

  Future<bool> submitClaim(ClaimModel claim) async {
    final url = Uri.parse("$baseUrl/SubmitClaim/SubmitClaim");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(claim.toJson()),
    );

    if (response.statusCode ==200) {
    return true;
    }else{
      return false;
    }
  }
}
