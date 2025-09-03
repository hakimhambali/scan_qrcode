import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/theme_config.dart';
import '../provider/theme_provider.dart';

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
        body: AppWidgets.gradientBackground(
          gradient: context.watch<ThemeProvider>().getLightGradient(context),
          child: Column(
            children: [
              AppWidgets.gradientAppBar(
                title: 'Result Scan QR',
                automaticallyImplyLeading: true,
                centerTitle: true,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  widget.result,
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: context.watch<ThemeProvider>().getTextColor(context),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 19,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                          ? AppColors.lightBlue.withOpacity(0.4)
                          : AppColors.lightBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: Icon(Icons.content_copy, color: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                                ? AppColors.lightBlue
                                : AppColors.primaryBlue, size: 28),
                        onPressed: () async {
                        await FlutterClipboard.copy(widget.result);
                        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('✓   Copied to Clipboard', style: TextStyle(color: Colors.white))),
                        );
                      }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                          ? AppColors.lightBlue.withOpacity(0.4)
                          : AppColors.lightBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: Icon(Icons.search, color: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                                ? AppColors.lightBlue
                                : AppColors.primaryBlue, size: 28),
                        onPressed: () {
                        print('widget.result: ${widget.result}');
                        var url = Uri.parse(widget.result);
                        launchURL(url);
                      }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                          ? AppColors.lightBlue.withOpacity(0.4)
                          : AppColors.lightBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: Icon(Icons.share, color: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                                ? AppColors.lightBlue
                                : AppColors.primaryBlue, size: 28),
                        onPressed: () {
                          Share.share(widget.result);
                        }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Copy', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('Visit', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('Share', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
                    ],
                  ),
                ),
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
