import 'package:flutter/material.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/home/data/models/lessons.dart';
import 'package:qenan/features/home/presentation/screens/playerScreen.dart';
import 'package:qenan/l10n/l10n.dart';

class LessonsListWidget extends StatelessWidget {
  final List<Lessons>? lessons;
  const LessonsListWidget({
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 20, bottom: 15),
        itemCount: lessons!.length,
        itemBuilder: (context, index) {
          Lessons selectedLesson = lessons![index];
          return GestureDetector(
            onTap: () {
              // print("Selected Lesson Id:" + selectedLessonId);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                      selectedLessonsId: selectedLesson.lesson_number,
                      title: selectedLesson.title[0].value,
                      lessonNumber: selectedLesson.lesson_number)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 27,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: width < 390 ? height * 0.19 : height * 0.17,
                        width: width < 390 ? width * 0.439 : width * 0.48,
                        child: Stack(
                          children: [
                            // Container(
                            //   margin: const EdgeInsets.only(top: 10),
                            //   decoration: BoxDecoration(
                            //     color: darkBlue,
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   height: 119,
                            //   width: 192,
                            // ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: width < 390 ? width * 0.44 : width * 0.48,
                              height:
                                  width < 390 ? height * 0.19 : height * 0.17,
                              decoration: BoxDecoration(
                                  // color:
                                  //     const Color(0xFF875A01).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(lessons![index]
                                          .attachments
                                          .lesson_thumbnail
                                          .toString()),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width < 390 ? width * 0.36 : width * 0.34,
                            child: Text(
                              lessons![index].title[0].value,
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Text(
                            "${lessons![index].duration} ${AppLocalizations.of(context)!.min}",
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: width < 390 ? width * 0.36 : width * 0.34,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.lesson} ${lessons![index].lesson_number}",
                                  style: TextStyle(
                                      color: Color(0xFF0C603D),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, right: 10),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: secondaryColor,
                                      ),
                                      child: Center(
                                        child: const Icon(
                                          Icons.check,
                                          color: whiteColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: dividerColor,
                    height: 2,
                  )
                ],
              ),
            ),
          );
        });
  }
}
