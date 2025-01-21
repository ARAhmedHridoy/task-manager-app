import 'package:flutter/material.dart';
import 'package:task_management/ui/screens/task/canceled.dart';
import 'package:task_management/ui/screens/task/completed.dart';
import 'package:task_management/ui/screens/task/new.dart';
import 'package:task_management/ui/screens/task/progress.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  static const String routeName = '/home';

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const NewTaskScreen(),
    const ProgressTaskScreen(),
    const CompletedTaskScreen(),
    const CanceledTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
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
    );
  }
}
