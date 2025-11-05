class GetCurrencyResponseModel {
  final String id;
  final String code;
  final String currencyName;
  final String primaryCountry;
  final String symbol;
  final String sourceFile;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  GetCurrencyResponseModel({
    required this.id,
    required this.code,
    required this.currencyName,
    required this.primaryCountry,
    required this.symbol,
    required this.sourceFile,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  // From JSON
  factory GetCurrencyResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCurrencyResponseModel(
      id: json['_id'],
      code: json['code'],
      currencyName: json['currencyName'],
      primaryCountry: json['primaryCountry'],
      symbol: json['symbol'],
      sourceFile: json['sourceFile'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}
