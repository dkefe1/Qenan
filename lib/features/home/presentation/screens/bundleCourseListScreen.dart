import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';

class BundleCourseListScreen extends StatefulWidget {
  final Bundles bundle;
  final String title;

  const BundleCourseListScreen({
    super.key,
    required this.bundle,
    required this.title,
  });

  @override
  State<BundleCourseListScreen> createState() => _BundleCourseListScreenState();
}

class _BundleCourseListScreenState extends State<BundleCourseListScreen> {
  final prefs = PrefService();
  bool isLoading = false;
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};
  bool titleVisible = false;
  ScrollController screenScrollController = ScrollController();
  String title = "";

  @override
  void initState() {
    super.initState();
    title = widget.title;
    fetchInitialBookmarks();
    screenScrollController.addListener(_printPosition);
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

  void _printPosition() {
    print('Scroll position: ${screenScrollController.position.pixels}');
    if (screenScrollController.position.pixels > 130) {
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
                    color: titleVisible ? whiteColor : blackColor,
                  )),
            ),
          ),
        ).asGlass(enabled: titleVisible, tintColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: buildInitialInput(),
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // List<Sections> sections = widget.sections;
    return ListView.builder(
        padding: EdgeInsets.only(left: 29, right: 29, top: height * 0.12),
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        controller: screenScrollController,
        itemCount: widget.bundle.courses.length,
        itemBuilder: (BuildContext context, int index) {
          // String courseId = sections[index].id;
          // bool isBookmarked = bookmarkStates[courseId] ?? false;
          return GestureDetector(
            onTap: () {
              // BlocProvider.of<CourseBloc>(context)
              //     .add(GetCourseEvent(courseId));
              // index == 0
              //     ? null
              //     : Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => CourseScreen(courseId: courseId)));
            },
            child: index == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/blackLogo.png",
                        width: width < 390 ? 69 : 89,
                        height: width < 390 ? 20 : 30,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                              color: blackColor,
                              fontSize: width < 390 ? 32 : 36,
                              fontWeight: FontWeight.w900,
                              height: 1.2),
                          children: [
                            // TextSpan(
                            //     text: "Production for Beginners".substring(0,
                            //         "Production for Beginners".length - 1)),
                            TextSpan(text: widget.title),
                            TextSpan(
                              text: ".",
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.bundle.description[0].value,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Achievement Progress",
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: SizedBox(
                      height: width < 390 ? 420 : 496,
                      width: width < 390 ? 280 : 325,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(34),
                                image: DecorationImage(
                                    image: NetworkImage(widget.bundle
                                        .courses[index].attachments.course_cover
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
                                        // Color(int.parse(sections[index]
                                        //     .categories![0]
                                        //     .main_color
                                        //     .replaceAll("#", "0xFF"))),
                                        // Color(int.parse(sections[index]
                                        //     .categories![0]
                                        //     .ascent_color
                                        //     .replaceAll("#", "0xFF"))),
                                        primaryColor, darkBlue
                                      ])),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 122, 122, 122),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "widget.bundle.courses[index] Lessons",
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
                                          "widget.bundle.courses[index].instructors![0].name[0].value",
                                          style: TextStyle(
                                              color: Color(0xFF1AD286),
                                              fontSize: width < 390 ? 12 : 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "widget.bundle.courses[index].title[0].value",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: width < 390 ? 16 : 18,
                                              fontWeight: FontWeight.w900),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          widget.bundle.courses[index]
                                              .categories![0].name[0].value,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: width < 390 ? 12 : 14,
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
                    ),
                  ),
          );
        });
  }
}
