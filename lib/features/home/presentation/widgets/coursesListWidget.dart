import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/screens/courseScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class CourseListWidget extends StatefulWidget {
  const CourseListWidget({super.key});

  @override
  State<CourseListWidget> createState() => _CourseListWidgetState();
}

class _CourseListWidgetState extends State<CourseListWidget> {
  final prefs = PrefService();
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};

  @override
  void initState() {
    super.initState();
    fetchInitialBookmarks();
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        String selectedLanguage =
            state.selectedLanguage.value.toString().toLowerCase();
        print(selectedLanguage);
        return BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            print(state);
            if (state is FilterLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (state is FilterSuccessfulState) {
              var courses = state.filteredCourses.courses;
              return Column(
                children: [
                  SizedBox(
                    width: width,
                    height: width < 390 ? 320 : 385,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 11, right: 15),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: courses.length,
                        itemBuilder: (BuildContext context, int index) {
                          String courseId = courses[index].id;
                          bool isBookmarked = bookmarkStates[courseId] ?? false;
                          return GestureDetector(
                            onTap: () {
                              // onInteraction();
                              BlocProvider.of<CourseBloc>(context)
                                  .add(GetCourseEvent(courses[index].id));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CourseScreen(courseId: "")));
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
                                          borderRadius:
                                              BorderRadius.circular(34),
                                          image: DecorationImage(
                                              image: NetworkImage(courses[index]
                                                  .attachments
                                                  .course_cover
                                                  .toString()),
                                              fit: BoxFit.cover)),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(34),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(int.parse(courses[index]
                                                      .categories![0]
                                                      .ascent_color
                                                      .replaceAll(
                                                          "#", "0xFF"))),
                                                  Color(int.parse(courses[index]
                                                      .categories![0]
                                                      .main_color
                                                      .replaceAll(
                                                          "#", "0xFF"))),
                                                ])),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xFF4D4D4D),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              "${courses[index].lessons_count} ${AppLocalizations.of(context)!.lessons}",
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
                                                        ? courses[index]
                                                            .instructors![0]
                                                            .name[1]
                                                            .value
                                                        : courses[index]
                                                            .instructors![0]
                                                            .name[0]
                                                            .value,
                                                    style: TextStyle(
                                                        color: Color(int.parse(
                                                            courses[index]
                                                                .categories![0]
                                                                .main_color
                                                                .replaceAll("#",
                                                                    "0xFF"))),
                                                        fontSize: width < 390
                                                            ? 12
                                                            : 14,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  Text(
                                                    selectedLanguage == 'am_amh'
                                                        ? courses[index]
                                                            .title[1]
                                                            .value
                                                        : courses[index]
                                                            .title[0]
                                                            .value,
                                                    style: TextStyle(
                                                        color: whiteColor,
                                                        fontSize: width < 390
                                                            ? 16
                                                            : 18,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                  Text(
                                                    selectedLanguage == 'am_amh'
                                                        ? courses[index]
                                                            .categories![0]
                                                            .name[1]
                                                            .value
                                                        : courses[index]
                                                            .categories![0]
                                                            .name[0]
                                                            .value,
                                                    style: TextStyle(
                                                        color: whiteColor,
                                                        fontSize: width < 390
                                                            ? 12
                                                            : 14,
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
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else if (state is FilterFailureState) {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
