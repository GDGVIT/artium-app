import 'package:flutter/material.dart';
import 'package:artium/Auth/AuthUICompnents/auth_btn.dart';
import 'package:artium/Auth/AuthUICompnents/login_signup_toggle.dart';
import 'package:artium/Auth/AuthUICompnents/text_feild_component.dart';
import 'package:artium/Constants/Colors.dart';
import 'package:artium/Constants/common_toast.dart';
import 'package:artium/Providers/login_and_signup_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback toggleView;

  const SignupPage({super.key, required this.toggleView});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _emailPasswordFormKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  bool showEmailPasswordSection = false;
  bool showOtpSection = false;
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _signUp(BuildContext context) {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      commonToast('Please fill in all required fields');
      return;
    }

    final data = {
      'name': username,
      'email': email,
      'password': password,
      'image': _profileImage?.path
    };

    context
        .read<LoginAndSignupProvider>()
        .userSignUp(data, context)
        .then((success) {
      if (success) {
        setState(() {
          showOtpSection = true;
        });
      }
    });
  }

  void _verifyOtp(BuildContext context) async {
    final otp =
        otpControllers.map((controller) => controller.text.trim()).join();

    if (otp.isEmpty) {
      commonToast('Please enter the OTP');
      return;
    }

    final email = emailController.text.trim();
    final success =
        await context.read<LoginAndSignupProvider>().verifyOtp(email, otp);

    if (success) {
      commonToast('Signup successful');
      setState(() {
        showOtpSection = false;
        showEmailPasswordSection = false;
      });
      widget.toggleView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          colors: [
            Color(0xff211F21),
            Color(0xff161516),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 48,
              left: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('images/logo.svg'),
                  SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Artium',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Outfit',
                      color: CustomColors.primaryWhite,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'images/auth_top.png',
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/auth_bottom.png',
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome!',
                        style: TextStyle(
                          color: CustomColors.secondaryBrown,
                          fontFamily: "OutfitRegular",
                          fontSize: 42,
                        ),
                      ),
                      const Text(
                        "Login or Sign up to start creating",
                        style: TextStyle(
                          color: CustomColors.primaryWhite,
                          fontFamily: "OutfitRegular",
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: ToggleSection(
                      isLogin: false, toggleView: widget.toggleView),
                ),
                if (showOtpSection)
                  _buildOtpSection()
                else if (showEmailPasswordSection)
                  _buildEmailPasswordSection(context)
                else
                  _buildProfileSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Form(
      key: _profileFormKey,
      child: Column(
        children: [
          const SizedBox(height: 40.0),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: _profileImage != null
                  ? ClipOval(
                      child: Image.file(
                        _profileImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Create your profile',
            style: TextStyle(
              color: CustomColors.secondaryBrown,
              fontFamily: "OutfitMedium",
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextFieldComponent(
              labelText: 'Username',
              controller: usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is required';
                }
                if (value.length < 3) {
                  return 'Username must be at least 3 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: AuthButton(
              buttonText: 'Confirm',
              onPressed: () {
                if (_profileFormKey.currentState!.validate()) {
                  setState(() {
                    showEmailPasswordSection = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailPasswordSection(BuildContext context) {
    return Form(
      key: _emailPasswordFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  setState(() {
                    showEmailPasswordSection = false;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                TextFieldComponent(
                  labelText: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                TextFieldComponent(
                  labelText: 'Password',
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: CustomColors.primaryWhite,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
                        .hasMatch(value)) {
                      return 'Password must contain uppercase, lowercase & numbers';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Consumer<LoginAndSignupProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const CircularProgressIndicator();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: AuthButton(
                    buttonText: 'Signup',
                    onPressed: () {
                      if (_emailPasswordFormKey.currentState!.validate()) {
                        _signUp(context);
                      }
                    },
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _buildOtpSection() {
    return Column(
      children: [
        const SizedBox(height: 36.0),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: RichText(
              text: TextSpan(
                text: 'An OTP has been sent to your email ',
                style: TextStyle(
                  color: CustomColors.primaryWhite,
                  fontFamily: "OutfitRegular",
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: emailController.text,
                    style: TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: "OutfitRegular",
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: CustomColors.primaryWhite,
                      fontFamily: "OutfitRegular",
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) => _otpBox(index)),
        ),
        const SizedBox(height: 30.0),
        Consumer<LoginAndSignupProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingOtp) {
              return const CircularProgressIndicator();
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: AuthButton(
                  buttonText: 'Confirm',
                  onPressed: () => _verifyOtp(context),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _otpBox(int index) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: CustomColors.primaryBrown,
      ),
      child: TextFormField(
        controller: otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: CustomColors.primaryWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          if (!RegExp(r'^[0-9]$').hasMatch(value)) {
            return '';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          errorStyle: TextStyle(height: 0),
        ),
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty && index < otpControllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
