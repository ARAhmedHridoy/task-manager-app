import 'package:flutter/material.dart';

class TaskStatusCounter extends StatelessWidget {
  const TaskStatusCounter({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            children: [
              Text(
                count,
                style: textTheme.titleLarge,
              ),
              Text(
                title,
                style: textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
