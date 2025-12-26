class AttendanceModel {
  int? attendanceId; // optional
  int courseSectionId;
  int teacherId;
  int studentId;
  String date; // varchar in DB
  String? status; // optional

  AttendanceModel({
    this.attendanceId,
    required this.courseSectionId,
    required this.teacherId,
    required this.studentId,
    required this.date,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        "CourseSectionId": courseSectionId,
        "TeacherId": teacherId,
        "StudentID": studentId,
        "Date": date,
        "Status": status , // default if null
      };
}
