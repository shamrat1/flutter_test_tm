import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

typedef ProductList = List<Product>;

@freezed
class Product with _$Product {
  factory Product({
    @Default(0) int id,
    @Default('') String slug,
    @Default('') String title,
    @Default('') String content,
    @Default('') String image,
    @Default('') String thumbnail,
    @Default('') String status,
    @Default('') String category,
    @Default('') String publishedAt,
    @Default('') String updatedAt,
    @Default(0) int userId,
  }) = _Product;

  factory Product.fromJson(dynamic json) => _$ProductFromJson(json);
}
