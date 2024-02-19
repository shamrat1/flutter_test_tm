import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_tr_store/models/product/product_model.dart';
import 'package:test_tr_store/providers/remote_products_provider.dart';

final localProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'products_database.db'),
  );
  final List<Map<String, dynamic>> products =
      await database.query(productsTable);
  return products.map((e) => Product.fromJson(e)).toList();
});
