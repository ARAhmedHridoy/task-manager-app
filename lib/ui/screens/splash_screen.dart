import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/auth/login.dart';
import 'package:task_management/ui/screens/main_bottom_nav.dart';
//import 'package:task_management/ui/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    bool isUserLoggedIn = await AuthController.isUserLoggedIn();
    if (isUserLoggedIn) {
      Navigator.pushReplacementNamed(context, MainBottomNav.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
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
    // return Scaffold(
    //   body: Center(
    //     child: Lottie.network(
    //       'https://lottie.host/1349bc82-44e6-47cc-b9a2-cf2311c0d3a6/pgXwEdwZbO.json',
    //     ),
    //   ),
    // );
    // return const Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         CircularProgressIndicator(
    //           color: AppColors.themeColor,
    //         ),
    //         SizedBox(height: 8),
    //         Text('Loading...'),
    //       ],
    //     ),
    //   ),
    // );
    // return const Scaffold(
    //   body: ScreenBackground(
    //     child: Center(
    //       child: AppLogo(),
    //     ),
    //   ),
    // );
  }
}
