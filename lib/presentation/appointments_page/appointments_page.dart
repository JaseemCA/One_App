import 'package:flutter/material.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/tab_bar/custom_tab_bar.dart'; // Import the custom tab bar

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDarkMode
              ? Appcolors.bottomsheetDarkcolor
              : Appcolors.appBackgrondcolor,
          title: const Text(
            "Appointments",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          // Use the CustomTabBar here
          bottom: const CustomTabBar(
            alignment: TabAlignment.fill,
            tabCount: 2, // Number of tabs
            tabLabels: ["TODAY'S", "CANCELLED"],

            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('No Data!')),
            Center(child: Text('No Data!')),
          ],
        ),
      ),
    );
  }
}
