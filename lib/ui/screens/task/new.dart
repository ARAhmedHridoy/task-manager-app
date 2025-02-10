import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/task_count_by_status.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/ui/controllers/task/new_task_controller.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/custom_appBar.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/task_items.dart';
import 'package:task_management/ui/widgets/task_status_counter.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  TaskCountByStatusModel? taskCountByStatusModel;
  final NewTaskController _newTaskController = Get.find<NewTaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllDataSequence();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Column(
              children: [
                Center(
                  child: _buildTasksSummary(),
                ),
                Center(
                  child: GetBuilder<NewTaskController>(builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: _buildTaskListView(controller.taskList),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskListView(List<TaskModel> taskList) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return TaskItems(
          taskModel: taskList[index],
          onDeleteTask: _deleteTask,
          onUpdateTaskStatus: _updateTaskStatus,
        );
      },
    );
  }

  Widget _buildTasksSummary() {
    const List<String> fixedPosition = [
      'New',
      'Progress',
      'Completed',
      'Canceled'
    ];

    //final NewTaskController _newTaskController = Get.find<NewTaskController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_newTaskController.taskCountByStatusModel == null) {
        _newTaskController.getTaskCountingByStatus();
      }
    });

    return SingleChildScrollView(
      child: GetBuilder<NewTaskController>(builder: (controller) {
        final taskMap = {
          for (var task
              in _newTaskController.taskCountByStatusModel?.taskByStatusList ??
                  [])
            task.sId: task.sum.toString()
        };
        return Visibility(
          visible: controller.inProgressTaskCount == false,
          replacement: const CenteredCircularProgressIndicator(),
          child: SizedBox(
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: fixedPosition.length,
                itemBuilder: (context, index) {
                  final title = fixedPosition[index];
                  final count = taskMap[title] ?? '0';

                  return TaskStatusCounter(
                    title: title,
                    count: count,
                  );
                }),
          ),
        );
      }),
    );
  }

  Future<void> _fetchAllDataSequence() async {
    try {
      await _getTaskCountingByStatus();
      await _getNewTaskList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> _getTaskCountingByStatus() async {
    final bool isSuccess = await _newTaskController.getTaskCountingByStatus();

    if (!isSuccess) {
      Get.snackbar('Error', _newTaskController.errorMessage!);
    }
  }

  Future<void> _getNewTaskList() async {
    final bool isSuccess = await _newTaskController.getNewTaskList();

    if (!isSuccess) {
      Get.snackbar('Error', _newTaskController.errorMessage!);
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final bool isSuccess = await _newTaskController.deleteTask(taskId);

    if (isSuccess) {
      await _fetchAllDataSequence();
      Get.snackbar('Success', 'Task Deleted Successfully');
    } else {
      Get.snackbar('Error', _newTaskController.errorMessage!);
    }
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    final bool isSuccess = await _newTaskController.updateTaskStatus(
      taskId,
      newStatus,
    );

    if (isSuccess) {
      Get.snackbar('Success', 'Task status updated successfully');
      await _fetchAllDataSequence();
    } else {
      Get.snackbar('Error', _newTaskController.errorMessage!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
