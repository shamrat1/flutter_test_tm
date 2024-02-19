// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      image: json['image'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      status: json['status'] as String? ?? '',
      category: json['category'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'content': instance.content,
      'image': instance.image,
      'thumbnail': instance.thumbnail,
      'status': instance.status,
      'category': instance.category,
      'publishedAt': instance.publishedAt,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
    };
