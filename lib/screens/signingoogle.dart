import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:scan_qrcode/services/data_merger.dart';
import '../configs/theme_config.dart';
import '../provider/theme_provider.dart';

class SignInGoogle extends StatelessWidget {
  const SignInGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppWidgets.gradientBackground(
        gradient: context.watch<ThemeProvider>().getLightGradient(context),
        child: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SIGN IN WITH GOOGLE ACCOUNT',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: context.watch<ThemeProvider>().getTextColor(context),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (FirebaseAuth.instance.currentUser == null) {
                    return Text(
                      "You haven't signed in yet",
                      style: TextStyle(
                        color: context.watch<ThemeProvider>().getTextColor(context),
                      ),
                    );
                  } else {
                    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
                      return Text(
                      "You haven't signed in yet",
                      style: TextStyle(
                        color: context.watch<ThemeProvider>().getTextColor(context),
                      ),
                    );
                    } else {
                      return Text(
                        'Signed in as ${FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown'} (${FirebaseAuth.instance.currentUser?.email ?? 'Unknown'})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.watch<ThemeProvider>().getTextColor(context),
                        ),
                      );
                    }
                  }
                }),
            const SizedBox(height: 15),
            AppWidgets.gradientButton(
              text: "Login",
              width: 150,
              height: 40,
                  onPressed: () async {
                    if (FirebaseAuth.instance.currentUser != null && 
                        FirebaseAuth.instance.currentUser!.isAnonymous) {
                      // Sign out from Google first to ensure clean state
                      try {
                        GoogleSignIn _googleSignIn = GoogleSignIn();
                        await _googleSignIn.disconnect();
                      } catch (e) {
                        print('Disconnect error (can be ignored): $e');
                      }
                      
                      // Show loading while signing in
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      
                      try {
                        // Sign in with Google
                        GoogleSignInAccount? account =
                            await GoogleSignIn().signIn();
                        
                        // Pop loading dialog
                        Navigator.pop(context);
                        
                        if (account != null) {
                          // Get authentication details
                          GoogleSignInAuthentication auth =
                              await account.authentication;
                          
                          // Create credential
                          OAuthCredential credential = 
                              GoogleAuthProvider.credential(
                                accessToken: auth.accessToken,
                                idToken: auth.idToken,
                              );
                          
                          try {
                            // Store anonymous user ID before linking
                            final anonymousUserId = FirebaseAuth.instance.currentUser!.uid;
                            
                            // Try to link with existing anonymous account
                            await FirebaseAuth.instance.currentUser!
                                .linkWithCredential(credential);
                            
                            // Clean up any remaining anonymous data (shouldn't be needed for linking, but just in case)
                            await DataMerger.deleteAnonymousAccount(anonymousUserId);
                            
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        'Successfully linked Google account',                                        style: const TextStyle(color: Colors.white))),
                              );
                            
                            // Navigate back to first route
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          } on FirebaseAuthException catch (e) {
                            // If linking fails (account already exists), handle data merging
                            if (e.code == 'credential-already-in-use' || 
                                e.code == 'email-already-in-use') {
                              
                              // Store anonymous user info before signing in
                              final anonymousUserId = FirebaseAuth.instance.currentUser!.uid;
                              final anonymousHistoryCount = await DataMerger.getAnonymousHistoryCount();
                              
                              try {
                                // Sign in to target account
                                UserCredential targetCredential = await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                                final targetUserId = targetCredential.user!.uid;
                                
                                // Merge anonymous data if exists
                                int mergedCount = 0;
                                if (anonymousHistoryCount > 0) {
                                  mergedCount = await DataMerger.mergeAnonymousDataToExistingAccount(anonymousUserId, targetUserId);
                                }
                                
                                // Clean up anonymous account data
                                await DataMerger.deleteAnonymousAccount(anonymousUserId);
                                
                                String message;
                                if (mergedCount > 0) {
                                  message = 'Successfully signed in with Google and merged $mergedCount new history items';
                                } else if (anonymousHistoryCount > 0) {
                                  message = 'Successfully signed in with Google. All your history items were already in this account';
                                } else {
                                  message = 'Successfully signed in with Google';
                                }
                                
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(message, style: const TextStyle(color: Colors.white))),
                                  );
                                
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              } catch (mergeError) {
                                // If merge fails, still try to sign in
                                await FirebaseAuth.instance.signInWithCredential(credential);
                                
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.orange,
                                        content: Text('Signed in but could not merge all data', style: const TextStyle(color: Colors.white))),
                                  );
                                
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }
                            } else {
                              throw e;
                            }
                          }
                        } else {
                          // User cancelled sign in
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.orange,
                                  content: Text('Sign in cancelled', style: const TextStyle(color: Colors.white))),
                            );
                        }
                      } catch (e) {
                        // Pop loading dialog if still showing
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Sign in failed: ${e.toString()}', style: const TextStyle(color: Colors.white))),
                          );
                        log('Sign in error: $e');
                      }
                    } else if (FirebaseAuth.instance.currentUser != null &&
                               !FirebaseAuth.instance.currentUser!.isAnonymous) {
                      // User is signed in, show logout dialog
                      showDialog(
                        context: context,
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
                                onPressed: () async {
                                  Navigator.pop(context);
                                  
                                  // Sign out from Firebase
                                  await FirebaseAuth.instance.signOut();
                                  
                                  // Sign out from Google
                                  try {
                                    await GoogleSignIn().disconnect();
                                  } catch (e) {
                                    print('Google disconnect error: $e');
                                  }
                          
                                  // Sign in anonymously again
                                  await FirebaseAuth.instance.signInAnonymously();
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
}