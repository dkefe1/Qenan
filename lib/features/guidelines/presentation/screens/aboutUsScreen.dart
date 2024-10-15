import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_bloc.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_state.dart';
import 'package:qenan/features/home/data/models/localizedText.dart';
import 'package:qenan/l10n/l10n.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool titleVisible = false;
  ScrollController screenScrollController = ScrollController();
  String title = "";
  String selectedLanguage = "";

  @override
  void initState() {
    super.initState();
    screenScrollController.addListener(_printPosition);
  }

  void _printPosition() {
    print('Scroll position: ${screenScrollController.position.pixels}');
    if (screenScrollController.position.pixels > 180) {
      setState(() {
        titleVisible = true;
      });
    } else {
      setState(() {
        titleVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Container(
          child: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor:
                titleVisible ? blackColor.withOpacity(0.1) : Colors.transparent,
            toolbarHeight: height * 0.08,
            title: Text(
              titleVisible ? AppLocalizations.of(context)!.aboutUs : "",
              style: const TextStyle(
                  color: whiteColor, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 25, top: 6),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: blackColor,
                  )),
            ),
          ),
        ).asGlass(enabled: titleVisible, tintColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          selectedLanguage =
              state.selectedLanguage.value.toString().toLowerCase();

          return BlocConsumer<GuidelinesBloc, GuidelinesState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GuidelinesLoadingState) {
                return Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              } else if (state is GuidelinesSuccessfulState) {
                return buildInitialInput(aboutUs: state.guidelines[0].about);
              } else if (state is GuidelinesFailureState) {
                return Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  Widget buildInitialInput({required List<LocalizedText> aboutUs}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      controller: screenScrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.only(left: 35, right: 35, bottom: 25),
            color: headerBgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.12,
                ),
                Image.asset(
                  "images/blackLogo.png",
                  fit: BoxFit.fill,
                  width: width < 390 ? 85 : 100,
                  height: width < 390 ? 30 : 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.aboutUs,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: width < 390 ? 44 : 48,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      ".",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: width < 390 ? 44 : 48,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 15, 35, 40),
            child: Text(
              selectedLanguage == 'am_amh'
                  ? aboutUs[1].value
                  : aboutUs[0].value,
              style: TextStyle(
                  color: blackColor,
                  fontSize: width < 390 ? 14 : 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
