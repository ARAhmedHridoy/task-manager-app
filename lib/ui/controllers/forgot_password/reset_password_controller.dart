import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> resetPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final otp = prefs.getString('otp');

    bool isSuccess = false;
    _isLoading = true;
    update();

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPassword,
      body: {
        'email': email,
        'OTP': otp,
        'password': password,
      },
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
      final responseData = response.responseData!;
      if (responseData['status'] == 'success') {
        await prefs.remove('email');
        await prefs.remove('otp');
      } else {
        _errorMessage = responseData['status'];
      }
    } else {
      _errorMessage = response.errorMessage;
    }
    _isLoading = false;
    update();
    return isSuccess;
  }
}
