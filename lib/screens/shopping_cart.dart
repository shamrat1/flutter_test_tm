import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_tr_store/models/cart.dart';
import 'package:test_tr_store/providers/cart_state.dart';

class ShoppingCart extends ConsumerStatefulWidget {
  const ShoppingCart({super.key});

  @override
  ConsumerState<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends ConsumerState<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    var cart = ref.watch(cartProvider);
    var subTotal = 0;
    var discount = 0;
    var deliveryCharge = 0;
    var vat = 0.0;
    if (cart.isNotEmpty) {
      subTotal = cart.fold(
          0,
          (sum, cartItem) =>
              sum + (cartItem.product.userId * cartItem.quantity));
      vat = 0.05 * subTotal;
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Cart",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < cart.length; i++) getCartItem(cart[i]),
              if (cart.isEmpty)
                Container(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Items in your Cart."),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Start Shopping")),
                    ],
                  ),
                ),
              if (cart.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Text(
                    "Order Summery",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.black54),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      getOrderSummaryItem("Subtotal", "\$$subTotal"),
                      getOrderSummaryItem("Discount", "\$$discount"),
                      getOrderSummaryItem(
                          "Delivery Charge", "\$$deliveryCharge"),
                      getOrderSummaryItem("Vat", "\$${vat.toStringAsFixed(2)}"),
                      const Divider(
                        color: Colors.grey,
                      ),
                      getOrderSummaryItem("Total",
                          "\$${(subTotal + discount + deliveryCharge + vat).toStringAsFixed(2)}",
                          showLargeKey: true),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget getOrderSummaryItem(String key, String value,
      {bool showLargeKey = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: showLargeKey
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: showLargeKey
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget getCartItem(Cart item) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 5,
              color: Colors.grey.shade100,
            )
          ]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: CachedNetworkImage(
              imageUrl: item.product.thumbnail,
              width: 130,
              fit: BoxFit.cover,
              errorWidget: (context, url, trace) {
                return Container(
                  color: Colors.white,
                );
              },
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width - 32) - 130,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.product.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.product.userId * item.quantity} ",
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .updateCart(item.product, item.quantity + 1),
                              child: const Icon(Icons.add)),
                          Text("${item.quantity}"),
                          GestureDetector(
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .updateCart(item.product, item.quantity - 1),
                              child: const Icon(Icons.remove))
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
