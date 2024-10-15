import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/data/models/category.dart';
import 'package:qenan/features/home/data/models/categoryDetail.dart';
import 'package:qenan/features/home/data/models/courses.dart';
import 'package:qenan/features/home/data/models/homePage.dart';
import 'package:qenan/features/home/data/models/searchList.dart';
import 'package:qenan/features/home/data/models/sections.dart';

abstract class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategorySuccessfulState extends CategoryState {
  final List<Category> category;
  CategorySuccessfulState(this.category);
}

class CategoryFailureState extends CategoryState {
  final String error;
  CategoryFailureState(this.error);
}

class CategoryDetailLoadingState extends CategoryState {}

class CategoryDetailSuccessfulState extends CategoryState {
  final CategoryDetail categoryDetail;
  CategoryDetailSuccessfulState(this.categoryDetail);
}

class CategoryDetailFailureState extends CategoryState {
  final String error;
  CategoryDetailFailureState(this.error);
}

abstract class FilterState {}

class FilterInitialState extends FilterState {}

class FilterLoadingState extends FilterState {}

class FilterSuccessfulState extends FilterState {
  final CategoryDetail filteredCourses;
  FilterSuccessfulState(this.filteredCourses);
}

class FilterFailureState extends FilterState {
  final String error;
  FilterFailureState(this.error);
}

abstract class HomePageState {}

class HomePageInitialState extends HomePageState {}

class HomePageLoadingState extends HomePageState {}

class HomePageSuccessfulState extends HomePageState {
  final HomePage homePage;

  HomePageSuccessfulState(this.homePage);
}

class HomePageFailureState extends HomePageState {
  final String error;
  HomePageFailureState(this.error);
}

abstract class CourseState {}

class CourseInitialState extends CourseState {}

class CourseLoadingState extends CourseState {}

class CourseSuccessfulState extends CourseState {
  final Course course;
  CourseSuccessfulState(this.course);
}

class CourseFailureState extends CourseState {
  final String error;
  CourseFailureState(this.error);
}

abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessfulState extends SearchState {
  final SearchList searchList;
  SearchSuccessfulState(this.searchList);
}

class SearchFailureState extends SearchState {
  final String error;
  SearchFailureState(this.error);
}

abstract class FavoritesState {}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesSuccessfulState extends FavoritesState {}

class FavoritesFailureState extends FavoritesState {
  final String error;
  FavoritesFailureState(this.error);
}

abstract class FetchFavoritesState {}

class GetFavoritesInitialState extends FetchFavoritesState {}

class GetFavoritesLoadingState extends FetchFavoritesState {}

class GetFavoritesSuccessfulState extends FetchFavoritesState {
  final List<Sections> favoriteCourses;
  GetFavoritesSuccessfulState(this.favoriteCourses);
}

class GetFavoritesFailureState extends FetchFavoritesState {
  final String error;
  GetFavoritesFailureState(this.error);
}

class RemoveFavoritesLoadingState extends FavoritesState {}

class RemoveFavoritesSuccessfulState extends FavoritesState {}

class RemoveFavoritesFailureState extends FavoritesState {
  final String error;
  RemoveFavoritesFailureState(this.error);
}

abstract class BundleState {}

class AchievementInitialState extends BundleState {}

class GetBundlesLoadingState extends BundleState {}

class GetBundlesSuccessfulState extends BundleState {
  final List<Bundles> bundles;
  GetBundlesSuccessfulState(this.bundles);
}

class GetBundlesFailureState extends BundleState {
  final String error;
  GetBundlesFailureState(this.error);
}

class StartLessonLoadingState extends BundleState {}

class StartLessonSuccessfulState extends BundleState {}

class StartLessonFailureState extends BundleState {
  final String error;
  StartLessonFailureState(this.error);
}
