class ConnectCompanyRequest {
  final String companyId;

  ConnectCompanyRequest({required this.companyId});

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
    };
  }
}
