import 'package:qenan/features/home/data/models/localizedText.dart';
import 'package:qenan/features/home/data/models/mainCategory.dart';
import 'package:qenan/features/home/data/models/pivot.dart';

class CourseSubCategory {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final String category_id;
  final String main_color;
  final String ascent_color;
  final Pivot pivot;
  final MainCategory main_category;
  CourseSubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.category_id,
    required this.main_color,
    required this.ascent_color,
    required this.pivot,
    required this.main_category,
  });

  factory CourseSubCategory.fromJson(Map<String, dynamic> json) {
    return CourseSubCategory(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      category_id: json['category_id']?.toString() ?? '',
      main_color: json['main_color']?.toString() ?? '',
      ascent_color: json['ascent_color']?.toString() ?? '',
      pivot: Pivot.fromJson(json['pivot'] ?? {}),
      main_category: MainCategory.fromJson(json['category'] ?? {}),
    );
  }
}
