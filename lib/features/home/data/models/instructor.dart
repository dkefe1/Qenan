import 'package:qenan/features/home/data/models/attachments.dart';
import 'package:qenan/features/home/data/models/bio.dart';
import 'package:qenan/features/home/data/models/localizedText.dart';
import 'package:qenan/features/home/data/models/pivot.dart';
import 'package:qenan/features/home/data/models/sections.dart';
import 'package:qenan/features/home/data/models/socials.dart';

class Instructor {
  final String id;
  final List<LocalizedText> name;
  final List<LocalizedText> description;
  final Bio bio;
  final Socials socials;
  final String main_color;
  final String ascent_color;
  final Attachment attachments;
  final Pivot? pivot;
  final List<Sections> courses;

  Instructor({
    required this.id,
    required this.name,
    required this.description,
    required this.bio,
    required this.socials,
    required this.main_color,
    required this.ascent_color,
    required this.attachments,
    this.pivot,
    required this.courses,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
        id: json['id']?.toString() ?? '',
        name: (json['name'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        description: (json['description'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            [],
        bio: Bio.fromJson(json['bio'] ?? {}),
        socials: Socials.fromJson(json['socials'] ?? {}),
        main_color: json['main_color']?.toString() ?? '',
        ascent_color: json['ascent_color']?.toString() ?? '',
        attachments: Attachment.fromJson(json['attachments'] ?? {}),
        pivot: Pivot.fromJson(json['pivot'] ?? {}),
        courses: (json['courses'] as List<dynamic>?)
                ?.map((item) => Sections.fromJson(item))
                .toList() ??
            []);
  }
}
