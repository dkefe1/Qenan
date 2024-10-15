import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:qenan/core/constants.dart';
import 'package:qenan/core/global.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signup/data/models/personalization.dart';
import 'package:qenan/features/auth/signup/data/models/profileInfo.dart';
import 'package:qenan/features/auth/signup/data/models/signup.dart';
import 'package:qenan/features/auth/signup/data/models/verifyOtp.dart';

class SignupRemoteDatasource {
  final prefs = PrefService();
  Future signupUser(Signup signup) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}register-basic-info");

    var body = {
      "first_name": signup.first_name,
      "last_name": signup.last_name,
      "username": signup.username,
      "email": signup.email,
      "phone": signup.phone,
      "password": signup.password,
      "password_confirmation": signup.password_confirmation,
    };
    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;

      final data = json.decode(resBody);
      print(data.toString());
      print(response.toString());

      if (response.statusCode == 201) {
        print("User ${data['message']}");
        print(data['data']);
      } else if (response.statusCode == 500) {
        print("User already Exists");
        throw "User already Exists";
      } else {
        print(data['data'].toString());
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
      throw "User already Exists";
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future otpVerification(RegistrationOtp otp) async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}register-verify-otp");

    var body = {
      'phone': otp.phone,
      'code': otp.code,
    };

    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        await prefs.storeToken(data['data']['token']);
        print("Otp Verified!");
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
      throw "Please enter the correct OTP sent to your number";
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw socketErrorMessage;
    } on Error catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> profileInfo(ProfileInfo profile) async {
    var token = await prefs.readToken();
    var headersList = {'Accept': '*/*', 'Authorization': 'Bearer $token'};

    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl}register-complete-profile'));

    request.headers.addAll(headersList);

    request.fields.addAll({
      'dob': profile.dob,
      'sex': profile.sex,
    });

    var imageFile = profile.photo;
    var fileStream = http.ByteStream(imageFile.readAsBytes().asStream());
    var length = await imageFile.length();

    var multipartFile = http.MultipartFile(
      'photo',
      fileStream,
      length,
      filename: imageFile.path.split('/').last,
    );

    request.files.add(multipartFile);

    try {
      var response = await http.Response.fromStream(await request.send());
      print(response.toString());
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final data = json.decode(responseBody);
        print(data.toString());
        await prefs.storeFullName(
            data['data']['first_name'] + " " + data['data']['last_name']);
        await prefs.storePhoto(data['data']['attachments']['user_photo']);
        await prefs.storeUserName(data['data']['username']);

        if (data["status"] == 200) {
          print(responseBody);
        } else {
          print(response.statusCode);
          print(data["message"].toString());
          throw data["message"];
        }
      } else {
        throw 'Failed to add user. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> personalization(Personalization personalize) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}register-preferences");

    var body = {
      'categories': personalize.categories,
    };

    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Preferences have been saved!");
        print(data['data']);
      } else {
        print(data['data']);
        print(data.toString());
        print(data['status']);
        throw "Error saving your Preferences";
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
