import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:oneappcounter/common/color/appcolors.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime dateTime = DateTime.now();
  String selectedTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 180,
        backgroundColor: Appcolors.appcolor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SvgPicture.asset(
            "assets/images/logoWhite.svg",
            height: 130,
            width: 130,
          ),
        ),
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.lock,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              _showBottomSheet();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(70, 0, 0, 0),
                items: [
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'theme',
                    child: ListTile(
                      leading: const Icon(Icons.mode_night_outlined),
                      title: const Text('Theme'),
                      onTap: () {
                        Navigator.pop(context); // Close the menu
                        _showThemeDialog(); // Show the theme selection dialog
                      },
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                // Handle the selected menu option
                if (value != null) {
                  switch (value) {
                    case 'settings':
                      // Navigate to settings
                      // print('Settings selected');
                      break;
                    case 'theme':
                      // Change theme
                      // print('Theme selected');
                      break;
                    case 'logout':
                      // Perform logout
                      // print('Logout selected');
                      break;
                  }
                }
              });
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("home"),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              height: 420,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hold Service',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Message',
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _showTimePicker,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10)),
                    child: Text(
                      "Expected Ending Time:$selectedTime",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Appcolors.buttoncolor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomElevatedButton(
                      text: "HOLD",
                      onPressed: () {
                        // Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTimePicker() {
    DateTime adjustedDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      (dateTime.minute ~/ 10) * 10,
    );

    return SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        initialDateTime: adjustedDateTime,
        mode: CupertinoDatePickerMode.time,
        minuteInterval: 1,
        onDateTimeChanged: (dateTime) =>
            setState(() => this.dateTime = dateTime),
      ),
    );
  }

  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Done'),
            onPressed: () {
              setState(() {
                selectedTime = DateFormat('hh:mm a').format(dateTime);
              });
              Navigator.pop(context);
              // selectedTime = DateFormat('hh:mm a').format(dateTime);
            },
          ),
        ],
        cancelButton: CupertinoButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        message: buildTimePicker(),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Theme'),
          children: [
            ListTile(
              title: const Text('Light'),
              leading: Radio(
                value: ThemeMode.light,
                onChanged: (ThemeMode? mode) {
                 
                  Navigator.pop(context);
                },
                groupValue: Theme.of(context).brightness == Brightness.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
              ),
            ),
            ListTile(
              title: const Text('Dark'),
              leading: Radio(
                value: ThemeMode.dark,
                onChanged: (ThemeMode? mode) {
                  // Handle theme change
                  Navigator.pop(context);
                },
                groupValue: Theme.of(context).brightness == Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
              ),
            ),
            ListTile(
              title: const Text('System'),
              leading: Radio(
                value: ThemeMode.system,
                onChanged: (ThemeMode? mode) {
                  // Handle theme change
                  Navigator.pop(context);
                },
                groupValue: Theme.of(context).brightness == Brightness.light
                    ? ThemeMode.system
                    : ThemeMode.dark,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
