class Meta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Meta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['currentPage'],
        totalPages: json['totalPages'],
        totalItems: json['totalItems'],
        itemsPerPage: json['itemsPerPage'],
      );

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
        "itemsPerPage": itemsPerPage,
      };
}
