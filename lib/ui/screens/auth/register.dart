import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management/data/services/network_caller.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/auth/login.dart';
import 'package:task_management/ui/utils/app_colors.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fastNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _registerInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                    'Join with us',
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
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fastNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your phone number';
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
                    visible: _registerInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapRegisterButton,
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: _buildRegisterSection(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapRegisterButton() {
    if (_formKey.currentState!.validate()) {
      registerUser();
    }
  }

  Future<void> registerUser() async {
    _registerInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _fastNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _phoneController.text.trim(),
      "password": _passwordController.text,
      "photo": "",
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.register,
      body: requestBody,
    );

    _registerInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'Registration successful');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _clearTextFields() {
    _emailController.clear();
    _fastNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _passwordController.clear();
  }

  Widget _buildRegisterSection(BuildContext context) {
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
                Navigator.pop(context, LoginScreen.routeName);
                //Navigator.pushNamed(context, LoginScreen.routeName);
              },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fastNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
