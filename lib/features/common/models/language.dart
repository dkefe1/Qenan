import 'dart:ui';

enum Language {
  english(
    Locale('en', 'US'),
    'English',
  ),
  amharic(
    Locale('am', 'Amh'),
    'አማርኛ',
  );

  const Language(this.value, this.text);

  final Locale value;
  final String text;
}
