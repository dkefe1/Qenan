import 'package:qenan/features/home/data/models/courseModel.dart';
import 'package:qenan/features/home/data/models/instructor.dart';
import 'package:qenan/features/home/data/models/sections.dart';

class Course {
  final CourseModel course;
  final List<Instructor> instructor;
  final List<Sections> related;
  Course(
      {required this.course, required this.instructor, required this.related});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      course: CourseModel.fromJson(json['course'] ?? {}),
      instructor: (json['instructors'] as List<dynamic>?)
              ?.map((item) => Instructor.fromJson(item))
              .toList() ??
          [],
      related: (json['related'] as List<dynamic>?)
              ?.map((item) => Sections.fromJson(item))
              .toList() ??
          [],
    );
  }
}
