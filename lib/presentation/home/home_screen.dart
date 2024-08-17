import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/presentation/settings_page/settings_page.dart';

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
                holdshowBottomSheet();
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
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const SettingsScreen()));
                        },
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
                    showThemeDialog();
                  }
                  // Handle other menu options
                });
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // Placeholder for refresh functionality
            // await refreshFunction(context);
          },
          child: Stack(
            children: [ListView(), buildNonGridScreen()],
          ),
        ));
  }

  void holdshowBottomSheet() {
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

  void showThemeDialog() {
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

  Widget buildNonGridScreen() {
    return Stack(
      children: [
        Column(
          children: [
            Column(
              children: [
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter tabsetState) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Services: ',
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Service Placeholder',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Counter: ',
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Counter Placeholder',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit_note,
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  );
                }),
                const Divider(),
              ],
            ),
            SizedBox(
              child: Column(
                children: [
                  Container(
                    child: buildTokenPart(),
                  ), // Placeholder for _buildTokenPart()
                  const Divider(
                    height: 40,
                  ), // kDivider replaced with Divider()
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                onPressed: () {}, // Disabled button
                                text: "SERVE",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                onPressed: () {}, // Disabled button
                                text: 'RECALL',
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                onPressed: () {}, // Disabled button
                                text: 'NO SHOW',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                onPressed: () {}, // Disabled button
                                text: 'CALL NEXT',
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                  onPressed: () {}, // Disabled button
                                  text: 'HOLD TOKEN'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 3.0,
                              ),
                              child: Text(
                                'Select Service to transfer',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    children: [
                      getTransferButtons(),
                    ], // Placeholder for _getTransferButtons()
                  );
                }),
              ),
            ),
          ],
        ),
        Container(), // Placeholder for the Positioned widget
      ],
    );
  }

  Widget buildTokenPart() {
    // Placeholder values for UI demonstration
    String tokenNumber = 'Token Number';
    String servedTime = '';
    String tokenStatus = 'Serving';
    Color statusColor = Colors.green;
    String customerDetails = 'Customer Details';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Placeholder for onTap action
                },
                onLongPress: () {
                  // Placeholder for onLongPress action
                },
                child: Text(
                  tokenNumber,
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder for Priority Text
                  Text(
                    'H', // or 'L', 'N' based on priority
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Placeholder for Served Time or Streamed Time
                  Text(
                    servedTime.isEmpty ? '00:00:00' : servedTime,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Placeholder for Token Status
                  Text(
                    tokenStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              // Placeholder for Customer Details
              Text(
                customerDetails,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            remarkhowBottomSheet();
          },
          icon: const Icon(Icons.notes),
          iconSize: 25,
        ),
      ],
    );
  }

  void remarkhowBottomSheet() {
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
              height: 400,
              color: isDarkMode ? Appcolors.bottomsheetDarkcolor : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // This Spacer will push the Text widget to the center
                      const Spacer(),
                      const Text(
                        'Remarks',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Navigator.pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 40,
                  // ),
                  // const SizedBox(height: 0),
                  // GestureDetector(
                  //   child: const TextField(
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       suffixIcon: Icon(Icons.arrow_drop_down),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 25),
                  GestureDetector(
                    child: const TextField(
                      minLines: 9, // Set the minimum number of lines
                      maxLines: 20,
                      decoration: InputDecoration(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  CustomElevatedButton(
                      text: "Save",
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

  Widget getTransferButtons() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Undo Transfer Button
    Widget allServicesButton = OutlinedButton(
      onPressed: null, // Placeholder for onPressed action
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.zero), // Makes the button rectangular
        ),
      ),
      child: Text(
        'TRANSFER TO (Show All services)',
        style: TextStyle(
          fontSize: 18,
          color: isDarkMode
              ? Appcolors.materialIconButtonDark
              : Appcolors.buttonColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );

    // Custom Elevated Button
    Widget customButton = CustomElevatedButton(
      text: "Doctor name ",
      onPressed: () {},
    );

    // Combine the custom button and the all services button row
    return Column(
      children: [
        customButton,
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 10),
            Expanded(child: allServicesButton),
          ],
        ),
      ],
    );
  }
}
