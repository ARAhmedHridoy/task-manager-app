import 'package:get/get.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  bool _isProgressing = false;

  bool get isProgressing => _isProgressing;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;
    _isProgressing = true;
    update();
    Map<String, dynamic> requestBody = {
      'title': title,
      'description': description,
      'status': 'New',
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.addNewTask,
      body: requestBody,
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _isProgressing = false;
    update();
    return isSuccess;
  }
}
