import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/categoryDetail.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/screens/courseScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  const CategoryScreen({super.key, required this.categoryId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final prefs = PrefService();
  bool isLoading = false;
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};
  bool titleVisible = false;
  ScrollController screenScrollController = ScrollController();
  String title = "";

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    BlocProvider.of<CategoryBloc>(context)
        .add(GetCategoryDetailEvent(widget.categoryId));
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
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
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: whiteColor,
                  )),
            ),
          ),
        ).asGlass(enabled: titleVisible, tintColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is CategoryDetailLoadingState) {
            isLoading = true;
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is CategoryDetailSuccessfulState) {
            title = state.categoryDetail.name[0].value;
            return buildInitialInput(category: state.categoryDetail);
          } else if (state is CategoryDetailFailureState) {
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

  Widget buildInitialInput({required CategoryDetail category}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                    '${AppLocalizations.of(context)!.loading}...',
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
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(int.parse(category.main_color.replaceAll("#", "0xFF")))
                      .withOpacity(0.6),
                  whiteColor,
                ])),
          ),
          ListView.builder(
              padding: EdgeInsets.only(left: 29, right: 29, top: height * 0.12),
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              controller: screenScrollController,
              itemCount: category.courses.length,
              itemBuilder: (BuildContext context, int index) {
                String courseId = category.courses[index].id;
                bool isBookmarked = bookmarkStates[courseId] ?? false;
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<CourseBloc>(context)
                        .add(GetCourseEvent(category.courses[index].id));
                    index == 0
                        ? null
                        : Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CourseScreen(
                                courseId: category.courses[index].id)));
                  },
                  child: index == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Image.asset(
                                "images/whiteLogo.png",
                                width: width < 390 ? 69 : 89,
                                height: width < 390 ? 20 : 30,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(int.parse(category
                                          .ascent_color
                                          .replaceAll("#", "0xFF"))),
                                      width: 4),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: width < 390 ? 30 : 36,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: category.name[0].value.substring(
                                            0,
                                            category.name[0].value.length - 1)),
                                    TextSpan(
                                      text: category.name[0].value.substring(
                                          category.name[0].value.length - 1),
                                      style: TextStyle(
                                        color: Color(int.parse(category
                                            .main_color
                                            .replaceAll("#", "0xFF"))),
                                      ),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            )
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
                                          image: AssetImage(
                                              "images/temp/course.jpg"),
                                          fit: BoxFit.fill)),
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
                                              Color(int.parse(category
                                                  .main_color
                                                  .replaceAll("#", "0xFF"))),
                                              Color(int.parse(category
                                                  .ascent_color
                                                  .replaceAll("#", "0xFF"))),
                                            ])),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 122, 122, 122),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "${category.courses.length} ${AppLocalizations.of(context)!.lessons}",
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                category
                                                    .courses[index]
                                                    .instructors![0]
                                                    .name[0]
                                                    .value,
                                                style: TextStyle(
                                                    color: Color(0xFF1AD286),
                                                    fontSize:
                                                        width < 390 ? 12 : 14,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                category.courses[index].title[0]
                                                    .value,
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize:
                                                        width < 390 ? 16 : 18,
                                                    fontWeight:
                                                        FontWeight.w900),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                              Text(
                                                category
                                                    .courses[index]
                                                    .categories![0]
                                                    .name[0]
                                                    .value,
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize:
                                                        width < 390 ? 12 : 14,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              toggleBookmark(
                                                  category.courses[index].id);
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
        ],
      ),
    );
  }
}
