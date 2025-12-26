class CourseModel {
  final int? CourseId;
  final String CourseName;
  final String CourseCode;

  CourseModel({
     this.CourseId,
    required this.CourseName,
    required this.CourseCode,
  });

  // ✅ toMap method
  Map<String, dynamic> toMap() {
    return {
      'courseId': CourseId,
      'courseName': CourseName,
      'CourseCode': CourseCode,
    };
  }

  // Factory constructor for JSON -> object
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      CourseId: json['CourseId'] ,
      CourseName: json['CourseName'] ,
      CourseCode: json['CourseCode'] ,
    );
  }
}
