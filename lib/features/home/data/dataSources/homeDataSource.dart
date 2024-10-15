import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:qenan/core/constants.dart';
import 'package:qenan/core/global.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/home/data/models/bundles.dart';
import 'package:qenan/features/home/data/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:qenan/features/home/data/models/categoryDetail.dart';
import 'package:qenan/features/home/data/models/courses.dart';
import 'package:qenan/features/home/data/models/homePage.dart';
import 'package:qenan/features/home/data/models/searchList.dart';
import 'package:qenan/features/home/data/models/sections.dart';

class HomeRemoteDataSource {
  final prefs = PrefService();
  Future<List<Category>> getCategory() async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse("${baseUrl}categories");
    var response = await http.get(url, headers: headersList);
    var resBody = response.body;
    final data = json.decode(resBody);
    try {
      if (response.statusCode == 200) {
        final List<dynamic> categoryList = data['data'];
        List<Category> category = categoryList.map((catJson) {
          return Category.fromJson(catJson);
        }).toList();
        return category;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<CategoryDetail> getCategoryDetail(String categoryId) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse("${baseUrl}categories/${categoryId}");
    var response = await http.get(url, headers: headersList);
    var resBody = response.body;
    final data = json.decode(resBody);
    try {
      if (response.statusCode == 200) {
        final CategoryDetail categoryDetail =
            CategoryDetail.fromJson(data['data']);
        return categoryDetail;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<HomePage> getHomePage() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse(
        '${baseUrl}home?popular=1&for_you=1&creative=1&courses=1&categories=1&continue=1&bundles=1');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        final HomePage homepage = HomePage.fromJson(data['data']);
        return homepage;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Course> getCourse(String courseId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse(
        '${baseUrl}courses/${courseId}?course=1&related=1&instructors=1');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);
    print(response.body.toString());

    try {
      if (response.statusCode == 200) {
        final Course courseInfo = Course.fromJson(data['data']);
        return courseInfo;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<SearchList> search(String searchTerm) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}search?search=${searchTerm}');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);
    print(resBody.toString());

    try {
      if (response.statusCode == 200) {
        final SearchList searchList = SearchList.fromJson(data['data']);
        return searchList;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future addFavorites(String courseId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}favorites/${courseId}/add?type=course");

    try {
      var response = await http.get(url, headers: headersList);
      final resBody = response.body;
      final data = json.decode(resBody);
      print('Response status Code: ${response.statusCode}');
      print('Response header: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("Added to My Course!");
        print(data['data']);
      } else {
        print(data['data']);
        print(data.toString());
        print(data['status']);
        throw data['data'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future removeFavorites(String courseId) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}favorites/${courseId}/remove?type=course");

    try {
      var response = await http.get(url, headers: headersList);
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Removed from My List!");
        print(data['data']);
      } else {
        print(data['data']);
        print(data.toString());
        print(data['status']);
        throw data['data'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<Sections>> getFavorites() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}favorites?type=course");

    try {
      var response = await http.get(url, headers: headersList);
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("My Courses fetched Successfully!");
        print(data['data']);
        final List<dynamic> favoriteCourses = data['data'];
        List<Sections> favorites = favoriteCourses.map((favJson) {
          return Sections.fromJson(favJson);
        }).toList();
        return favorites;
      } else {
        print(data['data']);
        print(data.toString());
        print(data['status']);
        throw data['data'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<Bundles>> getAllBundles() async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse("${baseUrl}bundles");
    var response = await http.get(url, headers: headersList);
    var resBody = response.body;
    final data = json.decode(resBody);
    try {
      if (response.statusCode == 200) {
        final List<dynamic> bundlesList = data['data']['bundles']['data'];
        List<Bundles> bundles = bundlesList.map((bundleJson) {
          return Bundles.fromJson(bundleJson);
        }).toList();
        return bundles;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Bundles> getBundleDetail(String bundleId) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse("${baseUrl}bundles/${bundleId}");
    var response = await http.get(url, headers: headersList);
    var resBody = response.body;
    final data = json.decode(resBody);
    try {
      if (response.statusCode == 200) {
        final Bundles bundlesList = Bundles.fromJson(data['data']);
        return bundlesList;
      } else {
        throw data['status'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future completeLesson(String bundleId, String courseId) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}bundles/${bundleId}/complete");

    var body = {"lesson_id": courseId};

    print('Request Body: $body');

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Lesson Completed!");
        print(data['data']['message']);
      } else if (response.statusCode == 403) {
        throw "Course does not exist on this achievement";
      } else {
        print('Error data: ${data['data']}');
        print('Error status: ${data['status']}');
        throw data['data'];
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw timeoutErrorMessage;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw socketErrorMessage;
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw formatErrorMessage;
    } on http.ClientException catch (e) {
      print('Client Exception: $e');
      throw socketErrorMessage;
    } catch (e) {
      print('General Error: $e');
      throw e;
    }
  }
}
