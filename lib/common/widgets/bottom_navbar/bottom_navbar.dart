import 'package:flutter/material.dart';
import 'package:oneappcounter/presentation/appointments_page/appointments_page.dart';
import 'package:oneappcounter/presentation/home/home_screen.dart';
import 'package:oneappcounter/presentation/service_tabs_page/service_tab.dart';
import 'package:oneappcounter/presentation/tokens_page/tokens_page.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          AppointmentsPage(),
          HomeScreen(),
          TokensPage(),
          ServiceTabs(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: TabBar(
          controller: _tabController,
          indicator: const BoxDecoration(),
          onTap: (index) {
            setState(() {});
          },
          tabs: [
            _buildTab(0, Icons.calendar_today, 'Appointments'),
            _buildTab(1, Icons.home, 'Home'),
            _buildTab(2, Icons.assignment_outlined, 'Tokens'),
            _buildTab(3, Icons.backup_table_sharp, 'Tabs'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String text) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            size: isSelected ? 30 : 24,
          ),
          if (isSelected)
            Text(
              text,
              style: TextStyle(
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
                fontSize: 9,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
