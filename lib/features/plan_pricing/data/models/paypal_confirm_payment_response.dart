class PaypalConfirmPaymentResponse {
  final String id;
  final String status;
  final PaymentSource paymentSource;
  final List<PurchaseUnit> purchaseUnits;
  final List<PaypalLink> links;

  PaypalConfirmPaymentResponse({
    required this.id,
    required this.status,
    required this.paymentSource,
    required this.purchaseUnits,
    required this.links,
  });

  factory PaypalConfirmPaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaypalConfirmPaymentResponse(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      paymentSource: PaymentSource.fromJson(json['payment_source'] ?? {}),
      purchaseUnits: (json['purchase_units'] as List<dynamic>?)
              ?.map((e) => PurchaseUnit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      links: (json['links'] as List<dynamic>?)
              ?.map((e) => PaypalLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'payment_source': paymentSource.toJson(),
      'purchase_units': purchaseUnits.map((e) => e.toJson()).toList(),
      'links': links.map((e) => e.toJson()).toList(),
    };
  }
}

class PaymentSource {
  final CardInfo card;

  PaymentSource({required this.card});

  factory PaymentSource.fromJson(Map<String, dynamic> json) {
    return PaymentSource(
      card: CardInfo.fromJson(json['card'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card': card.toJson(),
    };
  }
}

class CardInfo {
  final String name;
  final String lastDigits;
  final String expiry;
  final String brand;
  final List<String> availableNetworks;
  final String type;
  final BinDetails? binDetails;

  CardInfo({
    required this.name,
    required this.lastDigits,
    required this.expiry,
    required this.brand,
    required this.availableNetworks,
    required this.type,
    this.binDetails,
  });

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      name: json['name'] ?? '',
      lastDigits: json['last_digits'] ?? '',
      expiry: json['expiry'] ?? '',
      brand: json['brand'] ?? '',
      availableNetworks: (json['available_networks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      type: json['type'] ?? '',
      binDetails: json['bin_details'] != null
          ? BinDetails.fromJson(json['bin_details'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'last_digits': lastDigits,
      'expiry': expiry,
      'brand': brand,
      'available_networks': availableNetworks,
      'type': type,
      if (binDetails != null) 'bin_details': binDetails!.toJson(),
    };
  }
}

class BinDetails {
  final String bin;
  final String issuingBank;
  final String binCountryCode;

  BinDetails({
    required this.bin,
    required this.issuingBank,
    required this.binCountryCode,
  });

  factory BinDetails.fromJson(Map<String, dynamic> json) {
    return BinDetails(
      bin: json['bin'] ?? '',
      issuingBank: json['issuing_bank'] ?? '',
      binCountryCode: json['bin_country_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bin': bin,
      'issuing_bank': issuingBank,
      'bin_country_code': binCountryCode,
    };
  }
}

class PurchaseUnit {
  final String referenceId;

  PurchaseUnit({required this.referenceId});

  factory PurchaseUnit.fromJson(Map<String, dynamic> json) {
    return PurchaseUnit(
      referenceId: json['reference_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference_id': referenceId,
    };
  }
}

class PaypalLink {
  final String href;
  final String rel;
  final String method;

  PaypalLink({
    required this.href,
    required this.rel,
    required this.method,
  });

  factory PaypalLink.fromJson(Map<String, dynamic> json) {
    return PaypalLink(
      href: json['href'] ?? '',
      rel: json['rel'] ?? '',
      method: json['method'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'rel': rel,
      'method': method,
    };
  }
}
