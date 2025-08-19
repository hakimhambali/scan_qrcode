import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScanQR extends StatefulWidget {
  final String result;
  final Function(bool) onPop;
  const ResultScanQR({
    Key? key,
    required this.result,
    required this.onPop,
  }) : super(key: key);

  @override
  State<ResultScanQR> createState() => _ResultScanQRState();
}

class _ResultScanQRState extends State<ResultScanQR> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        widget.onPop(true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.purple.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Link QR Scanner'),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                widget.result,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: const Icon(Icons.content_copy),
                      onPressed: () async {
                        await FlutterClipboard.copy(widget.result);
                        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                          const SnackBar(
                              content: Text('✓   Copied to Clipboard')),
                        );
                      }),
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        print('widget.result: ${widget.result}');
                        var url = Uri.parse(widget.result);
                        launchURL(url);
                      }),
                  IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Share.share(widget.result);
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('Copy'),
                  Text('Visit'),
                  Text('Share'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> launchURL(url) async {
    print('url: ${url}');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView, // uses WebView inside your app
      );
      return true;
    } else {
      return false;
    }
  }
}
