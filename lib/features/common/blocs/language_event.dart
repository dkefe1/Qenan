part of 'language_bloc.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();
  @override
  List<Object> get props => [];
}

class ChangeAppLanguage extends LanguageEvent {
  final Language selectedLanguage;
  const ChangeAppLanguage({required this.selectedLanguage});

  @override
  List<Object> get props => [selectedLanguage];
}

class GetLanguage extends LanguageEvent {}
