class Pivot {
  final String category_id;
  final String course_id;
  Pivot({required this.category_id, required this.course_id});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      category_id: json['category_id']?.toString() ?? '',
      course_id: json['course_id']?.toString() ?? '',
    );
  }
}
