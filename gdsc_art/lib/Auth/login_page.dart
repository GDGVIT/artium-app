import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:artium/Auth/AuthUICompnents/login_signup_toggle.dart';
import 'package:artium/Auth/AuthUICompnents/auth_btn.dart';
import 'package:artium/Auth/AuthUICompnents/text_feild_component.dart';
import 'package:artium/Constants/Colors.dart';
import 'package:artium/Constants/common_toast.dart';
import 'package:artium/Providers/login_and_signup_provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback toggleView;

  const LoginPage({super.key, required this.toggleView});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();

  bool showForgotPassword = false;
  bool showOtpSection = false;
  bool showSuccessMessage = false;

  bool _obscurePassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginAndSignupProvider>(context);

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
                      isLogin: true, toggleView: widget.toggleView),
                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(LoginAndSignupProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                TextFieldComponent(
                  labelText: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
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
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
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
          ),
          if (provider.isLoading)
            const CircularProgressIndicator()
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: AuthButton(
                buttonText: 'Login',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final loginData = {
                      'email': emailController.text,
                      'password': passwordController.text,
                    };
                    provider.userlog(loginData, context);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordForm(LoginAndSignupProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  color: CustomColors.primaryWhite,
                  fontFamily: "OutfitMedium",
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                TextFieldComponent(
                  labelText: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFieldComponent(
                  labelText: 'New Password',
                  controller: newPasswordController,
                  obscureText: _obscureNewPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: CustomColors.primaryWhite,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFieldComponent(
                  labelText: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: CustomColors.primaryWhite,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          provider.isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: AuthButton(
                    buttonText: 'Confirm',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        await provider.requestOtp(email);

                        setState(() {
                          showOtpSection = true;
                          showForgotPassword = false;
                        });
                      }
                    },
                  ),
                ),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
          ),
        ],
      ),
    );
  }

  Widget _buildOtpSection(LoginAndSignupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20.0),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Text(
              'A password reset code has been sent to ${emailController.text}. Enter it here to confirm your new password!',
              style: const TextStyle(
                color: CustomColors.primaryWhite,
                fontFamily: "OutfitRegular",
                fontSize: 16,
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
        if (provider.isLoadingOtp)
          const CircularProgressIndicator()
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: AuthButton(
              buttonText: 'Verify OTP',
              onPressed: () async {
                final otp =
                    otpControllers.map((controller) => controller.text).join();
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
      child: TextFormField(
        controller: otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          if (!RegExp(r'^[0-9]$').hasMatch(value)) {
            return '';
          }
          return null;
        },
        style: const TextStyle(
          color: CustomColors.primaryWhite,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
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
