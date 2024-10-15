import 'package:qenan/features/home/data/models/localizedText.dart';
import 'package:qenan/features/home/data/models/mainCategory.dart';

class Category {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final MainCategory main_category;
  final String main_color;
  final String ascent_color;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.main_category,
    required this.main_color,
    required this.ascent_color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      main_category: MainCategory.fromJson(json['category'] ?? {}),
      main_color: json['main_color']?.toString() ?? '',
      ascent_color: json['ascent_color']?.toString() ?? '',
    );
  }
}
