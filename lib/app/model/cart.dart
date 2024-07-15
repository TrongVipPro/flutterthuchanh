import 'dart:convert';

class Cart {
  int productID;
  String name;
  int price;
  String img;
  String des;
  int count;

  Cart({
    required this.productID,
    required this.name,
    required this.price,
    required this.img,
    required this.des,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'name': name,
      'price': price,
      'img': img,
      'des': des,
      'count': count,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      productID: map['productID'],
      name: map['name'],
      price: map['price'],
      img: map['img'],
      des: map['des'],
      count: map['count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(productID: $productID, name: $name, price: $price, img: $img, des: $des, count: $count)';
  }
}
