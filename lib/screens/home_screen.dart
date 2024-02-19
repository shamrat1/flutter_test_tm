import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_tr_store/main.dart';
import 'package:test_tr_store/providers/cart_state.dart';
import 'package:test_tr_store/providers/remote_products_provider.dart';
import 'package:test_tr_store/screens/product_details.dart';
import 'package:test_tr_store/screens/shopping_cart.dart';
import 'package:test_tr_store/widgets/product.dart';
import 'package:test_tr_store/widgets/product_shimmer.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var productsProvider = ref.watch(remoteProductsProvider);
    var cart = ref.watch(cartProvider);
    return Scaffold(
      // body: _showLoading(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text(
              "TR Store",
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
          productsProvider.when(data: (data) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList.builder(
                itemCount: data.length,
                itemBuilder: (context, i) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ProductDetails(
                            product: data[i],
                          ),
                        ),
                      );
                    },
                    child: ProductWidget(product: data[i])),
              ),
            );
          }, error: (err, trace) {
            return SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(err.toString().replaceAll("Exception: ", "")),
                    TextButton(
                        onPressed: () => ref.refresh(remoteProductsProvider),
                        child: const Text("Refresh"))
                  ],
                ),
              ),
            );
          }, loading: () {
            return SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => const ProductShimmer(),
                ));
          }),
        ],
      ),
    );
  }
}
