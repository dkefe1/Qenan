import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/sections.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/widgets/buildHorizontalList.dart';
import 'package:qenan/l10n/l10n.dart';

class MyCourseScreen extends StatefulWidget {
  const MyCourseScreen({super.key});

  @override
  State<MyCourseScreen> createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  final prefs = PrefService();
  String userName = "User";
  String userPhoto = "";

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    BlocProvider.of<FetchFavoritesBloc>(context).add(GetFavoritesEvent());
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    BlocProvider.of<FetchFavoritesBloc>(context).add(GetFavoritesEvent());
  }

  Future<void> fetchUserInfo() async {
    final savedName = await prefs.readFullName();
    final savedPhoto = await prefs.readPhoto();
    setState(() {
      userName = savedName;
      userPhoto = savedPhoto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FetchFavoritesBloc, FetchFavoritesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetFavoritesLoadingState) {
            print(state);
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is GetFavoritesSuccessfulState) {
            return buildInitialInput(savedCourses: state.favoriteCourses);
          } else if (state is GetFavoritesFailureState) {
            return const Center(
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

  Widget buildInitialInput({required List<Sections> savedCourses}) {
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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 32, right: 32, top: height * 0.06),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "images/blackLogo.png",
                        width: width < 390 ? 100 : 130,
                        height: width < 390 ? 30 : 40,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        AppLocalizations.of(context)!.ye +
                            userName +
                            AppLocalizations.of(context)!.course,
                        style: TextStyle(
                            color: blackColor,
                            fontSize: width < 390 ? 16 : 20,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width < 390 ? 45 : 53,
                  height: width < 390 ? 45 : 53,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
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
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32, right: 32, top: 17, bottom: 25),
            child: Divider(
              color: dividerColor,
              height: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
          buildHorizontalList(
              context: context,
              sectionDetail: savedCourses,
              onInteraction: () {}),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 40, bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.saved,
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
            height: 15,
          ),
          buildHorizontalList(
              context: context,
              sectionDetail: savedCourses,
              onInteraction: () {}),
          const SizedBox(
            height: 110,
          ),
        ],
      )),
    );
  }
}
