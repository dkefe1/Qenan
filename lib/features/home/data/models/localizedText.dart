class LocalizedText {
  final String lang;
  final String value;
  LocalizedText({required this.lang, required this.value});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
        lang: json['lang']?.toString() ?? '',
        value: json['value']?.toString() ?? '');
  }
}
