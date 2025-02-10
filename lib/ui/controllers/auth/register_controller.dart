import 'package:get/get.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';

class RegisterController extends GetxController {
  bool _registerInProgress = false;

  bool get registerInProgress => _registerInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> registerUser(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
  ) async {
    bool isSuccess = false;
    _registerInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": "",
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.register,
      body: requestBody,
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _registerInProgress = false;
    update();
    return isSuccess;
  }
}
