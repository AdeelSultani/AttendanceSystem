class CourseSectionModel {
  final int courseSectionId;
  final String courseName;
  final String sectionName;

  CourseSectionModel({
    required this.courseSectionId,
    required this.courseName,
    required this.sectionName,
  });

  factory CourseSectionModel.fromJson(Map<String, dynamic> json) {
    return CourseSectionModel(
      courseSectionId: json['CourseSectionId'],
      courseName: json['coursename'],
      sectionName: json['sectionname'],
    );
  }
}
