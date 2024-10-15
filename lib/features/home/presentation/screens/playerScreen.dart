import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/home/data/models/lessons.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/videoPlayer.dart/orientationPlayer/controls.dart';
import 'package:qenan/l10n/l10n.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  final String selectedLessonsId;
  final String title;
  final String lessonNumber;

  const PlayerScreen(
      {super.key,
      required this.selectedLessonsId,
      required this.title,
      required this.lessonNumber});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState(
      selectedLessonsId: selectedLessonsId,
      title: title,
      lessonNumber: lessonNumber);
}

class _PlayerScreenState extends State<PlayerScreen> {
  late FlickManager flickManager;
  GlobalKey<_PlayerScreenState> flickVideoPlayerKey = GlobalKey();
  bool lessonCompleted = false;
  final Set<int> currentPosition = {};
  Lessons? selectedLesson;
  _PlayerScreenState(
      {required this.selectedLessonsId,
      required this.title,
      required this.lessonNumber});
  String selectedLessonsId;
  String title;
  String lessonNumber;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")));
    flickManager.flickVideoManager?.videoPlayerController!
        .addListener(videoListener);
  }

  void videoListener() {
    final position =
        flickManager.flickVideoManager?.videoPlayerController!.value.position;
    final duration =
        flickManager.flickVideoManager?.videoPlayerController!.value.duration;

    if (position != null && duration != null) {
      // Track the positions the user has watched
      currentPosition.add(position.inSeconds);

      // Calculate the percentage of the video watched
      final percentageWatched = currentPosition.length / duration.inSeconds;

      // Check if the video has finished playing and enough has been watched
      if (percentageWatched >= 0.95 &&
          position == duration &&
          !lessonCompleted) {
        lessonCompleted = true;
        BlocProvider.of<BundleBloc>(context)
            .add(PostCompleteLessonEvent("1", widget.selectedLessonsId));
        print("Youuuuuu did iiiiiiiiiiiiiiiiitttttttttttttttttttt!!!!!!!!!!");
        // BlocProvider.of<CourseBloc>(context).add(StartAchievement());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.flickVideoManager?.videoPlayerController!
        .removeListener(videoListener);
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        surfaceTintColor: darkBlue,
        toolbarHeight: height * 0.08,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Image.asset(
              "images/whiteLogo.png",
              width: 89,
              height: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          String selectedLanguage =
              state.selectedLanguage.value.toString().toLowerCase();

          return BlocConsumer<CourseBloc, CourseState>(
            listener: (context, state) {
              if (state is CourseSuccessfulState) {
                // Store the selected lesson
                selectedLesson = state.course.course.lessons!.firstWhere(
                    (lesson) => lesson.id == widget.selectedLessonsId);
              }
            },
            builder: (context, state) {
              if (state is CourseSuccessfulState) {
                return Container(
                  color: darkBlue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width,
                        height: height * 0.3,
                        decoration: BoxDecoration(
                            // image: DecorationImage(
                            //     image: AssetImage("images/temp/player.jpg"),
                            //     fit: BoxFit.cover),
                            ),
                        // child: Center(
                        //   child: Icon(
                        //     Icons.play_arrow_rounded,
                        //     color: secondaryColor,
                        //     size: 120,
                        //   ),
                        // ),
                        child: FlickVideoPlayer(
                          key: flickVideoPlayerKey,
                          flickManager: flickManager,
                          preferredDeviceOrientationFullscreen: [
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ],
                          flickVideoWithControls: FlickVideoWithControls(
                            controls: CustomOrientationControls(),
                          ),
                          flickVideoWithControlsFullscreen:
                              FlickVideoWithControls(
                            videoFit: BoxFit.fitWidth,
                            controls: CustomOrientationControls(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              color: secondaryColor,
                              size: 60,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: width < 390 ? 18 : 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    selectedLanguage == 'am_amh'
                                        ? state
                                            .course.instructor[0].name[1].value
                                        : state
                                            .course.instructor[0].name[0].value,
                                    style: TextStyle(
                                      color: playingColor,
                                      fontSize: width < 390 ? 14 : 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.lesson} ${lessonNumber}",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: width < 390 ? 14 : 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 27, vertical: width < 390 ? 20 : 30),
                        child: Divider(
                          color: dividerColor,
                          height: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          AppLocalizations.of(context)!.upNext,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: width,
                                  margin: const EdgeInsets.only(bottom: 30),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      itemCount:
                                          state.course.course.lessons!.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedLessonsId = state.course
                                                  .course.lessons![index].id;
                                              title =
                                                  selectedLanguage == 'am_amh'
                                                      ? state
                                                          .course
                                                          .course
                                                          .lessons![index]
                                                          .title[1]
                                                          .value
                                                      : state
                                                          .course
                                                          .course
                                                          .lessons![index]
                                                          .title[0]
                                                          .value;
                                              lessonNumber = state
                                                  .course
                                                  .course
                                                  .lessons![index]
                                                  .lesson_number;
                                              flickManager.handleChangeVideo(
                                                VideoPlayerController.network(
                                                    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
                                              );
                                            });
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              index == 0
                                                  ? const SizedBox.shrink()
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 20,
                                                      ),
                                                      child: const Divider(
                                                        color:
                                                            secondaryDividerColor,
                                                        height: 2,
                                                      ),
                                                    ),
                                              Text(
                                                selectedLanguage == 'am_amh'
                                                    ? state
                                                        .course
                                                        .course
                                                        .lessons![index]
                                                        .title[1]
                                                        .value
                                                    : state
                                                        .course
                                                        .course
                                                        .lessons![index]
                                                        .title[0]
                                                        .value,
                                                style: TextStyle(
                                                  color: upNextColor,
                                                  fontSize:
                                                      width < 390 ? 18 : 20,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${AppLocalizations.of(context)!.lesson} ${state.course.course.lessons![index].lesson_number}",
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    state
                                                        .course
                                                        .course
                                                        .lessons![index]
                                                        .duration,
                                                    style: TextStyle(
                                                      color:
                                                          secondaryDurationColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      })),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
