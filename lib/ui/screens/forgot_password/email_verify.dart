import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/forgot_password/otp_code_verify.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  static const routeName = '/email-verify';

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
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
                  'Your Email Address',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'A 6 digit code will be sent to your email address',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: _isLoading == false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _verifyEmail();
                      }
                    },
                    child: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.white,
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
                Navigator.pop(context);
                //Navigator.pushNamed(context, LoginScreen.routeName);
              },
          ),
        ],
      ),
    );
  }

  Future<void> _verifyEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showSnackBarMessage(context, 'Please enter email');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.verifyEmail(email),
    );

    if (response.isSuccess) {
      final responseData = response.responseData!;

      if (responseData['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        Navigator.pushNamed(context, OTPCodeVerifyScreen.routeName);
      } else {
        showSnackBarMessage(context, responseData['status']);
      }
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
