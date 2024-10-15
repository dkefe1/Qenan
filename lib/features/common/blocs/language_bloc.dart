import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qenan/features/common/models/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState()) {
    //Change Language Event
    on<ChangeAppLanguage>(onChangeLanguage);

    //Get Language Event
    on<GetLanguage>(onGetLanguage);
  }
  onChangeLanguage(ChangeAppLanguage event, Emitter<LanguageState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(
        languagePrefsKey, event.selectedLanguage.value.languageCode);
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }

  onGetLanguage(GetLanguage event, Emitter<LanguageState> emit) async {
    final prefs = await SharedPreferences.getInstance();

    final selectedLang = prefs.getString(languagePrefsKey);

    emit(state.copyWith(
      //If its not null
      selectedLanguage: selectedLang != null
          ? Language.values
              .where((element) => element.value.languageCode == selectedLang)
              .first

          //Its null, so we set english as default value for application language
          : Language.english,
    ));
  }
}

const languagePrefsKey = 'languagePrefs';
