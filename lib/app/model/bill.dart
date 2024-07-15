class BillModel {
  String id;
  String fullName;
  String dateCreated;
  int total;
  List<BillDetailModel> items;

  BillModel({
    required this.id,
    required this.fullName,
    required this.dateCreated,
    required this.total,
    required this.items,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        id: json["id"],
        fullName: json["fullName"],
        dateCreated: json["dateCreated"],
        total: json["total"],
        items: (json['items'] as List)
            .map((item) => BillDetailModel.fromJson(item))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "dateCreated": dateCreated,
        "total": total,
        "items": items.map((item) => item.toJson()).toList(),
      };
}

class BillDetailModel {
  int productId;
  String productName;
  dynamic imageUrl;
  int price;
  int count;
  int total;

  BillDetailModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.count,
    required this.total,
  });

  factory BillDetailModel.fromJson(Map<String, dynamic> json) => BillDetailModel(
        productId: json["productID"] ?? 0,
        productName: json["productName"] ?? "",
        imageUrl: json["imageURL"] ?? "",
        price: json["price"] ?? 0,
        count: json["count"] ?? 0,
        total: json["total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "productName": productName,
        "imageURL": imageUrl,
        "price": price,
        "count": count,
        "total": total,
      };
}


