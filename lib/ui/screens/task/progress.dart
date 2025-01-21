import 'package:flutter/material.dart';
//import 'package:task_management/data/models/task_count_model.dart';
import 'package:task_management/data/models/task_list_by_status_model.dart';
import 'package:task_management/data/models/task_count_by_status.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/task/add_new_task.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/custom_appBar.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';
import 'package:task_management/ui/widgets/task_items.dart';
import 'package:task_management/ui/widgets/task_status_counter.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getTaskCountingByStatusProgress = false;
  bool _getNewTaskListProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  @override
  void initState() {
    super.initState();
    _fetchAllDataSequence();
    // _getTaskCountingByStatus();
    // _getProgressTaskList();
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
                  child: Visibility(
                    visible: _getNewTaskListProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: _buildTaskListView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.routeName);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: newTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItems(
          taskModel: newTaskListModel!.taskList![index],
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

    final taskMap = {
      for (var task in taskCountByStatusModel?.taskByStatusList ?? [])
        task.sId: task.sum.toString()
    };

    return SingleChildScrollView(
      child: Visibility(
        visible: _getTaskCountingByStatusProgress == false,
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
      ),
    );
  }

  // Widget _buildTasksSummary() {
  //   return SingleChildScrollView(
  //     child: Visibility(
  //       visible: _getTaskCountingByStatusProgress == false,
  //       replacement: const CenteredCircularProgressIndicator(),
  //       child: SizedBox(
  //         height: 100,
  //         child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             shrinkWrap: true,
  //             itemCount: taskCountByStatusModel?.taskByStatusList?.length ?? 0,
  //             itemBuilder: (context, index) {
  //               final TaskCountModel model =
  //                   taskCountByStatusModel!.taskByStatusList![index];
  //               return TaskStatusCounter(
  //                 title: model.sId ?? '',
  //                 count: model.sum.toString(),
  //               );
  //             }),
  //       ),
  //     ),
  //   );
  // }

  Future<void> _fetchAllDataSequence() async {
    try {
      await _getTaskCountingByStatus();
      await _getProgressTaskList();
    } catch (e) {
      showSnackBarMessage(context, e.toString());
    }
  }

  Future<void> _getTaskCountingByStatus() async {
    _getTaskCountingByStatusProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskCountByStatus);

    if (response.isSuccess) {
      taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountingByStatusProgress = false;
    setState(() {});
  }

  Future<void> _getProgressTaskList() async {
    _getNewTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatus('Progress'),
    );

    if (response.isSuccess) {
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListProgress = false;
    setState(() {});
  }

  Future<void> _deleteTask(String taskId) async {
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTask(taskId),
    );

    if (response.isSuccess) {
      await _getProgressTaskList();
      showSnackBarMessage(context, 'Task Deleted Successfully');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    final String url = Urls.updateTaskStatus(taskId, newStatus);
    final NetworkResponse response = await NetworkCaller.getRequest(url: url);

    if (response.isSuccess) {
      //await _getProgressTaskList();
      await _fetchAllDataSequence();
      showSnackBarMessage(context, 'Task status updated successfully');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
