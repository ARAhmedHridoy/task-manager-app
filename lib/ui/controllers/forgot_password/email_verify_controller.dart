import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';

class EmailVerifyController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> emailVerify(String email) async {
    if (email.isEmpty) {
      _errorMessage = 'Please enter email';
      update();
      return false;
    }

    bool isSuccess = false;
    _isLoading = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.verifyEmail(email),
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
      final responseData = response.responseData!;
      if (responseData['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
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
