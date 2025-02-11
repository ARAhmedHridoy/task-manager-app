import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_management/ui/controllers/forgot_password/otp_code_verify_controller.dart';
import 'package:task_management/ui/screens/forgot_password/email_verify.dart';
import 'package:task_management/ui/screens/forgot_password/reset_password.dart';
import 'package:task_management/ui/screens/auth/login.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';

class OTPCodeVerifyScreen extends StatefulWidget {
  const OTPCodeVerifyScreen({super.key});

  static const routeName = '/otp-code-verify';

  @override
  State<OTPCodeVerifyScreen> createState() => _OTPCodeVerifyScreenState();
}

class _OTPCodeVerifyScreenState extends State<OTPCodeVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  final OtpCodeVerifyController _otpCodeVerifyController =
      Get.find<OtpCodeVerifyController>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'OTP Code Verify',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'A 6 digit code has been sent to your email address',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                _buildPinCodeTextField(context),
                const SizedBox(height: 24),
                GetBuilder<OtpCodeVerifyController>(builder: (controller) {
                  return Visibility(
                    visible: controller.isLoading == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _verifyOTP();
                        }
                      },
                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 48),
                Center(
                  child: _buildLoginSection(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PinCodeTextField _buildPinCodeTextField(BuildContext context) {
    return PinCodeTextField(
      validator: (String? value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Please enter OTP code';
        } else if (value!.length < 6) {
          return 'Please enter valid OTP code';
        }
        return null;
      },
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: AppColors.themeColor,
        inactiveColor: Colors.grey,
        selectedColor: AppColors.themeColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _otpController,
      appContext: context,
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Already have an account? ',
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: ' Sign In',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.offAllNamed(LoginScreen.routeName);
              },
          ),
        ],
      ),
    );
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    final bool isSuccess = await _otpCodeVerifyController.verifyOTP(otp);

    if (isSuccess == false) {
      Get.snackbar('Error', 'Email not found');
      Get.offAllNamed(EmailVerifyScreen.routeName);
    } else {
      if (isSuccess) {
        Get.offAllNamed(ResetPasswordScreen.routeName);
        Get.snackbar('Success', 'OTP verified successfully');
      } else {
        Get.snackbar('Error', _otpCodeVerifyController.errorMessage!);
      }
    }
  }

  // @override
  // void dispose() {
  //   _otpController.dispose();
  //   super.dispose();
  // }
}
