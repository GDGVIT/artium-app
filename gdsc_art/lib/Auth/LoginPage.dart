import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/LoginSingupToogle.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/AuthBtn.dart';
import 'package:gdsc_artwork/Auth/AuthUICompnents/TextFeildComponent.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';
import 'package:gdsc_artwork/Constants/commonToast.dart';
import 'package:gdsc_artwork/ViewModel/login_and_signup_provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback toggleView;

  LoginPage({required this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  bool showForgotPassword = false;
  bool showOtpSection = false;
  bool showSuccessMessage = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginAndSignupProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 35.0),
              ToggleSection(isLogin: true, toggleView: widget.toggleView),
              const SizedBox(height: 40.0),
              if (showOtpSection)
                _buildOtpSection(provider)
              else if (showForgotPassword)
                _buildForgotPasswordForm(provider)
              else if (showSuccessMessage)
                _buildSuccessMessage()
              else
                _buildLoginForm(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(LoginAndSignupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFieldComponent(
          labelText: 'Email',
          controller: emailController,
        ),
        const SizedBox(height: 20.0),
        TextFieldComponent(
          labelText: 'Password',
          controller: passwordController,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: TextButton(
            onPressed: () {
              setState(() {
                showForgotPassword = true;
              });
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: CustomColors.primaryWhite,
                fontFamily: "OutfitRegular",
                fontSize: 14,
              ),
            ),
          ),
        ),
        provider.isLoading
            ? const CircularProgressIndicator()
            : AuthButton(
                buttonText: 'Login',
                onPressed: () {
                  final loginData = {
                    'email': emailController.text,
                    'password': passwordController.text,
                  };
                  provider.userLog(loginData, context);
                },
              ),
      ],
    );
  }

  Widget _buildForgotPasswordForm(LoginAndSignupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Reset Password',
            style: TextStyle(
              color: CustomColors.secondaryBrown,
              fontFamily: "OutfitMedium",
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        TextFieldComponent(
          labelText: 'Email',
          controller: emailController,
        ),
        const SizedBox(height: 20.0),
        TextFieldComponent(
          labelText: 'New Password',
          controller: newPasswordController,
        ),
        const SizedBox(height: 20.0),
        TextFieldComponent(
          labelText: 'Confirm Password',
          controller: confirmPasswordController,
        ),
        const SizedBox(height: 20.0),
        provider.isLoading
            ? CircularProgressIndicator()
            : AuthButton(
                buttonText: 'Confirm',
                onPressed: () async {
                  final email = emailController.text.trim();
                  final newPassword = newPasswordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (newPassword.isEmpty || confirmPassword.isEmpty) {
                    commonToast('Please fill in all fields');
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    commonToast('Passwords do not match');
                    return;
                  }
                  await provider.requestOtp(email);

                  setState(() {
                    showOtpSection = true;
                    showForgotPassword = false;
                  });
                },
              ),
        const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              setState(() {
                showForgotPassword = false;
              });
            },
            child: const Text(
              'Back to Login',
              style: TextStyle(
                color: CustomColors.primaryWhite,
                fontFamily: "OutfitRegular",
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpSection(LoginAndSignupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20.0),
        Center(
          child: Text(
            'A password reset code has been sent to ${emailController.text}. Enter it here to confirm your new password!',
            style: const TextStyle(
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
        provider.isLoadingOtp
            ? CircularProgressIndicator()
            : AuthButton(
                buttonText: 'Verify OTP',
                onPressed: () async {
                  final otp = otpControllers
                      .map((controller) => controller.text)
                      .join();
                  final email = emailController.text.trim();

                  if (otp.length != 6) {
                    commonToast('Please enter a valid 6-digit OTP');
                    return;
                  }

                  final success = await provider.verifyOtp(email, otp, context);
                  if (success) {
                    setState(() {
                      showOtpSection = false;
                      showSuccessMessage = true;
                    });
                  }
                },
              ),
      ],
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20.0),
        const Center(
          child: Text(
            'Password reset successful! Please log in with your new password.',
            style: TextStyle(
              color: CustomColors.secondaryBrown,
              fontFamily: "OutfitRegular",
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 30.0),
        AuthButton(
          buttonText: 'Back to Login',
          onPressed: () {
            setState(() {
              showSuccessMessage = false;
            });
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
          fontWeight: FontWeight.bold,
          fontSize: 18,
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
