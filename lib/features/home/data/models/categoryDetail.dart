import 'package:qenan/features/home/data/models/sections.dart';
import 'package:qenan/features/home/data/models/localizedText.dart';

class CategoryDetail {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final String main_color;
  final String ascent_color;
  final List<Sections> courses;

  CategoryDetail(
      {required this.id,
      required this.name,
      required this.description,
      required this.main_color,
      required this.ascent_color,
      required this.courses});

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      main_color: json['main_color']?.toString() ?? '',
      ascent_color: json['ascent_color']?.toString() ?? '',
      courses: (json['courses'] as List<dynamic>?)
              ?.map((item) => Sections.fromJson(item))
              .toList() ??
          [],
    );
  }
}
