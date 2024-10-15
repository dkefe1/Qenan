import 'package:qenan/features/home/data/models/attachments.dart';
import 'package:qenan/features/home/data/models/localizedText.dart';

class Lessons {
  final String id;
  final String course_id;
  final List<LocalizedText> title;
  final List<LocalizedText> description;
  final String lesson_number;
  final String release_date;
  final String duration;
  final String status;
  final Attachment attachments;
  Lessons({
    required this.id,
    required this.course_id,
    required this.title,
    required this.description,
    required this.lesson_number,
    required this.release_date,
    required this.duration,
    required this.status,
    required this.attachments,
  });
  factory Lessons.fromJson(Map<String, dynamic> json) {
    return Lessons(
      id: json['id']?.toString() ?? '',
      course_id: json['course_id']?.toString() ?? '',
      title: (json['title'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      description: (json['description'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      lesson_number: json['lesson_number']?.toString() ?? '',
      release_date: json['release_date']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      attachments: Attachment.fromJson(json['attachments'] ?? {}),
    );
  }
}
