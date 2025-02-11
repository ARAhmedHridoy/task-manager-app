import 'package:get/get.dart';
import 'package:task_management/ui/controllers/auth/auth_controller.dart';
import 'package:task_management/ui/screens/auth/login.dart';

class LogoutController extends GetxController {
  static Future<void> logout() async {
    await AuthController.clearUserData();

    Get.offNamedUntil(LoginScreen.routeName, (predicate) => false);
  }
}
