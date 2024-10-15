class Attachment {
  final String? shows;
  final String? course_cover;
  final String? course_thumbnail;
  final String? lesson;
  final String? user_photo;
  final String? instructor_photo;
  final String? lesson_thumbnail;
  final String? achievement_badge;

  Attachment({
    this.shows,
    this.course_cover,
    this.course_thumbnail,
    this.lesson,
    this.user_photo,
    this.instructor_photo,
    this.lesson_thumbnail,
    this.achievement_badge,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      shows: json['shows']?.toString() ?? '',
      course_cover: json['course_cover']?.toString() ?? '',
      course_thumbnail: json['course_thumbnail']?.toString() ?? '',
      lesson: json['lesson']?.toString() ?? '',
      user_photo: json['user_photo']?.toString() ?? '',
      instructor_photo: json['instructor_photo']?.toString() ?? '',
      lesson_thumbnail: json['lesson_thumbnail']?.toString() ?? '',
      achievement_badge: json['achievement_badge']?.toString() ?? '',
    );
  }
}
