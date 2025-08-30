import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'screens/scan_qr.dart';
import 'screens/history_screen.dart';

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
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GNav(
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800,
                gap: 8,
                selectedIndex: myIndex,
                onTabChange: (index) {
                  setState(() {
                    myIndex = index;
                  });
                },
                padding: const EdgeInsets.all(16),
                tabs: const [
                  GButton(
                    icon: Icons.qr_code_scanner,
                    text: 'Scan',
                  ),
                  GButton(
                    icon: Icons.history,
                    text: 'History',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}