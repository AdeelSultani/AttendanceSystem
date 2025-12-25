class SectionModel {
  final int? sectionId; // optional, DB generates it
  final String sectionName;

  SectionModel({
    this.sectionId,
    required this.sectionName,
  });

  // Convert object to Map (for POST / API body)
  Map<String, dynamic> toMap() {
    return {
      'SectionId': sectionId,
      'SectionName': sectionName,
    };
  }

  // Create object from JSON / API response
  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      sectionId: json['SectionId'],
      sectionName: json['SectionName'] ?? '',
    );
  }
}
