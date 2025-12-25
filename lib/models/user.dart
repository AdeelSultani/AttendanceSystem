class UserModel {
  final int userId;
  final String fullName;
  final String password;
  final String? imagePath;
  final int roleId;


  UserModel({
    required this.userId,
    required this.fullName,
    required this.password,
    required this.imagePath,
    required this.roleId,
  });

}