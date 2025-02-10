import 'package:get/get.dart';
import 'package:task_management/data/models/task_count_by_status.dart';
import 'package:task_management/data/models/task_list_by_status_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';

class CanceledTaskController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  bool _inProgressTaskCount = false;
  bool get inProgressTaskCount => _inProgressTaskCount;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  TaskListByStatusModel? newTaskListModel;
  List<TaskModel> get taskList => newTaskListModel?.taskList ?? [];

  TaskCountByStatusModel? taskCountByStatusModel;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatus('Canceled'),
    );
    if (response.isSuccess) {
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }

  Future<bool> getTaskCountingByStatus() async {
    bool isSuccess = false;
    _inProgressTaskCount = true;
    update();
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskCountByStatus);
    if (response.isSuccess) {
      taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(response.responseData!);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgressTaskCount = false;
    update();
    return isSuccess;
  }

  Future<bool> updateTaskStatus(String taskId, String newStatus) async {
    bool isSuccess = false;
    update();
    final String url = Urls.updateTaskStatus(taskId, newStatus);
    final NetworkResponse response = await NetworkCaller.getRequest(url: url);
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    update();
    return isSuccess;
  }

  Future<bool> deleteTask(String taskId) async {
    bool isSuccess = false;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTask(taskId),
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    update();
    return isSuccess;
  }
}
