import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/screens/courseScreen.dart';
import 'package:qenan/l10n/l10n.dart';

List<String> searchedItems = [];
bool resultsDisplayed = false;
Widget searchField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
}) {
  controller.addListener(() {
    final query = controller.text;
    if (query.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
    }
  });

  return TextFormField(
    controller: controller,
    onTap: () {
      showSearch(
          context: context,
          delegate: MySearchDelegate(
              searchBloc: BlocProvider.of<SearchBloc>(context)));
    },
    //These methods won't be triggered because this text form is only used to trigger showSearch
    //
    // onFieldSubmitted: (query) async {
    //   if (query.isNotEmpty) {
    //     BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
    //   }
    // },
    // onChanged: (query) {
    //   // triggerSearch(query);
    //   print("111111111111111111111111111111");
    // },
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(26)),
        filled: true,
        fillColor: whiteColor,
        contentPadding: EdgeInsets.only(left: 20),
        hintText: hintText,
        hintStyle: TextStyle(
            color: searchHintColor, fontSize: 15, fontWeight: FontWeight.w300)),
  );
}

class MySearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;
  late Timer _debounce;
  // bool searchTriggered = false;
  MySearchDelegate({required this.searchBloc}) {
    _debounce = Timer(Duration.zero, () {});
  }
  void triggerSearch(String query) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        searchBloc.add(GetSearchEvent(query));
      }
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.light(),
      appBarTheme: AppBarTheme(toolbarHeight: 100),
      primaryColor: primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        border: InputBorder.none,
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor)),
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    if (query.isNotEmpty) {
      searchBloc.add(GetSearchEvent(query));
    }
    return IconButton(
      onPressed: () {
        if (resultsDisplayed) {
          close(context, null);
          BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
        } else {
          close(context, null);
        }
        FocusScope.of(context).unfocus();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        query.isEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  if (query.isEmpty) {
                    close(context, null);
                    FocusScope.of(context).unfocus();
                  } else {
                    query = '';
                  }
                },
              )
            : ElevatedButton(
                onPressed: () async {
                  final searchText = query;
                  if (searchText.isNotEmpty) {
                    searchedItems.add(query);
                    print(searchedItems.toString());
                    // await pref.storeSearchSuggestion(searchedItems);
                    // searchSuggestionList = await pref.getSearchSuggestion();
                    // print(searchSuggestionList.toString() + "0000000000");
                    BlocProvider.of<SearchBloc>(context)
                        .add(GetSearchEvent(searchText));
                    showResults(
                        context); // This method needs to be called so that it automatically displays the searched Items list.
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.search,
                  style: TextStyle(color: primaryColor),
                ),
              ),
      ];

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (_, state) {
        print(state);
        if (state is SearchLoadingState) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
            semanticsLabel: AppLocalizations.of(context)!.searching,
          ));
        } else if (state is SearchSuccessfulState) {
          var searchResults = state.searchList;
          return searchResults.courses.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.noResult,
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                color: searchHintColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .thereIsNoResult),
                                TextSpan(
                                    text: query.toString(),
                                    style: TextStyle(color: primaryColor)),
                                TextSpan(
                                    text:
                                        "\n${AppLocalizations.of(context)!.pleaseTryAgain}"),
                              ]))
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: 14),
                                children: [
                              TextSpan(
                                  text:
                                      (searchResults.courses.length).toString(),
                                  style: TextStyle(color: primaryColor)),
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .resultsFound,
                                  style: TextStyle(color: primaryColor))
                            ])),
                        const SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: searchResults.courses.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchResults.courses.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 6),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<CourseBloc>(context).add(
                                          GetCourseEvent(
                                              searchResults.courses[index].id));
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseScreen(courseId: "")));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 109,
                                              width: 163,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  color: Colors.grey.shade300
                                                      .withOpacity(0.6)),
                                            ),
                                            Container(
                                              height: 109,
                                              width: 163,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          searchResults
                                                              .courses[index]
                                                              .attachments
                                                              .course_cover
                                                              .toString()),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ],
                                        ),
                                        BlocBuilder<LanguageBloc,
                                            LanguageState>(
                                          builder: (context, state) {
                                            String selectedLanguage = state
                                                .selectedLanguage.value
                                                .toString()
                                                .toLowerCase();
                                            return Text(
                                              selectedLanguage == 'am_amh'
                                                  ? searchResults.courses[index]
                                                      .title[1].value
                                                  : searchResults.courses[index]
                                                      .title[0].value,
                                              style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        } else if (state is SearchFailureState) {
          return Center(
              child: Text(
                  "${AppLocalizations.of(context)!.couldntDisplaySearch}, \n${AppLocalizations.of(context)!.tryAgain}"));
        }
        return Container();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
    }
    triggerSearch(query);
    return Container();
  }
}
