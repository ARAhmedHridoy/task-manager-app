import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/ui/controllers/auth/auth_controller.dart';
import 'package:task_management/ui/controllers/auth/update_profile_controller.dart';
import 'package:task_management/ui/screens/splash_screen.dart';
import 'package:task_management/ui/widgets/background.dart';
import 'package:task_management/ui/widgets/custom_appBar.dart';
import 'package:task_management/ui/widgets/progress_indicator.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const routeName = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fastNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UpdateProfileController _updateProfileController =
      Get.find<UpdateProfileController>();

  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    _emailController.text = AuthController.userModel?.email ?? '';
    _fastNameController.text = AuthController.userModel?.firstName ?? '';
    _lastNameController.text = AuthController.userModel?.lastName ?? '';
    _phoneController.text = AuthController.userModel?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(
        formUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Update Profile',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoPicker(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fastNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Fast Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter fast name';
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
                        return 'Please enter last name';
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
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter Password if you want to change',
                    ),
                  ),
                  const SizedBox(height: 24),
                  GetBuilder<UpdateProfileController>(builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _updateProfile();
                          }
                        },
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GetBuilder<UpdateProfileController>(builder: (_) {
      return GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Photo',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                  _pickedImage == null
                      ? 'No Image Selected'
                      : _pickedImage!.name,
                  maxLines: 1),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      _updateProfileController.update();
    }
  }

  Future<void> _updateProfile() async {
    final bool isSuccess = await _updateProfileController.updateProfile(
      _emailController.text.trim(),
      _fastNameController.text.trim(),
      _lastNameController.text.trim(),
      _phoneController.text.trim(),
      _pickedImage != null ? await _pickedImage!.readAsBytes() : null,
      _passwordController.text.isNotEmpty ? _passwordController.text : null,
    );

    if (isSuccess) {
      _pickedImage = null;
      await AuthController.clearUserData();
      Get.offAllNamed(
        SplashScreen.routeName,
      );
      Get.snackbar('Success', 'Profile updated successful');
    } else {
      Get.snackbar('Error', _updateProfileController.errorMessage!);
    }
  }
  // Future<void> _updateProfile() async {
  //   _inProgress = true;
  //   setState(() {});

  //   Map<String, dynamic> requestBody = {
  //     "email": _emailController.text.trim(),
  //     "firstName": _fastNameController.text.trim(),
  //     "lastName": _lastNameController.text.trim(),
  //     "mobile": _phoneController.text.trim(),
  //   };

  //   if (_pickedImage != null) {
  //     List<int> imageBytes = await _pickedImage!.readAsBytes();
  //     requestBody['photo'] = base64Encode(imageBytes);
  //   }

  //   if (_passwordController.text.isNotEmpty) {
  //     requestBody['password'] = _passwordController.text;
  //   }

  //   final NetworkResponse response = await NetworkCaller.postRequest(
  //     url: Urls.updateProfile,
  //     body: requestBody,
  //   );

  //   _inProgress = false;
  //   setState(() {});

  //   if (response.isSuccess) {
  //     _pickedImage = null;
  //     showSnackBarMessage(context, 'Profile updated successful');
  //     await AuthController.clearUserData();
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       SplashScreen.routeName,
  //       (predicate) => false,
  //     );
  //   } else {
  //     showSnackBarMessage(context, response.errorMessage);
  //   }
  // }

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
