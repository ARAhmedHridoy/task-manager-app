import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/task_count_by_status.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/ui/controllers/task/progress_task_controller.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/custom_appBar.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/task_items.dart';
import 'package:task_management/ui/widgets/task_status_counter.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  TaskCountByStatusModel? taskCountByStatusModel;
  final ProgressTaskController _progressTaskController =
      Get.find<ProgressTaskController>();

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
                  child:
                      GetBuilder<ProgressTaskController>(builder: (controller) {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_progressTaskController.taskCountByStatusModel == null) {
        _progressTaskController.getTaskCountingByStatus();
      }
    });

    return SingleChildScrollView(
      child: GetBuilder<ProgressTaskController>(builder: (controller) {
        final taskMap = {
          for (var task in _progressTaskController
                  .taskCountByStatusModel?.taskByStatusList ??
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
    final bool isSuccess =
        await _progressTaskController.getTaskCountingByStatus();

    if (!isSuccess) {
      Get.snackbar('Error', _progressTaskController.errorMessage!);
    }
  }

  Future<void> _getNewTaskList() async {
    final bool isSuccess = await _progressTaskController.getNewTaskList();

    if (!isSuccess) {
      Get.snackbar('Error', _progressTaskController.errorMessage!);
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final bool isSuccess = await _progressTaskController.deleteTask(taskId);

    if (isSuccess) {
      await _fetchAllDataSequence();
      Get.snackbar('Success', 'Task Deleted Successfully');
    } else {
      Get.snackbar('Error', _progressTaskController.errorMessage!);
    }
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    final bool isSuccess = await _progressTaskController.updateTaskStatus(
      taskId,
      newStatus,
    );

    if (isSuccess) {
      Get.snackbar('Success', 'Task status updated successfully');
      await _fetchAllDataSequence();
    } else {
      Get.snackbar('Error', _progressTaskController.errorMessage!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
