import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signup/data/models/personalization.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:qenan/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/home/data/models/category.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/indexScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  final prefs = PrefService();
  List<String> myPreferences = [];
  List<String> selectedCategoryIds = [];

  // List<String> preferencesList = [
  //   "Cooking",
  //   "Art",
  //   "Fashion Design",
  //   "Music",
  //   "Dancing",
  //   "Coding",
  //   "Life Coaching"
  // ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadMyFeedFromPrefs();
    BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
  }

  Future<void> loadMyFeedFromPrefs() async {
    final savedPreference = await prefs.getPreferencesList();
    setState(() {
      myPreferences = savedPreference;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is CategoryLoadingState) {
            isLoading = true;
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is CategorySuccessfulState) {
            isLoading = false;
            return buildInitialInput(categoryList: state.category);
          } else if (state is CategoryFailureState) {
            isLoading = false;
            return Center(
              child: CircularProgressIndicator(
                color: darkBlue,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<Category> categoryList}) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 32, vertical: width < 390 ? 10 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.personalizeYour} \n${AppLocalizations.of(context)!.experience}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: width < 390 ? 5 : 15,
                ),
                Text(
                  AppLocalizations.of(context)!.chooseYourInterests,
                  style: TextStyle(
                      color: grayTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: width < 390 ? 15 : 40,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: width < 390 ? 10 : 20,
                        mainAxisSpacing: width < 390 ? 10 : 20),
                    itemBuilder: (context, index) {
                      final isSelected = myPreferences
                          .contains(categoryList[index].name[0].value);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              myPreferences
                                  .remove(categoryList[index].name[0].value);
                              selectedCategoryIds
                                  .remove(categoryList[index].id);
                            } else {
                              myPreferences
                                  .add(categoryList[index].name[0].value);
                              selectedCategoryIds.add(categoryList[index].id);
                              print(myPreferences.toString());
                              print(selectedCategoryIds.toString());
                            }
                          });
                        },
                        child: Container(
                          height: width < 390 ? 70 : 100,
                          width: width < 390 ? 70 : 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: isSelected
                                      ? Color(int.parse(categoryList[index]
                                              .main_color
                                              .replaceAll("#", "0xFF")))
                                          .withOpacity(0.8)
                                      : textFormBorderColor,
                                  width: isSelected ? 3 : 1),
                              borderRadius: BorderRadius.circular(20),
                              gradient: isSelected
                                  ? LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                          Color(int.parse(categoryList[index]
                                                  .main_color
                                                  .replaceAll("#", "0xFF")))
                                              .withOpacity(0.8),
                                          Color(int.parse(categoryList[index]
                                                  .ascent_color
                                                  .replaceAll("#", "0xFF")))
                                              .withOpacity(0.8),
                                        ])
                                  : null),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: isSelected
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, right: 10),
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: whiteColor,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: secondaryColor,
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, right: 10),
                                        height: 28,
                                        width: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: checkMarkBgColor,
                                        ),
                                      ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 20, right: 10),
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            "${categoryList[index].main_category.name[0].value} \n",
                                        style: TextStyle(
                                            color: isSelected
                                                ? Color(0xFFD1D1D1)
                                                : otpFieldColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300)),
                                    TextSpan(
                                        text: categoryList[index].name[0].value,
                                        style: TextStyle(
                                            color: isSelected
                                                ? whiteColor
                                                : silverColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900))
                                  ])),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 17,
            left: 17,
            right: 17,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: width,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: darkBlue,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      width < 390
                          ? "${AppLocalizations.of(context)!.selectAtLeast}\n${AppLocalizations.of(context)!.threeCategories}"
                          : AppLocalizations.of(context)!.select3Categories,
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (myPreferences.length < 3) {
                          errorFlushbar(
                              context: context,
                              message: AppLocalizations.of(context)!
                                  .pleaseSelect3Categories);
                        } else {
                          BlocProvider.of<SignupBloc>(context).add(
                              PostPersonalization(Personalization(
                                  categories: selectedCategoryIds)));
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      child: Text(
                        AppLocalizations.of(context)!.finish,
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ))
                ],
              ),
            )),
        BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            print(state);
            if (state is PersonalizationSuccessfulState) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => IndexScreen(pageIndex: 0)));
            } else if (state is PersonalizationFailureState) {
              Center(
                child: CircularProgressIndicator(
                  color: darkBlue,
                ),
              );
            }
          },
          builder: (context, state) {
            return Container();
          },
        ),
      ],
    );
  }
}
