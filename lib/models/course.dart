class CourseModel {
  final int? courseId;
  final String courseName;
  final String CourseCode;

  CourseModel({
     this.courseId,
    required this.courseName,
    required this.CourseCode,
  });

  // ✅ toMap method
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'CourseCode': CourseCode,
    };
  }

  // Factory constructor for JSON -> object
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseId'] ?? 0,
      courseName: json['courseName'] ?? '',
      CourseCode: json['CourseCode'] ?? '',
    );
  }
}
