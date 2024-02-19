import 'package:test_tr_store/models/product/product_model.dart';

class Cart {
  int quantity;
  Product product;

  Cart({
    this.quantity = 1,
    required this.product,
  });

  Cart copyWith({
    int? quantity,
    Product? product,
  }) {
    return Cart(
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
