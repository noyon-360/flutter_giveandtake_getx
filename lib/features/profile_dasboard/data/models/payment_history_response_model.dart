class PaymentHistoryResponseModel {
  final List<PaymentTransaction> transactions;
  final PaymentMeta meta;

  PaymentHistoryResponseModel({
    required this.transactions,
    required this.meta,
  });

  factory PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponseModel(
      transactions: (json['data'] as List<dynamic>?)
              ?.map((e) => PaymentTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: PaymentMeta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': transactions.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class PaymentTransaction {
  final String id;
  final String userId;
  final double amount;
  final PaymentPlan? planId;
  final String paymentStatus;
  final String duration;
  final String transactionId;
  final String paymentMethod;
  final String planStatus;
  final double refundAdminFee;
  final double refundDeductions;
  final String createdAt;
  final String updatedAt;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    this.planId,
    required this.paymentStatus,
    required this.duration,
    required this.transactionId,
    required this.paymentMethod,
    required this.planStatus,
    required this.refundAdminFee,
    required this.refundDeductions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      planId: json['planId'] != null
          ? PaymentPlan.fromJson(json['planId'] as Map<String, dynamic>)
          : null,
      paymentStatus: json['paymentStatus'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      planStatus: json['planStatus'] as String? ?? '',
      refundAdminFee: (json['refundAdminFee'] as num?)?.toDouble() ?? 0.0,
      refundDeductions: (json['refundDeductions'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'amount': amount,
      'planId': planId?.toJson(),
      'paymentStatus': paymentStatus,
      'duration': duration,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
      'planStatus': planStatus,
      'refundAdminFee': refundAdminFee,
      'refundDeductions': refundDeductions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class PaymentPlan {
  final String id;
  final String title;
  final double price;
  final String valid;

  PaymentPlan({
    required this.id,
    required this.title,
    required this.price,
    required this.valid,
  });

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      valid: json['valid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'price': price,
      'valid': valid,
    };
  }
}

class PaymentMeta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  PaymentMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory PaymentMeta.fromJson(Map<String, dynamic> json) {
    return PaymentMeta(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
    };
  }
}
