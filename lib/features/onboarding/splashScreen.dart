import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:qenan/features/home/presentation/screens/mainTabs/indexScreen.dart';
import 'package:qenan/features/onboarding/screens/onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final prefs = PrefService();
  Future navigate() async {
    await Future.delayed(Duration(seconds: 2));
    prefs.getBoarded().then((value) {
      if (value == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OnboardingScreen()));
      } else {
        prefs.readLogin().then((value) {
          if (value == null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SigninScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => IndexScreen(
                      pageIndex: 0,
                    )));
          }
        });
      }
    });
  }

  @override
  void initState() {
    navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: darkBlue,
          image: DecorationImage(
              image: AssetImage("images/splashBg.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Image.asset(
            "images/whiteLogo.png",
            width: width < 390 ? 230 : 276,
            height: width < 390 ? 150 : 200,
          ),
        ),
      ),
    );
  }
}
