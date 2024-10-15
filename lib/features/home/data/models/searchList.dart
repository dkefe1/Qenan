import 'package:qenan/features/home/data/models/sections.dart';

class SearchList {
  final List<Sections> courses;
  SearchList({required this.courses});

  factory SearchList.fromJson(Map<String, dynamic> json) {
    return SearchList(
      courses: (json['courses'] as List<dynamic>?)
              ?.map((item) => Sections.fromJson(item))
              .toList() ??
          [],
    );
  }
}
