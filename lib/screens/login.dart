import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:scan_qrcode/screens/forgot_password.dart';
import 'package:scan_qrcode/screens/signingoogle.dart';
import 'package:scan_qrcode/screens/signinphonenumber.dart';

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
                    hintText: 'ahmadalbab99@gmail.com',
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

                          try {
                            if (FirebaseAuth
                                .instance.currentUser!.isAnonymous) {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                              ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    content:
                                        Text('Successfully login using email')),
                              );
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } else {
                              PanaraConfirmDialog.show(
                                context,
                                title: "Logout ?",
                                message: 'Are you sure want to logout ?',
                                confirmButtonText: "Yes",
                                cancelButtonText: "No",
                                onTapCancel: () {
                                  Navigator.pop(context);
                                },
                                onTapConfirm: () {
                                  Navigator.pop(context);
                                  FirebaseAuth.instance.signOut();
                                  FirebaseAuth.instance.signInAnonymously();
                                },
                                panaraDialogType: PanaraDialogType.error,
                                barrierDismissible: false,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            showNotification(context, e.message.toString());
                          } catch (e) {
                            ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Invalid Login')),
                            );
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
                  // SizedBox(
                  //   width: 300,
                  //   child: ElevatedButton(
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all(
                  //             Colors.black), foregroundColor: MaterialStateProperty.all(
                  //             Colors.white)),
                  //     onPressed: () async {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const SignInPhoneNumber()));
                  //     },
                  //     child: const Text('Sign In With Phone Number'),
                  //   ),
                  // ),
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
