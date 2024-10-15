import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/common/greeting.dart';
import 'package:qenan/features/home/data/models/homePage.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/screens/bundlesList.dart';
import 'package:qenan/features/home/presentation/screens/categoryScreen.dart';
import 'package:qenan/features/home/presentation/screens/courseScreen.dart';
import 'package:qenan/features/home/presentation/screens/gerarScreen.dart';
import 'package:qenan/features/home/presentation/screens/sectionViewScreen.dart';
import 'package:qenan/features/home/presentation/widgets/buildHorizontalList.dart';
import 'package:qenan/l10n/l10n.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final prefs = PrefService();
  String userName = "User";
  String userPhoto = "";
  bool blurVisible = false;
  int activeIndex = 0;
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};
  String selectedLanguage = "";

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    BlocProvider.of<HomePageBloc>(context).add(GetHomePageEvent());
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchInitialBookmarks();
    BlocProvider.of<HomePageBloc>(context).add(GetHomePageEvent());
    refreshController.position?.addListener(() {
      _printPosition(refreshController.position?.pixels);
    });
  }

  Future<void> fetchUserInfo() async {
    final savedName = await prefs.readFullName();
    final savedPhoto = await prefs.readPhoto();
    setState(() {
      userName = savedName;
      userPhoto = savedPhoto;
    });
  }

  Future<void> fetchInitialBookmarks() async {
    List<String> bookmarks = await prefs.checkOnMyList();
    setState(() {
      for (var bookmark in bookmarks) {
        bookmarkStates[bookmark] = true;
      }
    });
  }

  void toggleBookmark(String courseId) async {
    bool isBookmarked = bookmarkStates[courseId] ?? false;
    setState(() {
      bookmarkStates[courseId] = !isBookmarked;
    });
    if (isBookmarked) {
      await prefs.removeFromMyList(courseId);
      BlocProvider.of<FavoritesBloc>(context).add(DelFavoritesEvent(courseId));
    } else {
      await prefs.addToMyList(courseId);
      BlocProvider.of<FavoritesBloc>(context).add(PostFavoritesEvent(courseId));
    }
  }

  void _printPosition(double? position) {
    print('Scroll position: $position');
    if (position as double > 130) {
      if (!blurVisible) {
        print('Setting blurVisible to true');
        setState(() {
          blurVisible = true;
        });
      }
    } else {
      if (blurVisible) {
        print('Setting blurVisible to false');
        setState(() {
          blurVisible = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          selectedLanguage =
              state.selectedLanguage.value.toString().toLowerCase();

          return BlocConsumer<HomePageBloc, HomePageState>(
            listener: (context, state) {},
            builder: (context, state) {
              print(state);
              if (state is HomePageLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else if (state is HomePageSuccessfulState) {
                return buildInitialInput(homePage: state.homePage);
              } else if (state is HomePageFailureState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Widget buildInitialInput({required HomePage homePage}) {
    double width = MediaQuery.of(context).size.width;
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      onRefresh: onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: whiteColor,
        color: primaryColor,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = SizedBox.shrink();
          } else if (mode == LoadStatus.loading) {
            body = Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Loading...',
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
            );
          } else if (mode == LoadStatus.failed) {
            body = Text('Load Failed! Click retry!');
          } else if (mode == LoadStatus.canLoading) {
            body = Text('Release to load more');
          } else {
            body = SizedBox.shrink();
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [homeGradientColor.withOpacity(0.5), whiteColor])),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(42, 40, 24, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "images/whiteLogo.png",
                          width: 97,
                          height: 130,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text.rich(
                                textAlign: TextAlign.end,
                                TextSpan(
                                    style: TextStyle(color: whiteColor),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${getGreetingMessage(context)}\n",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      TextSpan(
                                        text: userName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ])),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(userPhoto),
                                          fit: BoxFit.cover))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     BlocProvider.of<CourseBloc>(context)
                //         .add(GetCourseEvent(homePage.popular[activeIndex].id));
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => CourseScreen(
                //               courseId: homePage.popular[activeIndex].id,
                //             )));
                //   },
                //   child: CarouselSlider.builder(
                //       itemCount: homePage.popular.length,
                //       itemBuilder: (context, index, realIndex) {
                //         final carouselItem = homePage.popular[index];
                //         print(homePage.popular.length);
                //         print(carouselItem.attachments.course_cover.toString());
                //         print(carouselItem.lessons_count);
                //         print(carouselItem.categories![0].name[0].value);
                //         print(carouselItem.title[0].value);
                //         print(carouselItem.instructors![0].name[0].value);
                //         print(carouselItem.categories![0].main_color);
                //         print(carouselItem.categories![0].ascent_color);
                //         print(carouselItem.id);
                //         return buildImage(
                //             carouselItem.attachments.course_cover.toString(),
                //             carouselItem.lessons_count,
                //             carouselItem.categories![0].name[0].value,
                //             carouselItem.title[0].value,
                //             carouselItem.instructors![0].name[0].value,
                //             carouselItem.categories![0].main_color,
                //             carouselItem.categories![0].ascent_color,
                //             carouselItem.id,
                //             bookmarkStates[homePage.popular[activeIndex].id] ==
                //                 true,
                //             index);
                //       },
                //       options: CarouselOptions(
                //           height: width < 390 ? 425 : 500,
                //           autoPlay: true,
                //           autoPlayInterval: const Duration(seconds: 5),
                //           autoPlayCurve: Curves.easeInOut,
                //           autoPlayAnimationDuration:
                //               const Duration(milliseconds: 500),
                //           enlargeCenterPage: true,
                //           enlargeFactor: 0.3,
                //           // viewportFraction: 1.0,
                //           onPageChanged: (index, reason) async {
                //             setState(() => activeIndex = index);
                //             final item = homePage.popular[index];
                //             final itemId = item.id;

                //             setState(() {
                //               bookmarkStates[itemId] = isBookmarked;
                //             });
                //           })),
                // ),
                SizedBox(
                  width: width,
                  height: width < 390 ? 425 : 500,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 11, right: 15),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: homePage.popular.length,
                      itemBuilder: (BuildContext context, int index) {
                        String courseId = homePage.popular[index].id;
                        bool isBookmarked = bookmarkStates[courseId] ?? false;

                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<CourseBloc>(context).add(
                                GetCourseEvent(homePage.popular[index].id));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CourseScreen(
                                      courseId: homePage.popular[index].id,
                                    )));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 9),
                            padding: const EdgeInsets.all(3),
                            height: width < 390 ? 420 : 496,
                            width: width < 390 ? 280 : 325,
                            decoration: BoxDecoration(
                                color: darkBlue,
                                borderRadius: BorderRadius.circular(34),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(int.parse(homePage.popular[index]
                                          .categories![0].main_color
                                          .replaceAll("#", "0xFF"))),
                                      Color(int.parse(homePage.popular[index]
                                          .categories![0].ascent_color
                                          .replaceAll("#", "0xFF")))
                                    ])),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(34),
                                      image: DecorationImage(
                                          image: NetworkImage(homePage
                                              .popular[index]
                                              .attachments
                                              .course_cover
                                              .toString()),
                                          fit: BoxFit.cover)),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(34),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              blackColor.withOpacity(0),
                                              Color(int.parse(homePage
                                                  .popular[index]
                                                  .categories![0]
                                                  .main_color
                                                  .replaceAll("#", "0xFF")))
                                            ])),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    width: 85,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(int.parse(homePage
                                                  .popular[index]
                                                  .categories![0]
                                                  .main_color
                                                  .replaceAll("#", "0xFF"))),
                                              Color(int.parse(homePage
                                                  .popular[index]
                                                  .categories![0]
                                                  .ascent_color
                                                  .replaceAll("#", "0xFF"))),
                                            ])),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFF4D4D4D),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "${homePage.popular[index].lessons_count} ${AppLocalizations.of(context)!.lessons}",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 28,
                                    bottom: 25,
                                    right: 20,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectedLanguage == 'am_amh'
                                                    ? homePage
                                                        .popular[index]
                                                        .categories![0]
                                                        .name[1]
                                                        .value
                                                    : homePage
                                                        .popular[index]
                                                        .categories![0]
                                                        .name[0]
                                                        .value,
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize:
                                                        width < 390 ? 14 : 16,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                selectedLanguage == 'am_amh'
                                                    ? homePage.popular[index]
                                                        .title[1].value
                                                    : homePage.popular[index]
                                                        .title[0].value,
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize:
                                                        width < 390 ? 22 : 24,
                                                    fontWeight:
                                                        FontWeight.w900),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                              Text(
                                                "with ${selectedLanguage == 'am_amh' ? homePage.popular[index].instructors![0].name[1].value : homePage.popular[index].instructors![0].name[0].value}",
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize:
                                                        width < 390 ? 14 : 16,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              toggleBookmark(courseId);
                                            },
                                            icon: Icon(
                                              isBookmarked
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_outline,
                                              size: width < 390 ? 30 : 40,
                                              color: whiteColor,
                                            ))
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 18, top: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => SectionViewScreen(
                          sections: homePage.for_you,
                          title: AppLocalizations.of(context)!.forYou,
                          oneLine: true,
                        ))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.forYou,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w900),
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
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildHorizontalList(
              context: context,
              sectionDetail: homePage.for_you,
              onInteraction: () {}),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 18, top: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => SectionViewScreen(
                          sections: homePage.creative,
                          title: AppLocalizations.of(context)!.continueTitle,
                          titleSecondLine:
                              AppLocalizations.of(context)!.watching,
                          oneLine: false,
                        ))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.continueTitle,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              height: 1),
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.watching,
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
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildHorizontalList(
              context: context,
              sectionDetail: homePage.creative,
              onInteraction: () {}),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 18, top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.myCourses,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
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
          ),
          const SizedBox(
            height: 10,
          ),
          buildHorizontalList(
              context: context,
              sectionDetail: homePage.creative,
              onInteraction: () {}),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 18, top: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => BundlesList())));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.courseBundles,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w900),
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
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: width,
            height: width < 390 ? 255 : 290,
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 11, bottom: 25, right: 15),
                scrollDirection: Axis.horizontal,
                itemCount: homePage.bundles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: width < 390 ? 235 : 284,
                      width: width < 390 ? 300 : 336,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            height: double.infinity,
                            width: width < 390 ? 245 : 280,
                            decoration: BoxDecoration(
                                color: bundleBgColor1,
                                borderRadius: BorderRadius.circular(34)),
                          ),
                          Container(
                            height: width < 390 ? 221 : 253,
                            width: width < 390 ? 275 : 306,
                            decoration: BoxDecoration(
                                color: bundleBgColor2,
                                borderRadius: BorderRadius.circular(34)),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Container(
                                width: double.infinity,
                                height: width < 390 ? 210 : 237,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(34),
                                    image: DecorationImage(
                                        image: NetworkImage(homePage
                                            .bundles[index]
                                            .attachments
                                            .achievement_badge
                                            .toString()),
                                        fit: BoxFit.cover)),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(34),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            blackColor.withOpacity(0),
                                            blackColor.withOpacity(0.7)
                                          ])),
                                ),
                              ),
                              Positioned(
                                top: 17,
                                right: 22,
                                child: Image.asset("images/whiteLogo.png"),
                                height: 27,
                                width: 68,
                              ),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  width: 85,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            // Color(int.parse(sections[index]
                                            //     .categories![0]
                                            //     .main_color
                                            //     .replaceAll("#", "0xFF"))),
                                            // Color(int.parse(sections[index]
                                            //     .categories![0]
                                            //     .ascent_color
                                            //     .replaceAll("#", "0xFF"))),
                                            primaryColor,
                                            darkBlue
                                          ])),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 122, 122, 122),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        "12 ${AppLocalizations.of(context)!.lessons}",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: 28,
                                  bottom: 25,
                                  right: 20,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "sections[index]",
                                              style: TextStyle(
                                                  color: Color(0xFF1AD286),
                                                  fontSize:
                                                      width < 390 ? 12 : 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              "sections[index].title[0].value",
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize:
                                                      width < 390 ? 16 : 18,
                                                  fontWeight: FontWeight.w900),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                            Text(
                                              "sections[index]",
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize:
                                                      width < 390 ? 14 : 16,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                            size: width < 390 ? 30 : 40,
                                            color: whiteColor,
                                          ))
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 18, top: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => SectionViewScreen(
                          sections: homePage.popular,
                          title: AppLocalizations.of(context)!.popular,
                          titleSecondLine:
                              AppLocalizations.of(context)!.courses,
                          oneLine: false,
                        ))));
              },
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.popularCourses,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w900),
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
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildHorizontalList(
              context: context,
              sectionDetail: homePage.popular,
              onInteraction: () {}),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 18, top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "images/gerar.png",
                  width: 120,
                  height: 67,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: primaryColor,
                )
              ],
            ),
          ),
          SizedBox(
            height: 283,
            width: width,
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 11),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  var gerar = [
                    "images/gerarContent.jpg",
                    "images/gerarContent2.jpg",
                    "images/gerarContent.jpg",
                    "images/gerarContent2.jpg"
                  ];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GerarScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                      width: 300,
                      height: 263,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          image: DecorationImage(
                              image: AssetImage(gerar[index]),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 3,
                                color: blackColor.withOpacity(0.25),
                                spreadRadius: 0)
                          ]),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 18, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.categories,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  ".",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: width,
            height: width < 390 ? 170 : 190,
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 11, right: 15),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: homePage.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<CategoryBloc>(context).add(
                          GetCategoryDetailEvent(
                              homePage.categories[index].id));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => CategoryScreen(
                              categoryId: homePage.categories[index].id))));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      height: width < 390 ? 170 : 190,
                      width: width < 390 ? 230 : 256,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(int.parse(homePage
                                  .categories[index].main_color
                                  .replaceAll("#", "0xFF"))),
                              width: 3),
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(int.parse(homePage
                                    .categories[index].main_color
                                    .replaceAll("#", "0xFF"))),
                                Color(int.parse(homePage
                                    .categories[index].ascent_color
                                    .replaceAll("#", "0xFF"))),
                              ])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 18, top: 18),
                                child: Image.asset(
                                  "images/whiteLogo.png",
                                  width: 89,
                                  height: 30,
                                ),
                              )),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 19),
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: width < 390 ? 22 : 26,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: selectedLanguage == 'am_amh'
                                            ? homePage
                                                .categories[index].name[1].value
                                                .substring(
                                                    0,
                                                    homePage
                                                            .categories[index]
                                                            .name[1]
                                                            .value
                                                            .length -
                                                        1)
                                            : homePage
                                                .categories[index].name[0].value
                                                .substring(
                                                    0,
                                                    homePage
                                                            .categories[index]
                                                            .name[0]
                                                            .value
                                                            .length -
                                                        1)),
                                    TextSpan(
                                      text: selectedLanguage == 'am_amh'
                                          ? homePage
                                              .categories[index].name[1].value
                                              .substring(homePage
                                                      .categories[index]
                                                      .name[1]
                                                      .value
                                                      .length -
                                                  1)
                                          : homePage
                                              .categories[index].name[0].value
                                              .substring(homePage
                                                      .categories[index]
                                                      .name[0]
                                                      .value
                                                      .length -
                                                  1),
                                      style: TextStyle(
                                        color: Color(int.parse(homePage
                                            .categories[index].main_color
                                            .replaceAll("#", "0xFF"))),
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(
            height: 110,
          ),
        ],
      )),
    );
  }

  Widget buildIndicator(HomePage homepage) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: homepage.popular.length,
      effect: ScrollingDotsEffect(
          dotWidth: 8,
          dotHeight: 8,
          activeDotColor: indicatorColor,
          dotColor: inactiveIndicatorColor),
    );
  }

  Widget buildImage(
    String carouselImage,
    String lessonCount,
    String categoryName,
    String title,
    String instructorName,
    String mainColor,
    String accentColor,
    String courseId,
    bool bookmarkStatus,
    int index,
  ) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 9),
      padding: const EdgeInsets.all(3),
      height: width < 390 ? 420 : 496,
      width: width < 390 ? 280 : 325,
      decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.circular(34),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(int.parse(mainColor.replaceAll("#", "0xFF"))),
                Color(int.parse(accentColor.replaceAll("#", "0xFF")))
              ])),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                image: DecorationImage(
                    image: NetworkImage(carouselImage.toString()),
                    fit: BoxFit.cover)),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        blackColor.withOpacity(0),
                        Color(int.parse(mainColor.replaceAll("#", "0xFF")))
                      ])),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(3),
              width: 85,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(int.parse(mainColor.replaceAll("#", "0xFF"))),
                        Color(int.parse(accentColor.replaceAll("#", "0xFF"))),
                      ])),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF4D4D4D),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "${lessonCount} ${AppLocalizations.of(context)!.lessons}",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 28,
              bottom: 25,
              right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: width < 390 ? 14 : 16,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: width < 390 ? 22 : 24,
                              fontWeight: FontWeight.w900),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          "with ${instructorName}",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: width < 390 ? 14 : 16,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        toggleBookmark(courseId);
                      },
                      icon: Icon(
                        bookmarkStatus
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        size: width < 390 ? 30 : 40,
                        color: whiteColor,
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
