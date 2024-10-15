import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:qenan/core/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/instructor.dart';
import 'package:qenan/features/home/data/models/sections.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/screens/courseScreen.dart';
import 'package:qenan/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class BioScreen extends StatefulWidget {
  final String categoryName;
  final Instructor instructorInfo;
  const BioScreen(
      {super.key, required this.categoryName, required this.instructorInfo});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final prefs = PrefService();
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};
  bool titleVisible = false;
  ScrollController screenScrollController = ScrollController();
  String title = "";

  int getCurrentYear() {
    return DateTime.now().year;
  }

  int currentYear = 2024;
  @override
  void initState() {
    super.initState();
    currentYear = getCurrentYear();
    fetchInitialBookmarks();
    title = widget.instructorInfo.name[0].value;
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

  void _launchURL(Uri uri, bool inApp) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inApp) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
        } else {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
        controller: screenScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 29, right: 29, top: height * 0.08, bottom: 20),
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(int.parse(widget.instructorInfo.main_color
                            .replaceAll("#", "0xFF")))
                        .withOpacity(0.6),
                    whiteColor
                  ])),
              child: Container(
                width: 372,
                height: 500,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(int.parse(widget.instructorInfo.ascent_color
                              .replaceAll("#", "0xFF"))),
                          Color(int.parse(widget.instructorInfo.main_color
                              .replaceAll("#", "0xFF")))
                        ])),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      image: DecorationImage(
                          image: NetworkImage(widget
                              .instructorInfo.attachments.instructor_photo
                              .toString()),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              blackColor.withOpacity(0),
                              Color(0xFF01079A)
                            ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.instructorInfo.name[0].value,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: width < 390 ? 30 : 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.categoryName,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: width < 390 ? 14 : 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.biography,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: width < 390 ? 18 : 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    widget.instructorInfo.description[0].value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: width < 390 ? 14 : 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Divider(
                      color: dividerColor,
                      height: 2,
                    ),
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.ye}${currentYear - int.parse(widget.instructorInfo.bio.experience_since)} ${AppLocalizations.of(context)!.yearsOfExperience}",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Divider(
                      color: dividerColor,
                      height: 2,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.profession,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "${widget.instructorInfo.bio.profession[0]} | ${widget.instructorInfo.bio.profession[1]}",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Divider(
                      color: dividerColor,
                      height: 2,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.industry,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "${widget.instructorInfo.bio.industry[0]} | ${widget.instructorInfo.bio.industry[1]}",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Divider(
                      color: dividerColor,
                      height: 2,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.socialMediaLinks,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildSocialButton(
                            socialLink: widget.instructorInfo.socials.instagram,
                            icons: FontAwesomeIcons.instagram),
                        buildSocialButton(
                            socialLink: widget.instructorInfo.socials.tiktok,
                            icons: FontAwesomeIcons.tiktok),
                        buildSocialButton(
                            socialLink: widget.instructorInfo.socials.linkedin,
                            icons: FontAwesomeIcons.linkedin),
                        buildSocialButton(
                            socialLink: widget.instructorInfo.socials.facebook,
                            icons: FontAwesomeIcons.facebook),
                        buildSocialButton(
                            socialLink: widget.instructorInfo.socials.twitter,
                            icons: FontAwesomeIcons.twitter),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 18, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.coursesBy,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    widget.instructorInfo.name[0].value,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildHorizontalList(context, widget.instructorInfo.courses,
                widget.instructorInfo.name[0].value, () {}, () {}),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSocialButton(
      {required String? socialLink, required IconData icons}) {
    return socialLink == ""
        ? SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: checkMarkBgColor,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: IconButton(
                onPressed: () {
                  _launchURL(Uri.parse(socialLink.toString()), false);
                },
                color: blackColor,
                icon: FaIcon(
                  icons,
                  size: 35,
                ),
              ),
            ),
          );
  }

  Widget buildHorizontalList(
      BuildContext context,
      List<Sections> sectionDetail,
      String instructorName,
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
              itemCount: sectionDetail.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    onInteraction();
                    BlocProvider.of<CourseBloc>(context)
                        .add(GetCourseEvent(sectionDetail[index].id));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CourseScreen(courseId: sectionDetail[index].id)));
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
                                    image: NetworkImage(sectionDetail[index]
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
                                        Color(int.parse(sectionDetail[index]
                                            .categories![0]
                                            .ascent_color
                                            .replaceAll("#", "0xFF"))),
                                        Color(int.parse(sectionDetail[index]
                                            .categories![0]
                                            .main_color
                                            .replaceAll("#", "0xFF"))),
                                      ])),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF4D4D4D),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "${sectionDetail[index].lessons_count} ${AppLocalizations.of(context)!.lessons}",
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
                                          instructorName,
                                          style: TextStyle(
                                              color: Color(int.parse(
                                                  sectionDetail[index]
                                                      .categories![0]
                                                      .main_color
                                                      .replaceAll(
                                                          "#", "0xFF"))),
                                              fontSize: width < 390 ? 12 : 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          sectionDetail[index].title[0].value,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: width < 390 ? 16 : 18,
                                              fontWeight: FontWeight.w900),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "${sectionDetail[index].categories![0].name[0].value}}",
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
                                        toggleBookmark(sectionDetail[index].id);
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
  }
}
