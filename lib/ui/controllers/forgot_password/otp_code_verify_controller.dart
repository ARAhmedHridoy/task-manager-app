import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';

class OtpCodeVerifyController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyOTP(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email == null) {
      update();
      return false;
    }

    bool isSuccess = false;
    _isLoading = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.verifyOTP(email, otp),
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
      final responseData = response.responseData!;
      if (responseData['status'] == 'success') {
        await prefs.setString('otp', otp);
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
