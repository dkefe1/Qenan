abstract class CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {}

class GetCategoryDetailEvent extends CategoryEvent {
  String categoryId;
  GetCategoryDetailEvent(this.categoryId);
}

abstract class FilterEvent {}

class GetFilterEvent extends FilterEvent {
  String filterCourseId;
  GetFilterEvent(this.filterCourseId);
}

abstract class HomePageEvent {}

class GetHomePageEvent extends HomePageEvent {}

abstract class CourseEvent {}

class GetCourseEvent extends CourseEvent {
  String courseId;
  GetCourseEvent(this.courseId);
}

abstract class SearchEvent {}

class GetSearchEvent extends SearchEvent {
  String searchTerm;
  GetSearchEvent(this.searchTerm);
}

abstract class FavoritesEvent {}

class PostFavoritesEvent extends FavoritesEvent {
  final String courseId;
  PostFavoritesEvent(this.courseId);
}

class DelFavoritesEvent extends FavoritesEvent {
  final String courseId;
  DelFavoritesEvent(this.courseId);
}

abstract class FetchFavoritesEvent {}

class GetFavoritesEvent extends FetchFavoritesEvent {}

abstract class BundleEvent {}

class GetBundlesEvent extends BundleEvent {}

class PostCompleteLessonEvent extends BundleEvent {
  final String bundleId;
  final String courseId;
  PostCompleteLessonEvent(this.bundleId, this.courseId);
}
