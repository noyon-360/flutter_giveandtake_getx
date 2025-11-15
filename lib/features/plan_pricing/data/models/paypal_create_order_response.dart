class PaypalLink {
  final String href;
  final String rel;
  final String method;

  PaypalLink({required this.href, required this.rel, required this.method});

  factory PaypalLink.fromJson(Map<String, dynamic> json) {
    return PaypalLink(
      href: json['href'] as String? ?? '',
      rel: json['rel'] as String? ?? '',
      method: json['method'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'href': href, 'rel': rel, 'method': method};
  }
}

class PaypalCreateOrderResponse {
  final String orderId;
  final List<PaypalLink> links;

  PaypalCreateOrderResponse({required this.orderId, required this.links});

  factory PaypalCreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return PaypalCreateOrderResponse(
      orderId: json['orderId'] as String? ?? '',
      links:
          (json['links'] as List<dynamic>?)
              ?.map((e) => PaypalLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'orderId': orderId, 'links': links.map((e) => e.toJson()).toList()};
  }

  /// Helper to find approve URL
  String? get approveUrl {
    try {
      final approveLink = links.firstWhere((link) => link.rel == 'approve');
      return approveLink.href;
    } catch (e) {
      return null;
    }
  }
}
