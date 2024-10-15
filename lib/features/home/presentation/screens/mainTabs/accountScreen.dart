import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_bloc.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_event.dart';
import 'package:qenan/features/guidelines/presentation/screens/aboutUsScreen.dart';
import 'package:qenan/features/guidelines/presentation/screens/contactSupport.dart';
import 'package:qenan/features/guidelines/presentation/screens/feedbackScreen.dart';
import 'package:qenan/features/guidelines/presentation/screens/privacyPolicyScreen.dart';
import 'package:qenan/features/guidelines/presentation/screens/termsScreen.dart';
import 'package:qenan/features/home/presentation/screens/achievementScreen.dart';
import 'package:qenan/features/home/presentation/screens/editProfileScreen.dart';
import 'package:qenan/features/home/presentation/screens/languageScreen.dart';
import 'package:qenan/features/home/presentation/screens/logoutDialog.dart';
import 'package:qenan/l10n/l10n.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final prefs = PrefService();
  String name = "User";
  String userPhoto = "";
  String userName = "user";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final savedName = await prefs.readFullName();
    final savedPhoto = await prefs.readPhoto();
    final savedUserName = await prefs.readUserName();
    setState(() {
      name = savedName;
      userPhoto = savedPhoto;
      userName = savedUserName;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: 25, right: 25, top: height * 0.06, bottom: 43),
              padding: const EdgeInsets.only(right: 14, top: 20),
              width: width,
              height: 290,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage("images/accountBg.png"),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 21),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFF00FFA3), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Beginner",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Image.asset(
                        "images/whiteQenanAmh.png",
                        fit: BoxFit.cover,
                        width: 100,
                        height: 45,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width < 390 ? 20 : 28, bottom: 33),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: width < 390 ? 100 : 110,
                          height: width < 390 ? 100 : 110,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(userPhoto),
                                  fit: BoxFit.cover),
                              border: Border.all(color: borderColor, width: 4),
                              boxShadow: [
                                BoxShadow(
                                    color: borderColor,
                                    blurRadius: 55,
                                    spreadRadius: 0,
                                    offset: Offset(0, 0))
                              ]),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: width < 390 ? 22 : 24,
                                    fontWeight: FontWeight.w900),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                "@${userName}",
                                style: TextStyle(
                                    color: userNameColor,
                                    fontSize: width < 390 ? 18 : 20,
                                    fontWeight: FontWeight.w300),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 28, bottom: 33),
                  //   child: Stack(
                  //     children: [
                  //       ,
                  //       Positioned(
                  //           top: 30,
                  //           child: )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.accountSetting,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => EditProfileScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text.rich(TextSpan(
                                style: TextStyle(color: blackColor),
                                children: [
                                  TextSpan(
                                      text:
                                          "${AppLocalizations.of(context)!.yourProfile}\n",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .editAndViewProfileInfo,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300))
                                ])),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AchievementScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text.rich(TextSpan(
                                style: TextStyle(color: blackColor),
                                children: [
                                  TextSpan(
                                      text:
                                          "${AppLocalizations.of(context)!.achievements}\n",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .badgesCompletedCourses,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300))
                                ])),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LanguageScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(AppLocalizations.of(context)!.language,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BlocBuilder<LanguageBloc, LanguageState>(
                                builder: (context, state) {
                                  return Text(state.selectedLanguage.text,
                                      style: TextStyle(
                                          color: secondaryDurationColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300));
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: primaryColor,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    AppLocalizations.of(context)!.getInTouch,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<GuidelinesBloc>(context)
                            .add(GetGuidelinesEvent());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ContactSupportScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                AppLocalizations.of(context)!.contactSupport,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FeedbackScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(AppLocalizations.of(context)!.feedback,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    AppLocalizations.of(context)!.about,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<GuidelinesBloc>(context)
                            .add(GetGuidelinesEvent());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutUsScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                AppLocalizations.of(context)!.aboutQenan,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<GuidelinesBloc>(context)
                            .add(GetGuidelinesEvent());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PrivacyPolicyScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .privacyPolicyAbout,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<GuidelinesBloc>(context)
                            .add(GetGuidelinesEvent());
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TermsAndConditionScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .termsAndConditionsAbout,
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70, bottom: 14),
                    child: GestureDetector(
                      onTap: () {
                        print("Wedet wedet!");

                        showDialog(
                            context: context,
                            barrierColor: blackColor.withOpacity(0.3),
                            builder: (context) {
                              return LogoutDialog();
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(AppLocalizations.of(context)!.logOut,
                                style: TextStyle(
                                    color: logoutColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const Icon(
                            Icons.logout,
                            color: logoutColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: thirdDividerColor,
                    height: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 110,
            ),
          ],
        ),
      ),
    );
  }
}
