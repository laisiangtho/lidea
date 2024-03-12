part of 'main.dart';

// NOTE: only type, EnvironmentType child
class ProductsType {
  String cart;
  String name;
  String type;
  String title;
  String description;

  ProductsType({
    required this.cart,
    required this.name,
    required this.type,
    required this.title,
    required this.description,
  });

  factory ProductsType.fromJSON(Map<String, dynamic> o) {
    return ProductsType(
      cart: o['cart'] as String,
      name: o['name'] as String,
      type: o['type'] as String,
      title: o['title'] as String,
      description: o['description'] as String,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'cart': cart,
      'name': name,
      'type': type,
      'title': title,
      'description': description,
    };
  }
}

class ProductsItem {
  dynamic item;
  bool purchased;
  bool consumable;
  String title;
  String description;

  ProductsItem({
    required this.item,
    this.purchased = false,
    this.consumable = false,
    this.title = '',
    this.description = '',
  });
}
