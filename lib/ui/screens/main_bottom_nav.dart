import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/main_bottom_nav_controller.dart';
import 'package:task_management/ui/screens/task/add_new_task.dart';
import 'package:task_management/ui/screens/task/canceled.dart';
import 'package:task_management/ui/screens/task/completed.dart';
import 'package:task_management/ui/screens/task/new.dart';
import 'package:task_management/ui/screens/task/progress.dart';
import 'package:task_management/ui/utils/app_colors.dart';

class MainBottomNav extends GetView<MainBottomNavController> {
  const MainBottomNav({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    // final MainBottomNavController mainBottomNavController =
    //     Get.put(MainBottomNavController());

    final List<Widget> screens = [
      const NewTaskScreen(),
      const ProgressTaskScreen(),
      const CompletedTaskScreen(),
      const CanceledTaskScreen(),
    ];

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.themeColor,
        onPressed: () {
          Get.toNamed(AddNewTaskScreen.routeName);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeTabIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.new_label_outlined,
                color: Colors.blue,
              ),
              label: 'New',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.refresh_outlined,
                color: Colors.amber,
              ),
              label: 'Progress',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.done_outlined,
                color: Colors.green,
              ),
              label: 'Completed',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              ),
              label: 'Cancelled',
            ),
          ],
        ),
      ),
    );
  }
}
