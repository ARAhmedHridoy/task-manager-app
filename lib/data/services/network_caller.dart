import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_management/app.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/auth/login.dart';

class NetworkResponse {
  final int statusCode;
  final Map<String, dynamic>? responseData;
  final bool isSuccess;
  final String errorMessage;

  NetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    this.responseData,
    this.errorMessage = 'Something went wrong',
  });
}

class NetworkCaller {
  static Future<NetworkResponse> getRequest(
      {required String url, Map<String, dynamic>? params}) async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('URL => $url');
      Response response = await get(
        uri,
        headers: {'token': AuthController.authToken ?? ''},
      );
      debugPrint('Response => ${response.statusCode}');
      debugPrint('Response => ${response.body}');
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else if (response.statusCode == 401) {
        await _logout();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('URL => $url');
      debugPrint('Body => $body');
      Response response = await post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'token': AuthController.authToken ?? '',
        },
        body: jsonEncode(body),
      );
      debugPrint('Response => ${response.statusCode}');
      debugPrint('Response => ${response.body}');
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else if (response.statusCode == 401) {
        await _logout();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<void> _logout() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      TaskManagerApp.navigatorKey.currentContext!,
      LoginScreen.routeName,
      (_) => false,
    );
  }
}
