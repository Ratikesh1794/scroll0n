import 'reel.dart';

class Category {
  final String name;
  final List<Reel> items;

  Category({
    required this.name,
    required this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => Reel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ReelData {
  final List<Category> categories;

  ReelData({required this.categories});

  factory ReelData.fromJson(Map<String, dynamic> json) {
    return ReelData(
      categories: (json['categories'] as List<dynamic>?)
              ?.map((category) => Category.fromJson(category as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}
