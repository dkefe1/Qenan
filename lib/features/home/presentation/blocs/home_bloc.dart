import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/data/models/category.dart';
import 'package:qenan/features/home/data/models/categoryDetail.dart';
import 'package:qenan/features/home/data/models/courses.dart';
import 'package:qenan/features/home/data/models/homePage.dart';
import 'package:qenan/features/home/data/models/searchList.dart';
import 'package:qenan/features/home/data/models/sections.dart';
import 'package:qenan/features/home/data/repositories/homeRepository.dart';
import 'package:qenan/features/home/presentation/blocs/home_event.dart';
import 'package:qenan/features/home/presentation/blocs/home_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  HomeRepository homeRepository;
  CategoryBloc(this.homeRepository) : super(CategoryInitialState()) {
    on<GetCategoryEvent>(_onGetCategoryEvent);
    on<GetCategoryDetailEvent>(_onGetCategoryDetailEvent);
  }

  void _onGetCategoryEvent(GetCategoryEvent event, Emitter emit) async {
    emit(CategoryLoadingState());
    try {
      List<Category> category = await homeRepository.getCategory();
      emit(CategorySuccessfulState(category));
    } catch (e) {
      emit(CategoryFailureState(e.toString()));
    }
  }

  void _onGetCategoryDetailEvent(
      GetCategoryDetailEvent event, Emitter emit) async {
    emit(CategoryDetailLoadingState());
    try {
      CategoryDetail categoryDetail =
          await homeRepository.getCategoryDetail(event.categoryId);
      emit(CategoryDetailSuccessfulState(categoryDetail));
    } catch (e) {
      emit(CategoryDetailFailureState(e.toString()));
    }
  }
}

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  HomeRepository homeRepository;
  FilterBloc(this.homeRepository) : super(FilterInitialState()) {
    on<GetFilterEvent>(_onGetFilterEvent);
  }
  void _onGetFilterEvent(GetFilterEvent event, Emitter emit) async {
    emit(FilterLoadingState());
    try {
      CategoryDetail filteredCourses =
          await homeRepository.getCategoryDetail(event.filterCourseId);
      emit(FilterSuccessfulState(filteredCourses));
    } catch (e) {
      emit(FilterFailureState(e.toString()));
    }
  }
}

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomeRepository homeRepository;
  HomePageBloc(this.homeRepository) : super(HomePageInitialState()) {
    on<GetHomePageEvent>(_onGetHomePageEvent);
  }

  void _onGetHomePageEvent(GetHomePageEvent event, Emitter emit) async {
    emit(HomePageLoadingState());
    try {
      HomePage homePage = await homeRepository.getHomePage();
      emit(HomePageSuccessfulState(homePage));
    } catch (e) {
      emit(HomePageFailureState(e.toString()));
    }
  }
}

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  HomeRepository homeRepository;
  CourseBloc(this.homeRepository) : super(CourseInitialState()) {
    on<GetCourseEvent>(_onGetCourseEvent);
  }

  void _onGetCourseEvent(GetCourseEvent event, Emitter emit) async {
    emit(CourseLoadingState());
    try {
      Course course = await homeRepository.getCourse(event.courseId);
      emit(CourseSuccessfulState(course));
    } catch (e) {
      emit(CourseFailureState(e.toString()));
    }
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  HomeRepository homeRepository;
  SearchBloc(this.homeRepository) : super(SearchInitialState()) {
    on<GetSearchEvent>(_onGetSearchEvent);
  }

  void _onGetSearchEvent(GetSearchEvent event, Emitter emit) async {
    emit(SearchLoadingState());
    try {
      SearchList searchList = await homeRepository.search(event.searchTerm);
      emit(SearchSuccessfulState(searchList));
    } catch (e) {
      emit(SearchFailureState(e.toString()));
    }
  }
}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  HomeRepository homeRepository;
  FavoritesBloc(this.homeRepository) : super(FavoritesInitialState()) {
    on<PostFavoritesEvent>(_onPostFavoritesEvent);
    on<DelFavoritesEvent>(_onDelFavoritesEvent);
  }

  void _onPostFavoritesEvent(PostFavoritesEvent event, Emitter emit) async {
    emit(FavoritesLoadingState());
    try {
      await homeRepository.addFavorites(event.courseId);
      emit(FavoritesSuccessfulState());
    } catch (e) {
      emit(FavoritesFailureState(e.toString()));
    }
  }

  void _onDelFavoritesEvent(DelFavoritesEvent event, Emitter emit) async {
    emit(RemoveFavoritesLoadingState());
    try {
      await homeRepository.removeFavorites(event.courseId);
      emit(RemoveFavoritesSuccessfulState());
    } catch (e) {
      emit(RemoveFavoritesFailureState(e.toString()));
    }
  }
}

class FetchFavoritesBloc
    extends Bloc<FetchFavoritesEvent, FetchFavoritesState> {
  HomeRepository homeRepository;
  FetchFavoritesBloc(this.homeRepository) : super(GetFavoritesInitialState()) {
    on<GetFavoritesEvent>(_onGetFavoritesEvent);
  }

  void _onGetFavoritesEvent(GetFavoritesEvent event, Emitter emit) async {
    emit(GetFavoritesLoadingState());
    try {
      List<Sections> favoriteCourses = await homeRepository.getFavorites();
      emit(GetFavoritesSuccessfulState(favoriteCourses));
    } catch (e) {
      emit(GetFavoritesFailureState(e.toString()));
    }
  }
}

class BundleBloc extends Bloc<BundleEvent, BundleState> {
  HomeRepository homeRepository;
  BundleBloc(this.homeRepository) : super(AchievementInitialState()) {
    on<GetBundlesEvent>(_onGetBundlesEvent);
    on<PostCompleteLessonEvent>(_onPostCompleteLessonEvent);
  }

  void _onGetBundlesEvent(GetBundlesEvent event, Emitter emit) async {
    emit(GetBundlesLoadingState());
    try {
      final List<Bundles> bundles = await homeRepository.getAllBundles();
      emit(GetBundlesSuccessfulState(bundles));
    } catch (e) {
      emit(GetBundlesFailureState(e.toString()));
    }
  }

  void _onPostCompleteLessonEvent(
      PostCompleteLessonEvent event, Emitter emit) async {
    emit(StartLessonLoadingState());
    try {
      await homeRepository.completeLesson(event.bundleId, event.courseId);
      emit(StartLessonSuccessfulState());
    } catch (e) {
      emit(StartLessonFailureState(e.toString()));
    }
  }
}
