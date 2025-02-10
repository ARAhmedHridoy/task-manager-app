import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task_management/ui/controllers/auth/auth_controller.dart';
import 'package:task_management/ui/screens/auth/login.dart';
import 'package:task_management/ui/screens/main_bottom_nav.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      bool isUserLoggedIn = await AuthController.isUserLoggedIn();
      if (isUserLoggedIn) {
        Get.offAllNamed(MainBottomNav.routeName);
      } else {
        Get.offAllNamed(LoginScreen.routeName);
      }
    });
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'animations/splash.json',
        ),
      ),
    );
  }
}
