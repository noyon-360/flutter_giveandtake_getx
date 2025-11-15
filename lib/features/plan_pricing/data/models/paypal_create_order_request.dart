class PaypalCreateOrderRequest {
  final String amount;

  PaypalCreateOrderRequest({required this.amount});

  Map<String, dynamic> toJson() {
    return {'amount': amount};
  }
}
