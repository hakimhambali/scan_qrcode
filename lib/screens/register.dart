import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scan_qrcode/screens/forgot_password.dart';
import 'package:scan_qrcode/screens/login.dart';
import 'package:scan_qrcode/screens/signingoogle.dart';
import 'package:scan_qrcode/services/data_merger.dart';
import '../configs/theme_config.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkEmail = true;
  bool checkPassword = true;
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppWidgets.gradientBackground(
        gradient: AppColors.lightGradient,
        child: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logoNoBg.png', scale: 3.5),
              Text(
                'Scan QR',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, snapshot) {
                    if (FirebaseAuth.instance.currentUser == null) {
                      return const Text("You haven't signed in yet");
                    } else {
                      if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                        return const Text("You haven't signed in yet");
                      } else {
                        return Text('SIGNED IN ${snapshot.data?.email}');
                      }
                    }
                  }),
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
                      checkEmail = validateEmail(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your email here',
                    hintText: 'example@gmail.com',
                    errorText: checkEmail ? null : "Please insert valid email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 15),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: !_passwordVisible,
                  cursorColor: Colors.purple,
                  onChanged: (value) {
                    setState(() {
                      checkPassword = validatePassword(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter your password here',
                    hintText: '*********',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    errorText:
                        checkPassword ? null : "Please insert valid password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, right: 20),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryBlue,
                    ),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppWidgets.gradientButton(
                    text: "Register",
                    width: 300,
                    height: 40,
                    onPressed: () async {
                          checkEmail = validateEmail(emailController.text);
                          checkPassword =
                              validatePassword(passwordController.text);
                          setState(() {});

                          // Check if fields are empty before attempting registration
                          if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                            showNotification(context, 'Please fill in both email and password fields to register.');
                            return;
                          }

                          // Check if email and password are valid
                          if (!checkEmail || !checkPassword) {
                            showNotification(context, 'Please enter a valid email and password. Your email should look like this: example@gmail.com. Your password must be at least 8 characters long and include an uppercase letter, a lowercase letter, a number, and a special character');
                            return;
                          }

                          try {
                            if (FirebaseAuth
                                .instance.currentUser!.isAnonymous) {
                              // Store anonymous user ID before linking
                              final anonymousUserId = FirebaseAuth.instance.currentUser!.uid;
                              
                              var credential = EmailAuthProvider.credential(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());
                              await FirebaseAuth.instance.currentUser!
                                  .linkWithCredential(credential)
                                  .then((user) {
                                ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          'Successfully registered using email')),
                                );
                                Navigator.pop(context);
                                return user;
                              });
                              
                              // Clean up any remaining anonymous data (shouldn't be needed for linking, but just in case)
                              await DataMerger.deleteAnonymousAccount(anonymousUserId);
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Logout ?"),
                                    content: const Text('Are you sure want to logout ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          FirebaseAuth.instance.signOut();
                                          FirebaseAuth.instance.signInAnonymously();
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String userFriendlyMessage = getFirebaseErrorMessage(e.code);
                            showNotification(context, userFriendlyMessage);
                          } catch (e) {
                            String errorMessage = e.toString();
                            String userFriendlyMessage = getFirebaseErrorMessage(errorMessage);
                            showNotification(context, userFriendlyMessage);
                          }
                        },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: const Text("Already have an account ?  ")),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: GestureDetector(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryBlue,
                            ),
                          ),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const Text("OR"),
                  const SizedBox(
                    height: 10,
                  ),
                  AppWidgets.gradientButton(
                    text: 'Sign In With Google Account',
                    width: 300,
                    height: 40,
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInGoogle()));
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

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(
        backgroundColor: Colors.red, content: Text(message.toString())));
  }

  String getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password with at least 8 characters including uppercase, lowercase, numbers and special characters.';
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or try logging in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Registration is currently disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'credential-already-in-use':
        return 'This email is already linked to another account.';
      case 'provider-already-linked':
        return 'This email is already linked to your account.';
      case 'invalid-credential':
        return 'The provided credentials are invalid. Please check your email and password.';
      default:
        if (errorCode.contains('linkWithCredential') || errorCode.contains('FirebaseAuth')) {
          return 'Please fill in both email and password fields to register.';
        }
        return 'Registration failed. Please check your email and password and try again.';
    }
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

  bool validatePassword(String password) {
    if (RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z]).{8,}$')
        .hasMatch(password)) {
      return true;
    } else {
      return false;
    }
  }
}
