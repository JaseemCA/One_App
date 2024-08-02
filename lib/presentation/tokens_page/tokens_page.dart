import 'package:flutter/material.dart';
import 'package:oneappcounter/common/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/tab_bar/custom_tab_bar.dart';

class TokensPage extends StatefulWidget {
  const TokensPage({super.key});

  @override
  State<TokensPage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TokensPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Appcolors.appcolor,
          title: const Text(
            "Tokens",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          bottom: const CustomTabBar(
            alignment: TabAlignment.start,
            tabCount: 5,
            tabLabels: [
              "TO CALL",
              "CALLED",
              "HOLDED TOKEN",
              "CANCELLED",
              "HOLDED QUEUE"
            ],
            isScrolable: true,
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('No Data!')),
            Center(child: Text('No Data!')),
            Center(child: Text('No Data!')),
            Center(child: Text('No Data!')),
            Center(child: Text('No Data!')),
          ],
        ),
      ),
    );
  }
}
