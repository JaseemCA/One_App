import 'package:flutter/material.dart';
import 'package:oneappcounter/common/color/appcolors.dart';
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Appcolors.appcolor,
        title: const Text(
          "Service Tabs",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Appcolors.buttoncolor,
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
