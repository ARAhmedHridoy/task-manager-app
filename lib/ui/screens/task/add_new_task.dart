import 'package:flutter/material.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/main_bottom_nav.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/custom_appBar.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const routeName = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isProgressing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Task Title',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _isProgressing == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addNewTask();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    _isProgressing = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'status': 'New',
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.addNewTask,
      body: requestBody,
    );
    _isProgressing = false;
    setState(() {});

    if (response.isSuccess) {
      _clearFields();
      showSnackBarMessage(context, 'Task Added Successfully');
      Navigator.pushReplacementNamed(context, MainBottomNav.routeName);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
