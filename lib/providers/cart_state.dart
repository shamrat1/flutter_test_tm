import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_tr_store/models/cart.dart';
import 'package:test_tr_store/models/product/product_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<Cart>>((ref) {
  return CartNotifier([]);
});

class CartNotifier extends StateNotifier<List<Cart>> {
  CartNotifier(List<Cart> state) : super(state ?? []);

  void addToState(Product product) {
    state = [...state, Cart(product: product)];
  }

  void updateCart(Product product, int quantity) {
    if (quantity == 0) {
      deleteCartItem(product);
    }
    final index = state.indexWhere((cart) => cart.product.id == product.id);
    print(index != 1);
    if (index != -1) {
      final updatedCart = state[index].copyWith(quantity: quantity);
      print([updatedCart.quantity, updatedCart.product.title, quantity]);
      state = [
        ...state.sublist(0, index),
        updatedCart,
        ...state.sublist(index + 1)
      ];
    }
  }

  void deleteCartItem(Product product) {
    state = state.where((cart) => cart.product != product).toList();
  }
}
