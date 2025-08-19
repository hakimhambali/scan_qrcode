import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:scan_qrcode/screens/scan_qr.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final controller = TextEditingController();
  bool validate = true;

  bool nightMode = false;
  IconData iconDay = Icons.sunny;
  IconData iconNight = Icons.mode_night;

  ThemeData dayTheme =
      ThemeData(primarySwatch: Colors.amber, brightness: Brightness.light);
  ThemeData nightTheme =
      ThemeData(primarySwatch: Colors.purple, brightness: Brightness.dark);

  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: nightMode ? nightTheme : dayTheme,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.purple.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Scan QR'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(nightMode ? iconNight : iconDay),
            //   onPressed: () {
            //     setState(() {
            //       nightMode = !nightMode;
            //     });
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.info),
            //   onPressed: () async {
            //     AwesomeDialog(
            //       context: context,
            //       animType: AnimType.scale,
            //       dialogType: DialogType.noHeader,
            //       body: SizedBox(
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.all(20.0),
            //               child: Column(
            //                 children: [
            //                   const Text('Feature of Scan QR is: \n\n',
            //                       style: TextStyle(fontSize: 20)),
            //                   new Align(
            //                       alignment: Alignment.centerLeft,
            //                       child: new Text(
            //                           '1. Scan QR: Scan QR code to links\n',
            //                           style: TextStyle(fontSize: 16))),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       title: 'This is Ignored',
            //       desc: 'This is also Ignored',
            //       btnOkOnPress: () {},
            //     )..show();
            //   },
            // ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 132.0,
                              height: 40.0,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.purple.shade900), foregroundColor: MaterialStateProperty.all(
                              Colors.white)),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ScanQR()));
                                },
                                child: const Text('Scan QR'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future createGenerateQRHistory(
      {required String originalLink, newLink, required String date}) async {
    final historyUser = FirebaseFirestore.instance.collection('history').doc();
    final json = {
      'docID': historyUser.id,
      'originalLink': originalLink,
      'newLink': newLink,
      'date': date,
      'type': "Generate QR",
      'userID': FirebaseAuth.instance.currentUser!.uid.toString()
    };
    await historyUser.set(json);
  }
}
