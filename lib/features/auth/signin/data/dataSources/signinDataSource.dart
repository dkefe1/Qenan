import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:qenan/core/constants.dart';
import 'package:qenan/core/global.dart';
import 'package:qenan/core/services/sharedPreferences.dart';
import 'package:qenan/features/auth/signin/data/models/changePassword.dart';
import 'package:qenan/features/auth/signin/data/models/forgotPassword.dart';
import 'package:qenan/features/auth/signin/data/models/otp.dart';
import 'package:qenan/features/auth/signin/data/models/resetForgotPassword.dart';
import 'package:qenan/features/auth/signin/data/models/signin.dart';
import 'package:http/http.dart' as http;
import 'package:qenan/features/auth/signin/data/models/updateProfile.dart';
import 'package:qenan/features/auth/signin/data/models/userProfile.dart';
import 'package:qenan/features/auth/signup/presentation/widgets/transformPhoneNumber.dart';

class SigninRemoteDataSource {
  final prefs = PrefService();
  Future signinUser(Signin signin) async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}login");

    var body = signin.identifier.contains('09')
        ? {
            "phone": transformPhoneNumber(signin.identifier),
            "password": signin.password
          }
        : {"username": signin.identifier, "password": signin.password};

    print('Request Body: $body');

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        await prefs.storeToken(data['data']['token']);
        print(data['data']['user']['username']);
        await prefs.storeFullName(data['data']['user']['first_name'] +
            " " +
            data['data']['user']['last_name']);
        await prefs
            .storePhoto(data['data']['user']['attachments']['user_photo']);
        await prefs.storeUserName(data['data']['user']['username']);
        print("Login Successful!");
        print(data['data']);
      } else if (response.statusCode == 403) {
        throw "Please enter correct login credentials";
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

  Future logout() async {
    var token = await prefs.readToken();
    var headersList = {
      // 'Accept': '*/*',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}logout");

    try {
      var response = await http.delete(url, headers: headersList);

      if (response.statusCode == 200) {
        final resBody = response.body;
        final data = json.decode(resBody);
        print(data.toString());
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        final resBody = response.body;
        final data = json.decode(resBody);
        throw Exception(data['error']);
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw 'Timeout Error: $e';
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw 'Socket Error: $e';
    } on FormatException catch (e) {
      print('Format Error: $e');
      throw 'Format Error: $e';
    } on http.ClientException catch (e) {
      print('Client Exception Socket Error: $e');
      throw 'Client Exception Socket Error: $e';
    } on Error catch (e) {
      print('Error: $e');
      throw 'Error: $e';
    }
  }

  Future forgotPassword(ForgotPassword forgotPassword) async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}forgot-password");

    var body = {
      'phone': forgotPassword.phone,
    };
    print('Request Body: $body');

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("OTP sent Successfully!");
        print(data['data']);
      } else if (response.statusCode == 404) {
        throw "User Not Found.";
      } else {
        print(data.toString());
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
      print('Client Exception: $e');
      throw socketErrorMessage;
    } catch (e) {
      print('General Error: $e');
      throw e;
    }
  }

  Future otpVerification(OTP otp) async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}verify-otp");

    var body = {
      'phone': otp.phone,
      'code': otp.code,
    };
    print('Request Body: $body');

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Otp Verified!");
        print(data['data']);
      } else {
        print(data['data']);
        print(data.toString());
        print(data['status']);
        throw data['data']['message'];
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

  Future resetForgotPassword(ResetForgotPassword resetForgotPassword) async {
    var headersList = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}set-forgot-password");

    var body = {
      'phone': resetForgotPassword.phone,
      'password': resetForgotPassword.password,
      'password_confirmation': resetForgotPassword.password_confirmation
    };
    print(body.toString());
    print('Request Body: $body');

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Password Reset Successful!");
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
      print('Client Exception: $e');
      throw socketErrorMessage;
    } catch (e) {
      print('General Error: $e');
      throw e;
    }
  }

  Future changePassword(ChangePassword changePassword) async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var url = Uri.parse("${baseUrl}change-password");

    var body = {
      'password': changePassword.password,
      'new_password': changePassword.new_password,
      'new_password_confirmation': changePassword.new_password_confirmation
    };
    print(body.toString());

    try {
      var response =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = response.body;
      final data = json.decode(resBody);

      if (response.statusCode == 200) {
        print("Password Changed Successful!");
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

  Future<UserProfile> getProfile() async {
    var token = await prefs.readToken();
    var headersList = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse("${baseUrl}profile");
    var response = await http.get(url, headers: headersList);
    var resBody = response.body;
    final data = json.decode(resBody);
    try {
      if (response.statusCode == 200) {
        final UserProfile categoryDetail =
            UserProfile.fromJson(data['data']['user']);
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

  Future<void> updateProfile(UpdateProfile updateProfile) async {
    var token = await prefs.readToken();
    var headersList = {'Accept': '*/*', 'Authorization': 'Bearer $token'};

    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}profile'));

    request.headers.addAll(headersList);

    request.fields.addAll({
      'first_name': updateProfile.first_name,
      'last_name': updateProfile.last_name,
      'email': updateProfile.email,
      'dob': updateProfile.dob,
      'phone': updateProfile.phone,
      'sex': updateProfile.sex,
      '_method': "PATCH"
    });

    var imageFile = updateProfile.photo;
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

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final data = json.decode(responseBody);
        print(data.toString());

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
}
