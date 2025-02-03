import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_management/ui/screens/auth/update_profile.dart';
import 'package:task_management/ui/screens/forgot_password/email_verify.dart';
import 'package:task_management/ui/screens/forgot_password/otp_code_verify.dart';
import 'package:task_management/ui/screens/forgot_password/reset_password.dart';
import 'package:task_management/ui/screens/auth/login.dart';
import 'package:task_management/ui/screens/main_bottom_nav.dart';
import 'package:task_management/ui/screens/auth/register.dart';
import 'package:task_management/ui/screens/splash_screen.dart';
import 'package:task_management/ui/screens/task/add_new_task.dart';
import 'package:task_management/ui/utils/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          fillColor: Colors.white,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            //minimumSize: const Size.fromHeight(50),
            fixedSize: const Size.fromWidth(double.maxFinite),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            backgroundColor: AppColors.themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;

        if (settings.name == SplashScreen.routeName) {
          widget = const SplashScreen();
        } else if (settings.name == LoginScreen.routeName) {
          widget = const LoginScreen();
        } else if (settings.name == RegisterScreen.routeName) {
          widget = const RegisterScreen();
        } else if (settings.name == EmailVerifyScreen.routeName) {
          widget = const EmailVerifyScreen();
        } else if (settings.name == OTPCodeVerifyScreen.routeName) {
          widget = const OTPCodeVerifyScreen();
        } else if (settings.name == ResetPasswordScreen.routeName) {
          widget = const ResetPasswordScreen();
        } else if (settings.name == MainBottomNav.routeName) {
          widget = const MainBottomNav();
        } else if (settings.name == AddNewTaskScreen.routeName) {
          widget = const AddNewTaskScreen();
        } else if (settings.name == UpdateProfileScreen.routeName) {
          widget = const UpdateProfileScreen();
        }

        return MaterialPageRoute(builder: (ctx) => widget);
      },
    );
  }
}
