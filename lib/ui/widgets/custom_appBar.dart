import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/auth/update_profile.dart';
import 'package:task_management/ui/screens/splash_screen.dart';
import 'package:task_management/ui/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.formUpdateProfile = false,
  });

  final bool formUpdateProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white, // Change back button color
      ),
      backgroundColor: AppColors.themeColor,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: MemoryImage(
              base64Decode(
                AuthController.userModel?.photo ?? '',
              ),
            ),
            onBackgroundImageError: (_, __) => const Icon(Icons.person),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!formUpdateProfile) {
                  Navigator.pushNamed(context, UpdateProfileScreen.routeName);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AuthController.userModel?.email ?? '',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await AuthController.clearUserData();
              Navigator.pushNamedAndRemoveUntil(
                context,
                SplashScreen.routeName,
                (predicate) => false,
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
