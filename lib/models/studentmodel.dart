class StudentModel {
  final int userId;
  final String fullName;
  final String role;

  StudentModel({
    required this.userId,
    required this.fullName,
    required this.role,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      userId: json['UserId'],
      fullName: json['FullName'],
      role: json['Role'],
    );
  }
}
