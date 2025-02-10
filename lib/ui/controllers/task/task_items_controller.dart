import 'package:get/get.dart';

class TaskItemsController extends GetxController {
  var selectedStatus = ''.obs;

  void updateStatus(String newStatus) {
    selectedStatus.value = newStatus;
  }
}
