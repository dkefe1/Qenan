import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/screens/bundleCourseListScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class BundlesList extends StatefulWidget {
  // final List<Sections> sections;

  const BundlesList({
    super.key,
    // required this.sections,
  });

  @override
  State<BundlesList> createState() => _BundlesListState();
}

class _BundlesListState extends State<BundlesList> {
  final prefs = PrefService();
  bool isLoading = false;
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};
  bool titleVisible = false;
  ScrollController screenScrollController = ScrollController();
  String title = "Bundles";

  @override
  void initState() {
    super.initState();
    fetchInitialBookmarks();
    screenScrollController.addListener(_printPosition);
    BlocProvider.of<BundleBloc>(context).add(GetBundlesEvent());
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
              surfaceTintColor: titleVisible
                  ? blackColor.withOpacity(0.1)
                  : Colors.transparent,
              toolbarHeight: height * 0.08,
              title: Text(
                titleVisible ? AppLocalizations.of(context)!.bundles : "",
                style: const TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
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
        ));
  }

  Widget buildInitialInput({required List<Bundles> bundles}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // List<Sections> sections = widget.sections;
    return ListView.builder(
        padding: EdgeInsets.only(left: 29, right: 29, top: height * 0.12),
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        controller: screenScrollController,
        itemCount: bundles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              index == 0
                  ? null
                  : Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BundleCourseListScreen(
                            title: bundles[index].name[0].value,
                            bundle: bundles[index],
                          )));
            },
            child: index == 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.bundles,
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: width < 390 ? 42 : 46,
                                  fontWeight: FontWeight.w900),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              ".",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: width < 390 ? 30 : 36,
                                  fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: SizedBox(
                      height: width < 390 ? 225 : 274,
                      width: width < 390 ? 320 : 366,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            height: double.infinity,
                            width: width < 390 ? 270 : 285,
                            decoration: BoxDecoration(
                                color: bundleBgColor1,
                                borderRadius: BorderRadius.circular(34)),
                          ),
                          Container(
                            height: width < 390 ? 213 : 261,
                            width: width < 390 ? 296 : 310,
                            decoration: BoxDecoration(
                                color: bundleBgColor2,
                                borderRadius: BorderRadius.circular(34)),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Container(
                                width: double.infinity,
                                height: width < 390 ? 200 : 249,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(34),
                                    image: DecorationImage(
                                        image: NetworkImage(bundles[index]
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
                                        "${bundles[index].courses_count} ${AppLocalizations.of(context)!.courses}",
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
                                              "Level not available",
                                              style: TextStyle(
                                                  color: levelTxtColor,
                                                  fontSize:
                                                      width < 390 ? 12 : 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              bundles[index].name[0].value,
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize:
                                                      width < 390 ? 16 : 18,
                                                  fontWeight: FontWeight.w900),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                            Text(
                                              "Category Not Available",
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
                  ),
          );
        });
  }
}
