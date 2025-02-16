import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/AuthBtn.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/AuthGoogle.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/LoginSingupToogle.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/Ordivider.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/TextFeildComponent.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';
import 'package:gdsc_artwork/Constants/commonToast.dart';
import 'package:gdsc_artwork/ViewModel/login_and_signup_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback toggleView;

  SignupPage({required this.toggleView});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  void _verifyOtp(BuildContext context) {
    final otp =
        otpControllers.map((controller) => controller.text.trim()).join();

    if (otp.isEmpty) {
      commonToast('Please enter the OTP');
      return;
    }

    final email = emailController.text.trim();
    context.read<LoginAndSignupProvider>().verifyOtp(email, otp, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      color: CustomColors.secondaryBrown,
                      fontFamily: "OutfitMedium",
                      fontSize: 34,
                    ),
                  ),
                  Text(
                    "Login or Sign up to start creating",
                    style: TextStyle(
                      color: CustomColors.primaryWhite,
                      fontFamily: "OutfitRegular",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35.0),
              ToggleSection(isLogin: false, toggleView: widget.toggleView),
              if (showOtpSection)
                _buildOtpSection()
              else if (showEmailPasswordSection)
                _buildEmailPasswordSection(context)
              else
                _buildProfileSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
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
                : Icon(
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
        const SizedBox(height: 23.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your username?',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "OutfitRegular",
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8.0),
            TextFieldComponent(
              labelText: 'Username',
              controller: usernameController,
            ),
          ],
        ),
        const SizedBox(height: 25.0),
        AuthButton(
          buttonText: 'Confirm',
          onPressed: () {
            if (usernameController.text.trim().isEmpty) {
              commonToast('Username cannot be empty');
            } else {
              setState(() {
                showEmailPasswordSection = true;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmailPasswordSection(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              setState(() {
                showEmailPasswordSection = false;
              });
            },
          ),
        ),
        TextFieldComponent(
          labelText: 'Email',
          controller: emailController,
        ),
        const SizedBox(height: 15.0),
        TextFieldComponent(
          labelText: 'Password',
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 20.0),
        Consumer<LoginAndSignupProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? CircularProgressIndicator()
                : AuthButton(
                    buttonText: 'Signup',
                    onPressed: () => _signUp(context),
                  );
          },
        ),
        const SizedBox(height: 15.0),
        OrDivider(),
        const SizedBox(height: 15.0),
        GoogleSignInButton(onPressed: () {}, isLogin: false),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Center(
          child: Text(
            'An OTP has been sent to your email ${emailController.text}',
            style: TextStyle(
              color: CustomColors.secondaryBrown,
              fontFamily: "OutfitRegular",
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
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
            return provider.isLoadingOtp
                ? CircularProgressIndicator()
                : AuthButton(
                    buttonText: 'Confirm',
                    onPressed: () => _verifyOtp(context),
                  );
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
      child: TextField(
        controller: otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: CustomColors.primaryWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
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
