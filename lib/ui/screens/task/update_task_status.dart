import 'package:flutter/material.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class UpdateTaskStatusScreen extends StatefulWidget {
  const UpdateTaskStatusScreen({Key? key, required String taskId})
      : super(key: key);

  static const String routeName = '/update-task-status';

  @override
  State<UpdateTaskStatusScreen> createState() => _UpdateTaskStatusScreenState();
}

class _UpdateTaskStatusScreenState extends State<UpdateTaskStatusScreen> {
  List<TaskModel> tasks = [];
  TaskModel? selectedTask;
  String? selectedStatus;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      tasks = await fetchNewTasks();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBarMessage(context, 'Error fetching tasks: $e');
    }
  }

  Future<List<TaskModel>> fetchNewTasks() async {
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatus('New'), // Define this in your `Urls` class.
    );

    if (response.isSuccess) {
      final List<dynamic> data = response.responseData?['data'] ?? [];
      return data.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      throw Exception(response.errorMessage);
    }
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    final response = await NetworkCaller.postRequest(
      url: Urls.updateTaskStatus(taskId, status),
      body: {}, // Pass additional body data if required.
    );

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task status updated successfully');
      Navigator.pop(context); // Return to the previous screen.
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task Status'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<TaskModel>(
                    value: selectedTask,
                    items: tasks
                        .map(
                          (task) => DropdownMenuItem(
                            value: task,
                            child: Text(task.title ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTask = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ['New', 'Progress', 'Completed', 'Canceled']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedTask != null && selectedStatus != null) {
                        updateTaskStatus(selectedTask!.sId!, selectedStatus!);
                      } else {
                        showSnackBarMessage(
                          context,
                          'Please select both task and status',
                        );
                      }
                    },
                    child: const Text('Update Status'),
                  ),
                ],
              ),
            ),
    );
  }
}
