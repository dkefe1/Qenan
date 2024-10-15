part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final Language selectedLanguage;
  const LanguageState({Language? language})
      : selectedLanguage = language ?? Language.english;
  @override
  List<Object?> get props => [selectedLanguage];

  LanguageState copyWith({Language? selectedLanguage}) {
    return LanguageState(
      language: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
