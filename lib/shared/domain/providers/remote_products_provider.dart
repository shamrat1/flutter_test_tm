// Define the table and columns for the products
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_tr_store/shared/domain/models/product/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:test_tr_store/shared/domain/providers/local_products_provider.dart';

const String productsTable = 'products';

final remoteProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'products_database.db'),
    onCreate: (db, version) {
      return db.execute(
        '''CREATE TABLE $productsTable (
              id INTEGER PRIMARY KEY,
              slug TEXT,
              title TEXT,
              content TEXT,
              image TEXT,
              thumbnail TEXT,
              status TEXT,
              category TEXT,
              publishedAt TEXT,
              updatedAt TEXT,
              userId INTEGER
            )''',
      );
    },
    version: 1,
  );
  try {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.org/posts'));
    final List<dynamic> data = json.decode(response.body);
    final List<Product> products =
        data.map((json) => Product.fromJson(json)).toList();

    for (final product in products) {
      await database.insert(
        productsTable,
        product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return ref.read(localProductsProvider.future);
  } catch (e) {
    if (e is SocketException) {
      var oldData = await ref.read(localProductsProvider.future);
      Fluttertoast.showToast(msg: "No Internet");
      if (oldData.isNotEmpty) {
        Fluttertoast.showToast(msg: "Showing Previously Cached Data");

        return oldData;
      }
      throw Exception("Connect to internet to load");
    } else {
      return [];
    }
  }
});
