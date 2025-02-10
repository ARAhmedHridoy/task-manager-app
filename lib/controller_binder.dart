import 'package:get/get.dart';
import 'package:task_management/ui/controllers/auth/auth_controller.dart';
import 'package:task_management/ui/controllers/auth/login_controller.dart';
import 'package:task_management/ui/controllers/auth/logout_controller.dart';
import 'package:task_management/ui/controllers/auth/register_controller.dart';
import 'package:task_management/ui/controllers/auth/update_profile_controller.dart';
import 'package:task_management/ui/controllers/forgot_password/email_verify_controller.dart';
import 'package:task_management/ui/controllers/forgot_password/otp_code_verify_controller.dart';
import 'package:task_management/ui/controllers/forgot_password/reset_password_controller.dart';
import 'package:task_management/ui/controllers/main_bottom_nav_controller.dart';
import 'package:task_management/ui/controllers/task/add_new_task_controller.dart';
import 'package:task_management/ui/controllers/task/canceled_task_controller.dart';
import 'package:task_management/ui/controllers/task/completed_task_controller.dart';
import 'package:task_management/ui/controllers/task/new_task_controller.dart';
import 'package:task_management/ui/controllers/task/progress_task_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => LogoutController());
    Get.lazyPut(() => RegisterController());
    Get.put(NewTaskController());
    Get.lazyPut(() => ProgressTaskController());
    Get.lazyPut(() => CompletedTaskController());
    Get.lazyPut(() => CanceledTaskController());
    Get.lazyPut(() => UpdateProfileController());
    Get.put(MainBottomNavController());
    Get.lazyPut(() => AddNewTaskController());
    Get.lazyPut(() => EmailVerifyController());
    Get.lazyPut(() => OtpCodeVerifyController());
    Get.lazyPut(() => ResetPasswordController());
  }
}
