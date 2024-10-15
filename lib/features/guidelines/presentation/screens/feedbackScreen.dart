import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/common/errorFlushbar.dart';
import 'package:qenan/features/common/errorText.dart';
import 'package:qenan/features/common/submitButton.dart';
import 'package:qenan/features/guidelines/data/models/feedback.dart';
import 'package:qenan/features/guidelines/data/models/feedbackTypes.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_bloc.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_event.dart';
import 'package:qenan/features/guidelines/presentation/bloc/guidelines_state.dart';
import 'package:qenan/l10n/l10n.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController feedbackController = TextEditingController();

  final feedbackFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool feedbackEmpty = false;
  bool categoryNotSelected = false;

  FeedbackTypes? value;

  String? catId;

  List<FeedbackTypes> categories = [];
  String selectedLanguage = "";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FeedbackBloc>(context).add(GetFeedbackTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: height * 0.08,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25, top: 6),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: blackColor,
              )),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          selectedLanguage =
              state.selectedLanguage.value.toString().toLowerCase();

          return BlocConsumer<FeedbackBloc, FeedbackState>(
            listener: (context, state) {
              print(state);
              if (state is FeedbackTypeLoadingState) {
              } else if (state is FeedbackTypeSuccessfulState) {
                categories = state.feedbackTypes;
              } else if (state is FeedbackTypeFailureState) {
                errorFlushbar(context: context, message: state.error);
              } else if (state is FeedbackLoadingState) {
                isLoading = true;
              } else if (state is FeedbackSuccessfulState) {
                isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Feedback Submitted Successfully!"),
                    backgroundColor: Colors.green, // Adjust color as needed
                  ),
                );
                feedbackController.text = "";
                // successFlushBar(context: context, message: state.toString());
              } else if (state is FeedbackFailureState) {
                isLoading = false;
                errorFlushbar(
                    context: context, message: "Failed to Load Categories");
              }
            },
            builder: (context, state) {
              return buildInitialInput();
            },
          );
        },
      ),
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Form(
        key: feedbackFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(horizontal: 33),
              color: headerBgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.12,
                  ),
                  Image.asset(
                    "images/blackLogo.png",
                    fit: BoxFit.fill,
                    width: width < 390 ? 85 : 100,
                    height: width < 390 ? 30 : 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                          return Text(
                            AppLocalizations.of(context)!.feedback,
                            style: TextStyle(
                                color: blackColor,
                                fontSize: width < 390
                                    ? state.selectedLanguage.text == "English"
                                        ? 44
                                        : 40
                                    : state.selectedLanguage.text == "English"
                                        ? 48
                                        : 43,
                                fontWeight: FontWeight.w900),
                          );
                        },
                      ),
                      Text(
                        ".",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: width < 390 ? 44 : 48,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      AppLocalizations.of(context)!.pleaseGiveUsYourFeedback,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  categoriesComponent(),
                  if (categoryNotSelected)
                    errorText(
                        text:
                            AppLocalizations.of(context)!.pleaseSelectCategory),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 6),
                    child: Text(
                      AppLocalizations.of(context)!.message,
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: dividerColor, width: 1),
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(4)),
                    child: TextField(
                      controller: feedbackController,
                      style: const TextStyle(color: blackColor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                          labelText: AppLocalizations.of(context)!.message,
                          labelStyle: TextStyle(
                              color: hintColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      minLines: 5,
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          feedbackEmpty = false;
                        });
                      },
                    ),
                  ),
                  feedbackEmpty
                      ? errorText(
                          text: AppLocalizations.of(context)!.enterFeedback)
                      : SizedBox(),
                  const SizedBox(
                    height: 70,
                  ),
                  submitButton(
                    disable: isLoading,
                    onInteraction: () {
                      if (feedbackFormKey.currentState!.validate()) {
                        if (catId == null) {
                          return setState(() {
                            categoryNotSelected = true;
                          });
                        }
                        if (feedbackController.text.isEmpty) {
                          return setState(() {
                            feedbackEmpty = true;
                          });
                        }
                        print("category ID: $catId");
                        print("Content: ${value!.title}");
                        BlocProvider.of<FeedbackBloc>(context).add(
                            PostFeedbackEvent(FeedbackModel(
                                feedback_type_id: catId!,
                                body: selectedLanguage == 'am_amh'
                                    ? value!.title[1].value
                                    : value!.title[0].value)));
                      }
                    },
                    text: isLoading
                        ? "${AppLocalizations.of(context)!.submittingFeedback}..."
                        : "${AppLocalizations.of(context)!.submit}",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categoriesComponent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FeedbackTypes>(
            value: value,
            isExpanded: true,
            hint: Text(
              AppLocalizations.of(context)!.selectCategory,
              style: TextStyle(
                  color: darkBlue, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            items: categories.map(buildMenuCategories).toList(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: primaryColor,
              size: 30,
            ),
            dropdownColor: whiteColor,
            onChanged: (value) {
              setState(() {
                this.value = value;
                catId = value!.id.toString();
                categoryNotSelected = false;
              });
            }),
      ),
    );
  }

  DropdownMenuItem<FeedbackTypes> buildMenuCategories(FeedbackTypes category) =>
      DropdownMenuItem(
          value: category,
          child: Text(
            selectedLanguage == 'am_amh'
                ? category.title[1].value
                : category.title[0].value,
            style: TextStyle(
                color: darkBlue, fontSize: 14, fontWeight: FontWeight.w500),
          ));
}
