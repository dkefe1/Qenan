import 'package:qenan/features/home/data/dataSources/homeDataSource.dart';
import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/data/models/category.dart';
import 'package:qenan/features/home/data/models/categoryDetail.dart';
import 'package:qenan/features/home/data/models/courses.dart';
import 'package:qenan/features/home/data/models/homePage.dart';
import 'package:qenan/features/home/data/models/searchList.dart';
import 'package:qenan/features/home/data/models/sections.dart';

class HomeRepository {
  HomeRemoteDataSource homeRemoteDataSource;
  HomeRepository(this.homeRemoteDataSource);
  Future<List<Category>> getCategory() async {
    try {
      final category = await homeRemoteDataSource.getCategory();
      return category;
    } catch (e) {
      throw e;
    }
  }

  Future<CategoryDetail> getCategoryDetail(String categoryId) async {
    try {
      final categoryDetail =
          await homeRemoteDataSource.getCategoryDetail(categoryId);
      return categoryDetail;
    } catch (e) {
      throw e;
    }
  }

  Future<HomePage> getHomePage() async {
    try {
      final homePage = await homeRemoteDataSource.getHomePage();
      return homePage;
    } catch (e) {
      throw e;
    }
  }

  Future<Course> getCourse(String courseId) async {
    try {
      final courseInfo = await homeRemoteDataSource.getCourse(courseId);
      return courseInfo;
    } catch (e) {
      throw e;
    }
  }

  Future<SearchList> search(String searchTerm) async {
    try {
      final result = await homeRemoteDataSource.search(searchTerm);
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future addFavorites(String courseId) async {
    try {
      await homeRemoteDataSource.addFavorites(courseId);
    } catch (e) {
      throw e;
    }
  }

  Future removeFavorites(String courseId) async {
    try {
      await homeRemoteDataSource.removeFavorites(courseId);
    } catch (e) {
      throw e;
    }
  }

  Future<List<Sections>> getFavorites() async {
    try {
      final favorites = await homeRemoteDataSource.getFavorites();
      return favorites;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Bundles>> getAllBundles() async {
    try {
      final bundles = await homeRemoteDataSource.getAllBundles();
      return bundles;
    } catch (e) {
      throw e;
    }
  }

  Future completeLesson(String bundleId, String courseId) async {
    try {
      await homeRemoteDataSource.completeLesson(bundleId, courseId);
    } catch (e) {
      throw e;
    }
  }
}
