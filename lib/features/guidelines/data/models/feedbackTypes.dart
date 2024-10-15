import 'package:qenan/features/home/data/models/localizedText.dart';

class FeedbackTypes {
  final int id;
  final List<LocalizedText> title;
  FeedbackTypes({
    required this.id,
    required this.title,
  });

  factory FeedbackTypes.fromJson(Map<String, dynamic> json) {
    return FeedbackTypes(
        id: json['id'],
        title: (json['title'] as List<dynamic>?)
                ?.map((item) => LocalizedText.fromJson(item))
                .toList() ??
            []);
  }
}
