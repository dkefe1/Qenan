import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/common/models/language.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/indexScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final prefs = PrefService();
  int selectedIndex = -1; // Initialize selectedIndex

  void fetchSelectedIndex() async {
    int? index = await prefs.readSelectedLanguageIndex();
    if (index != null) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  // List<String> languages = ["Eng", "Amh", "Oro", "Tig"];

  @override
  void initState() {
    super.initState();
    fetchSelectedIndex();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => IndexScreen(pageIndex: 3)));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: blackColor,
              size: 18,
            )),
        toolbarHeight: height < 850 ? 70 : 90,
        title: Text(
          AppLocalizations.of(context)!.languages,
          style: TextStyle(
              color: blackColor, fontSize: 26, fontWeight: FontWeight.w900),
        ),
      ),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        buildWhen: (previous, current) =>
            previous.selectedLanguage != current.selectedLanguage,
        builder: (context, state) {
          return ListView.builder(
              itemCount: Language.values.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: state.selectedLanguage == Language.values[index]
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: primaryColor,
                        )
                      : SizedBox.shrink(),
                  title: Text(
                    Language.values[index].text,
                    style: TextStyle(color: blackColor, fontSize: 16),
                  ),
                  onTap: () {
                    context.read<LanguageBloc>().add(ChangeAppLanguage(
                        selectedLanguage: Language.values[index]));
                    // print(await prefs.readLanguage());
                    // await prefs.storeLanguage(language[index]);
                    // await prefs.storeSelectedLanguageIndex(index);
                    // print(await prefs.readLanguage());
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              });
        },
      ),
    );
  }
}
