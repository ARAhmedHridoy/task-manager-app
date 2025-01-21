import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/forgot_password/reset_password.dart';
import 'package:task_management/ui/screens/auth/login.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class OTPCodeVerifyScreen extends StatefulWidget {
  const OTPCodeVerifyScreen({super.key});

  static const routeName = '/otp-code-verify';

  @override
  State<OTPCodeVerifyScreen> createState() => _OTPCodeVerifyScreenState();
}

class _OTPCodeVerifyScreenState extends State<OTPCodeVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

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
                Visibility(
                  visible: _isLoading == false,
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
                ),
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (value) => false,
                );
              },
          ),
        ],
      ),
    );
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null) {
        showSnackBarMessage(context, 'Email not found');
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routeName,
          (value) => false,
        );
        return;
      }

      final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.verifyOTP(email, otp),
      );

      if (response.isSuccess) {
        final responseData = response.responseData!;

        if (responseData['status'] == 'success') {
          //final prefs = await SharedPreferences.getInstance();
          await prefs.setString('otp', otp);

          Navigator.pushNamedAndRemoveUntil(
            context,
            ResetPasswordScreen.routeName,
            (value) => false,
          );
          debugPrint('OTP => $otp');
        } else {
          showSnackBarMessage(context, responseData['status']);
        }
      } else {
        showSnackBarMessage(context, response.errorMessage);
      }
    } catch (e) {
      showSnackBarMessage(context, e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  // @override
  // void dispose() {
  //   _otpController.dispose();
  //   super.dispose();
  // }
}
