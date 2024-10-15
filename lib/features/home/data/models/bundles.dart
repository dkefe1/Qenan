import 'package:qenan/features/home/data/models/attachments.dart';
import 'package:qenan/features/home/data/models/localizedText.dart';
import 'package:qenan/features/home/data/models/sections.dart';

class Bundles {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final String svg;
  final String courses_count;
  final Attachment attachments;
  final List<Sections> courses;
  Bundles(
      {required this.id,
      required this.name,
      required this.description,
      required this.svg,
      required this.courses_count,
      required this.attachments,
      required this.courses});

  factory Bundles.fromJson(Map<String, dynamic> json) {
    return Bundles(
      id: json['id']?.toString() ?? '',
      name: (json['name'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      svg: json['svg']?.toString() ?? '',
      courses_count: json['courses_count']?.toString() ?? '',
      attachments: Attachment.fromJson(json['attachments'] ?? {}),
      courses: (json['courses'] as List<dynamic>?)
              ?.map((item) => Sections.fromJson(item))
              .toList() ??
          [],
    );
  }
}
