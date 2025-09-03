import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configs/theme_config.dart';
import '../provider/theme_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool validate = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppWidgets.gradientBackground(
        gradient: context.watch<ThemeProvider>().getLightGradient(context),
        child: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan QR',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: context.watch<ThemeProvider>().getTextColor(context),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Please check your email after clicking 'Reset Password'. We will send you the link to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.watch<ThemeProvider>().getTextColor(context),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 25, 30, 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: emailController,
                  cursorColor: Colors.purple,
                  onChanged: (value) {
                    setState(() {
                      validate = validateEmail(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your email here',
                    hintText: 'example@gmail.com',
                    errorText: validate ? null : "Please insert valid email",
                    filled: true,
                    fillColor: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                        ? AppColors.darkCardBackground
                        : Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppWidgets.gradientButton(
                    text: "Reset Password",
                    width: 300,
                    height: 40,
                    onPressed: () async {
                        // Validate email first
                        if (emailController.text.trim().isEmpty) {
                          showNotification(context, 'Please enter your email address');
                          return;
                        }
                        
                        validate = validateEmail(emailController.text.trim());
                        setState(() {});
                        
                        if (!validate) {
                          showNotification(context, 'Please enter a valid email address');
                          return;
                        }
                        
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text.trim());
                          ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    'Password reset email sent! Please check your email (including spam folder)',
                                    style: const TextStyle(color: Colors.white))),
                          );
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          String errorMessage = getPasswordResetErrorMessage(e.code);
                          showNotification(context, errorMessage);
                        } catch (e) {
                          showNotification(context, 'An unexpected error occurred. Please try again.');
                        }
                      },
                  ),
                ],
              ),
            ],
          ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    if (RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(message.toString(), style: const TextStyle(color: Colors.white))));
  }

  String getPasswordResetErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address. Please check your email or create a new account.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in instead.';
      case 'operation-not-allowed':
        return 'Password reset is currently disabled. Please contact support.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'auth/captcha-check-failed':
      case 'captcha-check-failed':
        return 'Security verification failed. Please try again or use a different device/network.';
      case 'auth/missing-recaptcha-token':
      case 'missing-recaptcha-token':
        return 'Security verification required. Please try again or contact support if the issue persists.';
      default:
        return 'Password reset failed. Please try again or contact support if the issue persists.';
    }
  }
}
