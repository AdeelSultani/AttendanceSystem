class EnrolledStudent {
  final int studentId;
  final String fullName;
  final int courseSectionId;
  final String courseName;
  final String sectionName;

  EnrolledStudent({
    required this.studentId,
    required this.fullName,
    required this.courseSectionId,
    required this.courseName,
    required this.sectionName,
  });

  factory EnrolledStudent.fromJson(Map<String, dynamic> json) {
    return EnrolledStudent(
      studentId: json['StudentId'],
      fullName: json['FullName'],
      courseSectionId: json['CourseSectionId'],
      courseName: json['CourseName'],
      sectionName: json['SectionName'],
    );
  }
}
