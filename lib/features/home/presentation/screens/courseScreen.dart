import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/courses.dart';
import 'package:qenan/features/home/data/models/sections.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/screens/bioScreen.dart';
import 'package:qenan/features/home/presentation/screens/sectionViewScreen.dart';
import 'package:qenan/features/home/presentation/widgets/imageDialog.dart';
import 'package:qenan/features/home/presentation/widgets/lessonsList.dart';
import 'package:qenan/l10n/l10n.dart';

class CourseScreen extends StatefulWidget {
  final String courseId;
  const CourseScreen({super.key, required this.courseId});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String selectedView = "Lessons";
  final prefs = PrefService();
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};
  bool titleVisible = false;
  ScrollController screenScrollController = ScrollController();
  String title = "";

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    BlocProvider.of<CourseBloc>(context).add(GetCourseEvent(widget.courseId));
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBookmarkStatus();
    });
    screenScrollController.addListener(_printPosition);
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarkedStatus = await prefs.isOnMyList(widget.courseId);
    setState(() {
      isBookmarked = isBookmarkedStatus;
    });
  }

  Future<void> toggleBookmark(String courseId) async {
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
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  void _printPosition() {
    print('Scroll position: ${screenScrollController.position.pixels}');
    if (screenScrollController.position.pixels > 470) {
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
            title: Text(
              titleVisible ? title : "",
              style: const TextStyle(
                  color: whiteColor, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 25, top: 6),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: whiteColor,
                  )),
            ),
          ),
        ).asGlass(enabled: titleVisible, tintColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is CourseLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is CourseSuccessfulState) {
            title = state.course.course.title[0].value;
            return buildInitialInput(courseInfo: state.course);
          } else if (state is CourseFailureState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required Course courseInfo}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print("course Id " + courseInfo.course.id);
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
                    "${AppLocalizations.of(context)!.loading}...",
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
        controller: screenScrollController,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: width,
                  height: width < 390 ? height * 0.8 : height * 0.7,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(courseInfo
                              .course.attachments.course_cover
                              .toString()),
                          fit: BoxFit.cover)),
                  child: Container(
                    width: width,
                    height: width < 390 ? height * 0.8 : height * 0.7,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          blackColor.withOpacity(0),
                          Color(int.parse(courseInfo
                              .course.categories[0].main_color
                              .toString()
                              .replaceAll("#", "0xFF")))
                        ])),
                  ),
                ),
                Positioned(
                    left: 28,
                    bottom: 25,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // RichText(
                              //     text: TextSpan(
                              //         style: TextStyle(
                              //           color: whiteColor,
                              //           fontSize: width < 390 ? 16 : 18,
                              //         ),
                              //         children: [
                              //       TextSpan(
                              //         text: "Gordon ",
                              //         style:
                              //             TextStyle(fontWeight: FontWeight.w900),
                              //       ),
                              //       TextSpan(
                              //         text: "Ramsay",
                              //         style:
                              //             TextStyle(fontWeight: FontWeight.w400),
                              //       )
                              //     ])),
                              Text(
                                courseInfo.instructor[0].name[0].value,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: width < 390 ? 16 : 18,
                                    fontWeight: FontWeight.w900),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                courseInfo.course.title[0].value,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                courseInfo.course.categories[0].main_category
                                    .name[0].value,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: width < 390 ? 16 : 20,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              toggleBookmark(courseInfo.course.id);
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
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectView(
                    "Lessons",
                    courseInfo.course.categories[0].main_color,
                    courseInfo.course.categories[0].ascent_color),
                selectView(
                    "Description",
                    courseInfo.course.categories[0].main_color,
                    courseInfo.course.categories[0].ascent_color),
              ],
            ),
            selectedView == "Lessons"
                ? LessonsListWidget(
                    lessons: courseInfo.course.lessons,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(37, 25, 37, 30),
                        child: Text(
                          courseInfo.course.description[0].value,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: width < 390 ? 12 : 15,
                              fontWeight: FontWeight.w400),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45, bottom: 10),
                        child: Text(
                          AppLocalizations.of(context)!.instructors,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: width < 390 ? 18 : 20,
                              fontWeight: FontWeight.w900),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      SizedBox(
                        width: width,
                        height: 185,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(left: 11),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: courseInfo.instructor.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  BlocProvider.of<CourseBloc>(context).add(
                                      GetCourseEvent(courseInfo
                                          .course.categories[index].id));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => BioScreen(
                                          categoryName: courseInfo.course
                                              .categories[0].name[0].value,
                                          instructorInfo:
                                              courseInfo.instructor[index])));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  padding: const EdgeInsets.only(
                                    left: 17,
                                  ),
                                  width: width < 390 ? 290 : 315,
                                  height: width < 390 ? 140 : 163,
                                  decoration: BoxDecoration(
                                      color: darkBlue,
                                      borderRadius: BorderRadius.circular(29),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color(int.parse(courseInfo
                                                .instructor[index].main_color
                                                .replaceAll("#", "0xFF"))),
                                            Color(int.parse(courseInfo
                                                .instructor[index].ascent_color
                                                .replaceAll("#", "0xFF")))
                                          ])),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: width < 390 ? 90 : 117,
                                          height: width < 390 ? 90 : 117,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(courseInfo
                                                      .instructor[index]
                                                      .attachments
                                                      .instructor_photo
                                                      .toString()),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  courseInfo.instructor[index]
                                                      .name[0].value,
                                                  style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize:
                                                        width < 390 ? 18 : 20,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 40),
                                                  child: Text(
                                                    "${courseInfo.instructor[index].bio.profession[0]} | ${courseInfo.instructor[index].bio.profession[1]}",
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize:
                                                          width < 390 ? 14 : 16,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 27),
                        child: Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.reference,
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: width < 390 ? 18 : 20,
                                  fontWeight: FontWeight.w900),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              "${courseInfo.course.references.length} ${AppLocalizations.of(context)!.slides}",
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: width < 390 ? 12 : 13,
                                  fontWeight: FontWeight.w300),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: width,
                          height: height * 0.23,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(left: 11, right: 11),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: courseInfo.course.references.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  showImageDialog(context,
                                      courseInfo.course.references[index]);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  height: height * 0.23,
                                  width:
                                      width < 390 ? width * 0.55 : width * 0.65,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(courseInfo
                                              .course.references[index]),
                                          fit: BoxFit.cover)),
                                ),
                              );
                            },
                          ))
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 18, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.relatedCourses,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => SectionViewScreen(
                                  sections: courseInfo.related,
                                  title: AppLocalizations.of(context)!.related,
                                  titleSecondLine:
                                      AppLocalizations.of(context)!.courses,
                                  oneLine: false,
                                ))));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: primaryColor,
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildHorizontalList(context, courseInfo.related, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CourseScreen(
                        courseId: "",
                      )));
            }, () {}),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget selectView(String view, String gradientBegin, String gradientEnd) {
    double width = MediaQuery.of(context).size.width;
    bool isSelected = selectedView == view;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedView = view;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(int.parse(gradientEnd.replaceAll("#", "0xFF"))),
                    Color(int.parse(gradientBegin.replaceAll("#", "0xFF")))
                  ],
                )
              : null,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 10, horizontal: width < 390 ? 20 : 26),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected ? Colors.transparent : Colors.grey.withOpacity(0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              view == "Lessons"
                  ? AppLocalizations.of(context)!.lessons
                  : AppLocalizations.of(context)!.description,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontSize: width < 390 ? 18 : 20,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHorizontalList(
      BuildContext context,
      List<Sections> relatedCourses,
      VoidCallback onInteraction,
      VoidCallback onBookmark) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: width,
          height: width < 390 ? 320 : 385,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 11, right: 15),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: relatedCourses.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    onInteraction();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: width < 390 ? 315 : 377,
                      width: width < 390 ? 230 : 266,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(34),
                                image: DecorationImage(
                                    image: NetworkImage(relatedCourses[index]
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
                                        blackColor.withOpacity(0.7)
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
                                        Color(int.parse(relatedCourses[index]
                                            .categories![0]
                                            .main_color
                                            .replaceAll("#", "0xFF"))),
                                        Color(int.parse(relatedCourses[index]
                                            .categories![0]
                                            .ascent_color
                                            .replaceAll("#", "0xFF"))),
                                      ])),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF4D4D4D),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "${relatedCourses[index].lessons_count} ${AppLocalizations.of(context)!.lessons}",
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
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          relatedCourses[index]
                                              .instructors![0]
                                              .name[0]
                                              .value,
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                  relatedCourses[index]
                                                      .categories![0]
                                                      .main_color
                                                      .replaceAll(
                                                          "#", "0xFF"))),
                                              fontSize: width < 390 ? 12 : 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          relatedCourses[index].title[0].value,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: width < 390 ? 16 : 18,
                                              fontWeight: FontWeight.w900),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "${relatedCourses[index].categories![0].name[0].value}",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: width < 390 ? 12 : 14,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        toggleBookmark(
                                            relatedCourses[index].id);
                                      },
                                      icon: Icon(
                                        bookmarkStates[
                                                    relatedCourses[index].id] ==
                                                true
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
                  ),
                );
              }),
        ),
      ],
    );
  }
}
