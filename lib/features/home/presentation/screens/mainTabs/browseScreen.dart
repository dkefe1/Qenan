import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qenan/core/constants.dart';
import 'package:qenan/features/common/blocs/language_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_bloc.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';
import 'package:qenan/features/home/presentation/widgets/coursesListWidget.dart';
import 'package:qenan/features/home/presentation/widgets/searchField.dart';
import 'package:qenan/l10n/l10n.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  TextEditingController searchController = TextEditingController();

  String? selectedCategory;
  String? selectedCategoryId;

  List<Map<String, String>> categories = [
    {"name": "New", "id": "new"},
    {"name": "Creative", "id": "creative"},
    {"name": "Tech", "id": "tech"},
    {"name": "Business", "id": "business"},
  ];
  bool isCategoryLoaded = false;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    if (categories.isNotEmpty) {
      selectedCategory = categories[0]["name"];
      selectedCategoryId = categories[0]["id"];
    }
    BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          String selectedLanguage =
              state.selectedLanguage.value.toString().toLowerCase();

          return BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategorySuccessfulState && !isCategoryLoaded) {
                categories = state.category.map((category) {
                  return {
                    "name": selectedLanguage == 'am_amh'
                        ? category.name[1].value
                        : category.name[0].value,
                    "id": category.id
                  };
                }).toList();

                setState(() {
                  isCategoryLoaded = true;
                  if (categories.isNotEmpty) {
                    selectedCategory = categories[0]["name"];
                    selectedCategoryId = categories[0]["id"];
                    BlocProvider.of<FilterBloc>(context)
                        .add(GetFilterEvent(selectedCategoryId!));
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is CategoryLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else if (state is CategorySuccessfulState) {
                // setState(() {
                //   categories = [
                //     {"name": "New", "id": "new"},
                //     ...state.category.map((category) {
                //       return {"name": category.name[0].value, "id": category.id};
                //     }).toList(),
                //   ];

                //   BlocProvider.of<CategoryBloc>(context)
                //       .add(GetCategoryDetailEvent("1"));
                //   isCategoryLoaded = true;
                // });

                return buildInitialInput();
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  Widget buildInitialInput() {
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
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.browse,
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 34,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    ".",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 34,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: searchField(
                  context: context,
                  controller: searchController,
                  hintText: AppLocalizations.of(context)!.whatAreYouLookingFor),
            ),
            Container(
                margin: const EdgeInsets.only(top: 25, bottom: 20),
                height: 55,
                width: width,
                child: buildCategories(categories)),
            const CourseListWidget(),
            Container(
              margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
              width: width,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  image: DecorationImage(
                      image: AssetImage("images/temp/gerarTile.jpg"),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              height: 110,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategories(List<Map<String, String>> categoryList) {
    double width = MediaQuery.of(context).size.width;

    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          bool isSelected = selectedCategory == categoryList[index]["name"];
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                setState(() {
                  BlocProvider.of<FilterBloc>(context)
                      .add(GetFilterEvent(selectedCategoryId!));
                });
              } else {
                setState(() {
                  selectedCategory = categoryList[index]["name"];
                  selectedCategoryId = categoryList[index]["id"];
                  print(selectedCategory.toString());
                  print(selectedCategoryId.toString());
                  BlocProvider.of<FilterBloc>(context)
                      .add(GetFilterEvent(selectedCategoryId!));
                });
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: index != 0 ? 8 : 0),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0C2566), primaryColor],
                      )
                    : null,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    categoryList[index]["name"].toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey,
                      fontSize: width < 390 ? 16 : 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
