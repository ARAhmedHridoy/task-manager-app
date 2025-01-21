import 'package:flutter/material.dart';
import 'package:task_management/ui/utils/app_colors.dart';

class CenteredCircularProgressIndicator extends StatelessWidget {
  const CenteredCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.themeColor,
      ),
    );
  }
}
