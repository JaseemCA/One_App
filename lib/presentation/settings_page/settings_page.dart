import 'package:flutter/material.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final alertTimeController = TextEditingController();
  final uidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Appcolors.bottomsheetDarkcolor
            : Appcolors.appBackgrondcolor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          value: 'service1',
                          child: Text('Service 1'),
                        ),
                        DropdownMenuItem(
                          value: 'service2',
                          child: Text('Service 2'),
                        ),
                      ],
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        labelText: "Transfer Service",
                        hintText: "Transfer Service",
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'es',
                          child: Text('Spanish'),
                        ),
                      ],
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        labelText: "Language",
                        hintText: "Language",
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              buildGeneralCard(),
              buildSideMenuCard(),
              buildButtonsCard(),
              buildGridViewCard(),
              buildMiscellaneousCard(),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: uidController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Enter UID'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('APPLY'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Version 1.0.0'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGeneralCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'General',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Recall Unhold Token?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Alert Transfer',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    'Alert Time (in seconds)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter time',
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Require Transfer Service?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Notification?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Notification Sound?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Show Token Priority?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSideMenuCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Navigation Menu',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Navigation Menu (Token and Appointment)?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Next to Call',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Today Appointments',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Called',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Served',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Served & Transferred',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Holded Tokens',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Holded Queue',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Cancelled',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Hide Cancelled Appointments',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonsCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Buttons',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Always disable Serve',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Always disable Recall',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Always disable No Show',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Always disable Call Next',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Always disable Hold',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Never show Service Hold',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridViewCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Grid View',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Enable Grid View',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Show NOT Transferred in No Show Section',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Show Holded in No Show Section',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Goto Grid View after Serving',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Goto Grid View after Transferring',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Goto Grid View after No Show',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Goto Grid View after Hold',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMiscellaneousCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Miscellaneous',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Pinned Application?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Prevent Screenlock?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Full screen?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null, // UI only, no functionality
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Multiple Transfer?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null, // UI only, no functionality
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Concurrent transfer?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Switch(
                    value: false,
                    onChanged: null, // UI only, no functionality
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
