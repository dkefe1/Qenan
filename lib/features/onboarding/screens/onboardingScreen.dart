import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signup/presentation/screens/signupScreen.dart';
import 'package:qenan/features/common/languageDropdown.dart';
import 'package:qenan/features/onboarding/widgets/onboardingScreen1.dart';
import 'package:qenan/features/onboarding/widgets/onboardingScreen2.dart';
import 'package:qenan/features/onboarding/widgets/onboardingScreen3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardinScreenState();
}

class _OnboardinScreenState extends State<OnboardingScreen> {
  final prefs = PrefService();

  final pageController = PageController();

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              if (index == 2) {
                setState(() {
                  isLastPage = true;
                });
              } else {
                setState(() {
                  isLastPage = false;
                });
              }
            },
            children: const [
              OnboardingScreenOne(),
              OnboardingScreenTwo(),
              OnboardingScreenThree()
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: const WormEffect(
                        spacing: 5,
                        radius: 100,
                        dotWidth: 14,
                        dotHeight: 14,
                        strokeWidth: 1.5,
                        activeDotColor: primaryColor,
                        dotColor: whiteColor),
                  ),
                ),
                dropdownWidget()
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 34, right: 40, bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isLastPage
                      ? SizedBox.shrink()
                      : TextButton(
                          onPressed: () {
                            pageController.jumpToPage(2);
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: width < 390 ? 16 : 18,
                                fontWeight: FontWeight.w400),
                          )),
                  IconButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      onPressed: isLastPage
                          ? () {
                              prefs.board();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen()));
                            }
                          : () {
                              pageController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeIn);
                            },
                      icon: Icon(
                        isLastPage ? Icons.check : Icons.arrow_forward_ios,
                        color: whiteColor,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
