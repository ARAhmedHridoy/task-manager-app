import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management/data/models/user_model.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';
import 'package:task_management/ui/screens/forgot_password/email_verify.dart';
import 'package:task_management/ui/screens/main_bottom_nav.dart';
import 'package:task_management/ui/screens/auth/register.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loginProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Get Started with',
                    style: textTheme.titleLarge,
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
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your password';
                      }
                      if (value!.length < 6) {
                        return 'Password length should be greater than 6';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: _loginProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapLoginButton,
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              EmailVerifyScreen.routeName,
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                        _buildLoginSection(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapLoginButton() {
    if (_formKey.currentState!.validate()) {
      _loginToAccount();
    }
  }

  Future<void> _loginToAccount() async {
    _loginProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.login,
      body: requestBody,
    );
    if (response.isSuccess) {
      String token = response.responseData!['token'];
      UserModel userModel = UserModel.fromJson(response.responseData!['data']);
      await AuthController.saveUserData(token, userModel);
      Navigator.pushReplacementNamed(context, MainBottomNav.routeName);
    } else {
      _loginProgress = false;
      setState(() {});
      if (response.statusCode == 401) {
        showSnackBarMessage(
            context, 'Invalid email or password! Please try again.');
      } else {
        showSnackBarMessage(context, response.errorMessage);
      }
    }
  }

  Widget _buildLoginSection(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Don\'t have an account? ',
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: ' Sign Up',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, RegisterScreen.routeName);
              },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
