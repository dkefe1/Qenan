import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final prefs = PrefService();
  String userName = "User";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    BlocProvider.of<BundleBloc>(context).add(GetBundlesEvent());
  }

  Future<void> fetchUserInfo() async {
    final savedName = await prefs.readFullName();
    setState(() {
      userName = savedName;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: height * 0.08,
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
      extendBodyBehindAppBar: true,
      body: BlocConsumer<BundleBloc, BundleState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetBundlesLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is GetBundlesSuccessfulState) {
            return buildInitialInput(bundles: state.bundles);
          } else if (state is GetBundlesFailureState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<Bundles> bundles}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Center(
              child: Image.asset(
                "images/blackQenanAmh.png",
                fit: BoxFit.cover,
                width: width < 390 ? 200 : 230,
                height: width < 390 ? 95 : 110,
              ),
            ),
            Text(
              "${userName}'s",
              style: TextStyle(
                  color: blackColor,
                  fontSize: width < 390 ? 22 : 24,
                  fontWeight: FontWeight.w300,
                  height: 1.4),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Achievements",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: width < 390 ? 32 : 34,
                      fontWeight: FontWeight.w900,
                      height: 1),
                ),
                Text(
                  ".",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: width < 390 ? 32 : 34,
                      fontWeight: FontWeight.w900,
                      height: 1),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Divider(
              color: thirdDividerColor,
              height: 2,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Creative Course",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: width < 390 ? 22 : 24,
                      fontWeight: FontWeight.w900,
                      height: 1),
                ),
                Text(
                  ".",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: width < 390 ? 22 : 24,
                      fontWeight: FontWeight.w900,
                      height: 1.2),
                ),
              ],
            ),
            Text(
              "Beginner Level",
              style: TextStyle(
                color: primaryColor,
                fontSize: width < 390 ? 13 : 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 12),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 23,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 22),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 230,
                      width: 170,
                      decoration: BoxDecoration(
                          color: checkMarkBgColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(bundles[index]
                                        .attachments
                                        .achievement_badge
                                        .toString()),
                                    fit: BoxFit.cover),
                                boxShadow: [
                                  BoxShadow(
                                      color: blackColor.withOpacity(0.15),
                                      offset: Offset(0, 25),
                                      spreadRadius: 0,
                                      blurRadius: 30)
                                ]),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 35,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Completed",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1),
                ),
                Row(
                  children: [
                    Text(
                      "Course",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          height: 1),
                    ),
                    Text(
                      ".",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          height: 1),
                    ),
                  ],
                ),
              ],
            ),
            GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 12),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 23,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: 180,
                          width: 170,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/temp/badge.jpg"),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        Text(
                          "3 Courses",
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
