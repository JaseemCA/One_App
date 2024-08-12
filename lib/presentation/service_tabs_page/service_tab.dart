import 'package:flutter/material.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/bottomSheet/bottomsheet.dart';

class ServiceTabs extends StatefulWidget {
  const ServiceTabs({super.key});

  @override
  State<ServiceTabs> createState() => _ServiceTabsState();
}

class _ServiceTabsState extends State<ServiceTabs> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode
            ? Appcolors.bottomsheetDarkcolor
            : Appcolors.appBackgrondcolor,
        title: const Text(
          "Service Tabs",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet();
        },
        backgroundColor: isDarkMode
            ? Appcolors.materialIconButtonDark
            : Appcolors.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const BottomSheetContent(),
    );
  }
}
