import 'package:qenan/features/home/data/models/localizedText.dart';

class Guidelines {
  final List<LocalizedText> privacy_policy;
  final List<LocalizedText> faq;
  final List<LocalizedText> terms_and_conditions;
  final List<LocalizedText> contact;
  final List<LocalizedText> about;
  Guidelines(
      {required this.privacy_policy,
      required this.faq,
      required this.terms_and_conditions,
      required this.contact,
      required this.about});

  factory Guidelines.fromJson(Map<String, dynamic> json) {
    return Guidelines(
      privacy_policy: (json['privacy_policy'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      faq: (json['faq'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      terms_and_conditions: (json['terms_and_conditions'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      contact: (json['contact'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
      about: (json['about'] as List<dynamic>?)
              ?.map((item) => LocalizedText.fromJson(item))
              .toList() ??
          [],
    );
  }
}
