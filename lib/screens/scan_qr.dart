import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool torchOn = false;
  CameraFacing facing = CameraFacing.back;
  bool isProcessing = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔑 Make sure controller is passed here
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!isProcessing) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    debugPrint('Barcode found! ${barcode.rawValue}');
                    onQRDetected(barcode.rawValue!);
                    break;
                  }
                }
              }
            },
          ),
          // Scanner overlay with clear center and dark edges
          CustomPaint(
            painter: ScannerOverlay(
              scanArea: 250,
              borderColor: Colors.white,
            ),
            child: Container(),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical:8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Torch
                  IconButton(
                    color: Colors.white,
                    icon: Icon(torchOn ? Icons.flash_on : Icons.flash_off),
                    onPressed: () async {
                      await cameraController.toggleTorch();
                      setState(() => torchOn = !torchOn);
                    },
                  ),
                  const SizedBox(width: 20),

                  // Switch camera
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.cameraswitch),
                    onPressed: () async {
                      await cameraController.switchCamera();
                      setState(() {
                        facing = (facing == CameraFacing.back)
                            ? CameraFacing.front
                            : CameraFacing.back;
                      });
                    },
                  ),
                  const SizedBox(width: 20),

                  // Pick from gallery
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.image),
                    onPressed: pickImageAndScan,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

    await createScanQRHistory(
        originalLink: code,
        newLink: code,
        date: DateTime.now().toString());

    await cameraController.stop();
    
    if (!mounted) return;
    
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

  Future<void> createScanQRHistory({
    required String originalLink, 
    required String newLink, 
    required String date
  }) async {
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

  void pickImageAndScan() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (pickedImage == null) return;
      
      // Analyze the image using mobile_scanner
      final BarcodeCapture? barcodes = await cameraController.analyzeImage(
        pickedImage.path,
      );
      
      if (barcodes != null && barcodes.barcodes.isNotEmpty) {
        for (final barcode in barcodes.barcodes) {
          if (barcode.rawValue != null) {
            await createScanQRHistory(
              originalLink: barcode.rawValue!,
              newLink: barcode.rawValue!,
              date: DateTime.now().toString(),
            );
            
            await cameraController.stop();
            
            if (!mounted) return;
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScanQR(
                  result: barcode.rawValue!,
                  onPop: (resume) {
                    setState(() {
                      isProcessing = false;
                    });
                    cameraController.start();
                  },
                ),
              ),
            );
            break;
          }
        }
      } else {
        if (!mounted) return;
        
        PanaraInfoDialog.show(
          context,
          title: "Unable to detect QR code",
          message: 'Are you sure you uploaded the correct QR code file? Please try again.',
          buttonText: "Close",
          onTapDismiss: () {
            Navigator.pop(context);
          },
          panaraDialogType: PanaraDialogType.error,
          barrierDismissible: false,
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      
      if (!mounted) return;
      
      PanaraInfoDialog.show(
        context,
        title: "Error",
        message: 'Failed to pick image. Please try again.',
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