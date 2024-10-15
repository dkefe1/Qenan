import 'package:qenan/features/home/data/models/attachments.dart';
import 'package:qenan/features/home/data/models/courseSubcategory.dart';
import 'package:qenan/features/home/data/models/instructor.dart';
import 'package:qenan/features/home/data/models/localizedText.dart';
import 'package:qenan/features/home/data/models/pivot.dart';

class Sections {
  final String id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String level_id;
  final String release_date;
  final String lessons_count;
  final Attachment attachments;
  final List<String> references;
  final Pivot? pivot;
  final List<CourseSubCategory>? categories;
  final List<Instructor>? instructors;
  Sections({
    required this.id,
    required this.title,
    required this.description,
    required this.level_id,
    required this.release_date,
    required this.attachments,
    required this.references,
    required this.lessons_count,
    this.pivot,
    this.categories,
    this.instructors,
  });

  factory Sections.fromJson(Map<String, dynamic> json) {
    return Sections(
      id: json['id']?.toString() ?? '',
      title: (json['title'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      release_date: json['release_date']?.toString() ?? '',
      level_id: json['level_id']?.toString() ?? '',
      attachments: Attachment.fromJson(json['attachments'] ?? {}),
      references: List<String>.from(json['references']),
      lessons_count: json['lessons_count']?.toString() ?? '',
      pivot: Pivot.fromJson(json['pivot'] ?? {}),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((item) => CourseSubCategory.fromJson(item))
              .toList() ??
          [],
      instructors: (json['instructors'] as List<dynamic>?)
              ?.map((item) => Instructor.fromJson(item))
              .toList() ??
          [],
    );
  }
}
