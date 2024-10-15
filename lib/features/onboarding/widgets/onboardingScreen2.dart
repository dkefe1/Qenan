import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';

class OnboardingScreenTwo extends StatelessWidget {
  const OnboardingScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/onboard2.jpg"), fit: BoxFit.cover)),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [blackColor, blackColor.withOpacity(0)])),
          child: Container(
            padding: const EdgeInsets.only(right: 34),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [
                  blackColor.withOpacity(0.1),
                  blackColor.withOpacity(0)
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "images/whiteLogo.png",
                  width: 135,
                  height: 65,
                ),
                Text(
                  "DISCOVER YOUR",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: width < 390 ? 60 : 64,
                      fontWeight: FontWeight.w900,
                      height: 1),
                  textAlign: TextAlign.end,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "PASSION",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: width < 390 ? 60 : 64,
                          fontWeight: FontWeight.w900,
                          height: 1),
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      ".",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: width < 390 ? 60 : 64,
                          fontWeight: FontWeight.w900,
                          height: 1),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 110,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
