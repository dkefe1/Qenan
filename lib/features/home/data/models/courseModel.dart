import 'package:qenan/features/home/data/models/attachments.dart';
import 'package:qenan/features/home/data/models/courseSubcategory.dart';
import 'package:qenan/features/home/data/models/lessons.dart';
import 'package:qenan/features/home/data/models/localizedText.dart';

class CourseModel {
  final String id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String level_id;
  final String release_date;
  final String status;
  final String lessons_count;
  final Attachment attachments;
  final List<String> references;
  final List<CourseSubCategory> categories;
  final List<Lessons>? lessons;
  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level_id,
    required this.release_date,
    required this.status,
    required this.lessons_count,
    required this.attachments,
    required this.references,
    required this.categories,
    this.lessons,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: (json['title'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      level_id: json['level_id']?.toString() ?? '',
      release_date: json['release_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      lessons_count: json['lessons_count']?.toString() ?? '',
      attachments: Attachment.fromJson(json['attachments'] ?? {}),
      references: List<String>.from(json['references']),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((item) => CourseSubCategory.fromJson(item))
              .toList() ??
          [],
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((item) => Lessons.fromJson(item))
              .toList() ??
          [],
    );
  }
}
