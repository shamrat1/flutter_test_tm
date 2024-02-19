import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_tr_store/models/product/product_model.dart';
import 'package:http/http.dart' as http;

final singleProductProvider =
    FutureProvider.family<Product, int>((ref, id) async {
  try {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.org/posts/$id'));
    final List<dynamic> data = json.decode(response.body);
    final Product product = Product.fromJson(json);

    return product;
  } catch (e) {
    if (e is SocketException) {
      Fluttertoast.showToast(msg: "failed to load Product details");
    }
    throw Exception("Failed To Load Product");
  }
});
