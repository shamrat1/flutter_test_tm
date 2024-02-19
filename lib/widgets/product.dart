import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_tr_store/models/cart.dart';
import 'package:test_tr_store/models/product/product_model.dart';
import 'package:test_tr_store/providers/cart_state.dart';

class ProductWidget extends StatelessWidget {
  ProductWidget({super.key, required this.product});
  Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      child: Consumer(builder: (context, ref, child) {
        var cart = ref.watch(cartProvider);
        Cart cartItem = cart.firstWhere(
            (element) => element.product.id == product.id,
            orElse: () => Cart(product: Product(), quantity: -1));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Hero(
                tag: product.id,
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, trace) {
                    return Container(
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                product.title,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$ ${product.userId}",
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
                AnimatedCrossFade(
                    firstChild: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .updateCart(product, cartItem.quantity + 1),
                              child: const Icon(Icons.add)),
                          Text("${cartItem.quantity}"),
                          GestureDetector(
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .updateCart(product, cartItem.quantity - 1),
                              child: const Icon(Icons.remove))
                        ],
                      ),
                    ),
                    secondChild: GestureDetector(
                      onTap: () =>
                          ref.read(cartProvider.notifier).addToState(product),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
                        child: const Icon(Icons.add_circle),
                      ),
                    ),
                    crossFadeState: cartItem.quantity > 0
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500))
              ],
            ),
          ],
        );
      }),
    );
  }
}
