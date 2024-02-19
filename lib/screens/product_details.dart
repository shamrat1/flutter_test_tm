import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_tr_store/models/cart.dart';
import 'package:test_tr_store/models/product/product_model.dart';
import 'package:test_tr_store/providers/cart_state.dart';
import 'package:test_tr_store/providers/single_product_provider.dart';
import 'package:test_tr_store/screens/shopping_cart.dart';

class ProductDetails extends ConsumerStatefulWidget {
  ProductDetails({super.key, required this.product});
  Product product;

  @override
  ConsumerState<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends ConsumerState<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    var singleProduct = ref.watch(singleProductProvider(widget.product.id));
    var cart = ref.watch(cartProvider);
    Cart cartItem = cart.firstWhere(
        (element) => element.product.id == widget.product.id,
        orElse: () => Cart(product: Product(), quantity: -1));
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.product.title,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const ShoppingCart())),
            icon: Badge(
              label: Text(cart.length.toString()),
              child: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      body: singleProduct.when(
          data: (data) {
            return _getProductView(data, cartItem);
          },
          error: (err, trace) => _getProductView(widget.product, cartItem),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }

  Widget _getProductView(Product product, Cart cartItem) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, trace) {
                    return Container(
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                        "\$${product.userId}",
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
                                        .updateCart(
                                            product, cartItem.quantity + 1),
                                    child: const Icon(Icons.add)),
                                Text("${cartItem.quantity}"),
                                GestureDetector(
                                    onTap: () => ref
                                        .read(cartProvider.notifier)
                                        .updateCart(
                                            product, cartItem.quantity - 1),
                                    child: const Icon(Icons.remove))
                              ],
                            ),
                          ),
                          secondChild: GestureDetector(
                            onTap: () => ref
                                .read(cartProvider.notifier)
                                .addToState(product),
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
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.3,
              child: Text(
                product.content,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
