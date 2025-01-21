import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/models/user_model.dart';

class AuthController {
  static String? authToken;
  static UserModel? userModel;

  static const _authToken = 'auth-token';
  static const _userData = 'user-data';

  static Future<void> saveUserData(String token, UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(_authToken, token);
    await sharedPreferences.setString(_userData, jsonEncode(model.toJson()));

    authToken = token;
    userModel = model;
  }

  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_authToken);
    String? userData = sharedPreferences.getString(_userData);
    authToken = token;
    userModel = UserModel.fromJson(jsonDecode(userData!));
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_authToken);
    if (token != null) {
      await getUserData();
      return true;
    }
    return false;
  }

  Future<void> WriteEmailVerification(Email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('EmailVerification', Email);
  }

  Future<void> WriteOTPVerification(OTP) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('OTPVerification', OTP);
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
