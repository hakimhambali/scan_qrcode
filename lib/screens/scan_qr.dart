import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' as mlkit;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import 'result_scan_qr.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;

  bool imageLabelChecking = false;
  XFile? imageFile;
  String imageLabel = "";

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Start camera when screen loads
    cameraController.start();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQRView(context),
              Positioned(top: 10, child: buildControlButtons()),
              // Custom overlay since MobileScanner doesn't have overlay parameter
              CustomPaint(
                size: Size.infinite,
                painter: ScannerOverlay(
                  scanArea: MediaQuery.of(context).size.width * 0.8,
                  borderColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildQRView(BuildContext context) => MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          if (!isProcessing) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                onQRDetected(barcode.rawValue!);
                break;
              }
            }
          }
        },
      );

  void onQRDetected(String code) async {
    if (isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    createScanQRHistory(
        originalLink: code,
        newLink: code,
        date: DateTime.now().toString());

    await cameraController.stop();
    
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultScanQR(
              result: code,
              onPop: (resume) {
                setState(() {
                  isProcessing = false;
                });
                cameraController.start();
              })),
    );
    
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Successfully Scan QR')),
      );
  }

  Widget buildControlButtons() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.white),
              onPressed: () async {
                await cameraController.toggleTorch();
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.switch_camera, color: Colors.white),
              onPressed: () async {
                await cameraController.switchCamera();
                setState(() {});
              },
            ),
            IconButton(
              icon: const Icon(Icons.image, color: Colors.white),
              onPressed: () {
                getImage();
              },
            ),
          ],
        ),
      );

  Future createScanQRHistory(
      {required String originalLink, newLink, required String date}) async {
    final historyUser = FirebaseFirestore.instance.collection('history').doc();
    final json = {
      'docID': historyUser.id,
      'originalLink': originalLink,
      'newLink': newLink,
      'date': date,
      'type': "Scan QR",
      'userID': FirebaseAuth.instance.currentUser!.uid.toString()
    };
    await historyUser.set(json);
  }

  void getImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        imageLabelChecking = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedQR(pickedImage);
      }
    } catch (e) {
      imageLabelChecking = false;
      imageFile = null;
      setState(() {});
    }
  }

  void getRecognisedQR(XFile image) async {
    final inputImage = mlkit.InputImage.fromFilePath(image.path);
    final List<mlkit.BarcodeFormat> formats = [mlkit.BarcodeFormat.all];
    final barcodeScanner = mlkit.BarcodeScanner(formats: formats);
    final List<mlkit.Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);

    if (barcodes.isNotEmpty) {
      for (mlkit.Barcode barcode in barcodes) {
        if (barcode.displayValue != null) {
          createScanQRHistory(
              originalLink: barcode.displayValue!,
              newLink: barcode.displayValue!,
              date: DateTime.now().toString());
          
          await cameraController.stop();
          
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultScanQR(
                      result: barcode.displayValue!,
                      onPop: (resume) {
                        setState(() {
                          isProcessing = false;
                        });
                        cameraController.start();
                      })));
          break;
        }
      }
    } else {
      PanaraInfoDialog.show(
        context,
        title: "Unable to detect QR code",
        message:
            'Are you sure upload the correct QR code file ? or please try again',
        buttonText: "Close",
        onTapDismiss: () {
          Navigator.pop(context);
        },
        panaraDialogType: PanaraDialogType.error,
        barrierDismissible: false,
      );
    }
  }
}

// Custom overlay painter for the scanner
class ScannerOverlay extends CustomPainter {
  final double scanArea;
  final Color borderColor;

  ScannerOverlay({required this.scanArea, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: scanArea,
            height: scanArea,
          ),
          const Radius.circular(10),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(backgroundWithCutout, Paint()..color = Colors.black.withOpacity(0.5));

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final borderRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: scanArea,
        height: scanArea,
      ),
      const Radius.circular(10),
    );

    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}