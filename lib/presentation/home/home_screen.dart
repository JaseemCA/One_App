import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';

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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // final Color backgroundColor = isDarkMode
    // ? Appcolors.bottomsheetDarkcolor
    // : Appcolors.appBackgrondcolor;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leadingWidth: 180,
        backgroundColor: isDarkMode
            ? Appcolors.bottomsheetDarkcolor
            : Appcolors.appBackgrondcolor,
        leading: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: OneAppLogo(
              height: 30,
            )),
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
                  const PopupMenuItem<String>(
                    value: 'theme',
                    child: ListTile(
                      leading: Icon(Icons.mode_night_outlined),
                      title: Text('Theme'),
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
                if (value == 'theme') {
                  _showThemeDialog();
                }
                // Handle other menu options
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
              color: isDarkMode ? Appcolors.bottomsheetDarkcolor : Colors.white,
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
                        backgroundColor: isDarkMode
                            ? Appcolors.bottomsheetDarkcolor
                            : Colors.white,
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
                      "Expected Ending Time: $selectedTime",
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode
                            ? Appcolors.materialIconButtonDark
                            : Appcolors.buttonColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomElevatedButton(
                      text: "HOLD",
                      onPressed: () {
                        // Add your logic here
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
        final currentThemeMode = context.read<ThemeCubit>().state;
        return SimpleDialog(
          title: const Text('Theme'),
          children: [
            ListTile(
              onTap: () {
                context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                Navigator.pop(context);
              },
              title: const Text('Light'),
              leading: Radio(
                value: ThemeMode.light,
                groupValue: currentThemeMode,
                onChanged: (ThemeMode? mode) {
                  context.read<ThemeCubit>().updateTheme(mode!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              onTap: () {
                context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                Navigator.pop(context);
              },
              title: const Text('Dark'),
              leading: Radio(
                value: ThemeMode.dark,
                groupValue: currentThemeMode,
                onChanged: (ThemeMode? mode) {
                  context.read<ThemeCubit>().updateTheme(mode!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              onTap: () {
                context.read<ThemeCubit>().updateTheme(ThemeMode.system);
                Navigator.pop(context);
              },
              title: const Text('System'),
              leading: Radio(
                value: ThemeMode.system,
                groupValue: currentThemeMode,
                onChanged: (ThemeMode? mode) {
                  context.read<ThemeCubit>().updateTheme(mode!);
                  Navigator.pop(context);
                },
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
