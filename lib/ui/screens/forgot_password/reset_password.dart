import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/auth/login.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  late String email;
  late String otp;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    otp = prefs.getString('otp') ?? '';
    debugPrint('Email: $email');
    debugPrint('OTP: $otp');
  }

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
                  'Reset Password',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Minimum length password is 8 characters with Latter and Number combination',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != _passwordController.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: _isLoading == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _resetPassword();
                      }
                    },
                    child: const Text(
                      'Confirm',
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

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final password = _passwordController.text.trim();

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPassword,
      body: {
        'email': email,
        'OTP': otp,
        'password': password,
      },
    );
    if (response.isSuccess) {
      final responseData = response.responseData!;

      if (responseData['status'] == 'success') {
        showSnackBarMessage(context, 'Password Reset Successfully');

        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routeName,
          (value) => false,
        );
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
