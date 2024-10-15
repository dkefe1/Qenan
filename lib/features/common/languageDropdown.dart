import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/common/models/language.dart';

class dropdownWidget extends StatefulWidget {
  const dropdownWidget({super.key});

  @override
  State<dropdownWidget> createState() => _dropdownWidgetState();
}

class _dropdownWidgetState extends State<dropdownWidget> {
  String dropdownValue = "Eng";
  List<String> languagesList = ["Eng", "Amh"];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      buildWhen: (previous, current) =>
          previous.selectedLanguage != current.selectedLanguage,
      builder: (context, state) {
        dropdownValue =
            state.selectedLanguage.value.languageCode == "am" ? "Amh" : "Eng";
        return Container(
          width: 80,
          margin: const EdgeInsets.only(right: 16.0, top: 40),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: whiteColor)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value:
                    state.selectedLanguage.value.languageCode.toString() == "am"
                        ? languagesList[1]
                        : languagesList[0],
                isExpanded: true,
                hint: Text(
                  'Select Language',
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                items: languagesList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        if (value == dropdownValue)
                          Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 20,
                          )
                      ],
                    ),
                  );
                }).toList(),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: whiteColor,
                  size: 30,
                ),
                dropdownColor: darkBlue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    context.read<LanguageBloc>().add(ChangeAppLanguage(
                        selectedLanguage: newValue == "Amh"
                            ? Language.amharic
                            : Language.english));
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return languagesList.map((String value) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dropdownValue,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  }).toList();
                }),
          ),
        );
      },
    );
  }
}
