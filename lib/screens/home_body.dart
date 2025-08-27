import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          ],
        ),
        body: Center(
          child: SizedBox(
            width: 132.0,
            height: 40.0,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)
                  )
                ),
                backgroundColor: MaterialStateProperty.all(Colors.purple.shade900),
                foregroundColor: MaterialStateProperty.all(Colors.white)
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanQR()
                  )
                );
              },
              child: const Text('Scan QR'),
            ),
          ),
        ),
      ),
    );
  }
}