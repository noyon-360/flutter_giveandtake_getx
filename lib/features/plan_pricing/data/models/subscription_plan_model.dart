class SubscriptionPlan {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> features;
  final String for_;
  final String valid;
  final String createdAt;
  final String updatedAt;
  final int v;

  SubscriptionPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.features,
    required this.for_,
    required this.valid,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      for_: json['for'] as String? ?? '',
      valid: json['valid'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      v: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'features': features,
      'for': for_,
      'valid': valid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  @override
  String toString() {
    return 'SubscriptionPlan{id: $id, title: $title, for_: $for_, price: $price}';
  }
}
