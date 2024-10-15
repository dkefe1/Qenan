import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:qenan/core/constants.dart';
import 'package:qenan/core/global.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/guidelines/data/models/feedback.dart';
import 'package:qenan/features/guidelines/data/models/feedbackTypes.dart';
import 'package:qenan/features/guidelines/data/models/guidelines.dart';
import 'package:http/http.dart' as http;

class GuidelinesRemoteDataSource {
  final prefs = PrefService();

  Future<List<Guidelines>> getGuidelines() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}guidelines');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);

    try {
      if (response.statusCode == 200) {
        // final Guidelines appInfo = Guidelines.fromJson(data['data']);
        // return appInfo;
        final List<dynamic> guidelines = data['data'];
        List<Guidelines> appInfo = guidelines.map((favJson) {
          return Guidelines.fromJson(favJson);
        }).toList();
        return appInfo;
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

  Future<List<FeedbackTypes>> getFeedbackTypes() async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('${baseUrl}feedback-types');

    var response = await http.get(url, headers: headersList);

    var resBody = response.body;

    final data = json.decode(resBody);
    print(data.toString());

    try {
      if (response.statusCode == 200) {
        final List<dynamic> feedbackTypeList = data['data'];
        List<FeedbackTypes> feedbackTypes = feedbackTypeList.map((catJson) {
          return FeedbackTypes.fromJson(catJson);
        }).toList();

        return feedbackTypes;
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

  Future giveFeedback(FeedbackModel feedback) async {
    var token = await prefs.readToken();

    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}feedbacks");

    var body = {
      'feedback_type_id': int.parse(feedback.feedback_type_id),
      'body': feedback.body
    };

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Feedback Sumitted Successfully!");
        print(data['data']);
        return "Feedback Sumitted Successfully!";
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
}
