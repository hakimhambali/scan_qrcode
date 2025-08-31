import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scan_qrcode/screens/forgot_password.dart';
import 'package:scan_qrcode/screens/signingoogle.dart';
import 'package:scan_qrcode/services/data_merger.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkEmail = true;
  bool checkPassword = true;
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logoSplashScreen.png', scale: 3.5),
              Text(
                'Scan QR',
                style:
                    GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
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
                  cursorColor: Colors.orange,
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
                  cursorColor: Colors.orange,
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
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold),
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
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade900), foregroundColor: MaterialStateProperty.all(
                              Colors.white)),
                        onPressed: () async {
                          checkEmail = validateEmail(emailController.text);
                          checkPassword =
                              validatePassword(passwordController.text);
                          setState(() {});

                          // Check if fields are empty before attempting login
                          if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                            showNotification(context, 'Please fill in both email and password fields to login.');
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
                              
                              // Store anonymous user info before signing in
                              final anonymousUserId = FirebaseAuth.instance.currentUser!.uid;
                              final anonymousHistoryCount = await DataMerger.getAnonymousHistoryCount();
                              
                              // Show loading dialog if we have data to merge
                              if (anonymousHistoryCount > 0) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16),
                                        Text('Signing in and merging data...', 
                                             style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              
                              try {
                                // Sign in to target account
                                UserCredential credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim());
                                
                                final targetUserId = credential.user!.uid;
                                
                                // Merge anonymous data if exists
                                int mergedCount = 0;
                                if (anonymousHistoryCount > 0) {
                                  mergedCount = await DataMerger.mergeAnonymousDataToExistingAccount(anonymousUserId, targetUserId);
                                }
                                
                                // Clean up anonymous account data
                                await DataMerger.deleteAnonymousAccount(anonymousUserId);
                                
                                // Close loading dialog if shown
                                if (anonymousHistoryCount > 0 && Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                                
                                String message;
                                if (mergedCount > 0) {
                                  message = 'Successfully logged in and merged $mergedCount new history items';
                                } else if (anonymousHistoryCount > 0) {
                                  message = 'Successfully logged in. All your history items were already in this account';
                                } else {
                                  message = 'Successfully logged in using email';
                                }
                                
                                ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(message)),
                                );
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                    
                              } catch (e) {
                                // Close loading dialog
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                                rethrow;
                              }
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
                        child: StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.userChanges(),
                            builder: (context, snapshot) {
                              if (FirebaseAuth.instance.currentUser == null) {
                                return const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                if (FirebaseAuth
                                    .instance.currentUser!.isAnonymous) {
                                  return const Text("Login");
                                } else {
                                  return const Text("Logout");
                                }
                              }
                            })),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: const Text("Don't have an account ?  ")),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: GestureDetector(
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.orange.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const Text("OR"),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.black), foregroundColor: MaterialStateProperty.all(
                              Colors.white)),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInGoogle()));
                      },
                      child: const Text('Sign In With Google Account'),
                    ),
                  ),
                ],
              ),
            ],
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
      case 'user-not-found':
        return 'No account found with this email. Please check your email or create a new account.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many login attempts. Please wait a moment and try again.';
      case 'operation-not-allowed':
        return 'Email login is currently disabled. Please contact support.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      default:
        if (errorCode.contains('signInWithEmailAndPassword') || errorCode.contains('FirebaseAuth')) {
          return 'Please fill in both email and password fields to login.';
        }
        return 'Login failed. Please check your email and password and try again.';
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
