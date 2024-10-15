import 'package:qenan/features/home/data/models/localizedText.dart';

class MainCategory {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final String main_color;
  final String ascent_color;

  MainCategory(
      {required this.id,
      required this.name,
      required this.description,
      required this.main_color,
      required this.ascent_color});

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    return MainCategory(
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
    );
  }
}
