import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/scan_qr.dart';
import 'screens/history_screen.dart';
import 'configs/theme_config.dart';
import 'provider/theme_provider.dart';

class NavigationWrapper extends StatefulWidget {
  final int initialIndex;
  
  const NavigationWrapper({super.key, this.initialIndex = 0});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late int myIndex;
  
  List<Widget> widgetList = [
    const ScanQR(),
    const HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    myIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[myIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
              ? AppColors.darkGradient
              : AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                  ? Colors.black26
                  : Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.textOnGradient,
          unselectedItemColor: context.watch<ThemeProvider>().themeMode == ThemeMode.dark
              ? Colors.white60
              : Colors.white70,
          currentIndex: myIndex,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}