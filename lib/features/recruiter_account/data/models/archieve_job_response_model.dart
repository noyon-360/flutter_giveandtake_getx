class ArchieveJobResponseModel {
  final String id;
  final String userId;
  final String recruiterId;
  final String title;
  final String description;
  final String salaryRange;
  final String location;
  final String shift;
  final List<dynamic> responsibilities;
  final List<dynamic> educationExperience;
  final List<dynamic> benefits;
  final int vacancy;
  final int counter;
  final List<double> embedding;

  ArchieveJobResponseModel({
    required this.id,
    required this.userId,
    required this.recruiterId,
    required this.title,
    required this.description,
    required this.salaryRange,
    required this.location,
    required this.shift,
    required this.responsibilities,
    required this.educationExperience,
    required this.benefits,
    required this.vacancy,
    required this.counter,
    required this.embedding,
  });

  factory ArchieveJobResponseModel.fromJson(Map<String, dynamic> json) {
    return ArchieveJobResponseModel(
      id: json["_id"] ?? "",
      userId: json["userId"] ?? "",
      recruiterId: json["recruiterId"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      salaryRange: json["salaryRange"] ?? "",
      location: json["location"] ?? "",
      shift: json["shift"] ?? "",
      responsibilities: json["responsibilities"] ?? [],
      educationExperience: json["educationExperience"] ?? [],
      benefits: json["benefits"] ?? [],
      vacancy: json["vacancy"] ?? 0,
      counter: json["counter"] ?? 0,
      embedding: json["embedding"] != null
          ? List<double>.from(json["embedding"].map((e) => (e as num).toDouble()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "recruiterId": recruiterId,
      "title": title,
      "description": description,
      "salaryRange": salaryRange,
      "location": location,
      "shift": shift,
      "responsibilities": responsibilities,
      "educationExperience": educationExperience,
      "benefits": benefits,
      "vacancy": vacancy,
      "counter": counter,
      "embedding": embedding,
    };
  }
}
