class StatusUpdateRequestModel {
  final String status;

  StatusUpdateRequestModel({required this.status});

  Map<String, dynamic> toJson() {
    return {
      "status": status,
    };
  }
}
