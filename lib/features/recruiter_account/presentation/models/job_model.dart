class JobModel {
  final String? id;
  final String? title;
  final String? companyName;
  final String? country;
  final String? location;
  final String? jobType;
  final int? daysAgo;

  JobModel({
    this.id,
    this.title,
    this.companyName,
    this.country,
    this.location,
    this.jobType,
    this.daysAgo,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'],
      title: json['title'],
      companyName: json['companyName'],
      country: json['country'],
      location: json['location'],
      jobType: json['jobType'],
      daysAgo: json['daysAgo'],
    );
  }
}
