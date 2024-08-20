// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/extention/string_casing_extention.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
import 'package:oneappcounter/presentation/popUp/customer_tocken_details.dart';
import 'package:oneappcounter/presentation/settings_page/settings_page.dart';
import 'package:oneappcounter/services/clock_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/utility_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateSetter? lockServiceButtonState;

  StateSetter? unlockServiceButtonState;

  DateTime dateTime = DateTime.now();
  String selectedTime = '';
  TokenModel? selectedToken;
  late BuildContext _context;

  void rebuildHoldUnholdButtons() {
    lockServiceButtonState != null
        ? lockServiceButtonState!(
            () {},
          )
        : null;
    unlockServiceButtonState != null
        ? unlockServiceButtonState!(
            () {},
          )
        : null;
  }

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
              onPressed: () async {
                await refreshFunction(context);
              },
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
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Services: ',
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      GeneralDataService
                                              .currentServiceCounterTab
                                              ?.serviceString ??
                                          '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: const TextStyle(
                                        height: 1,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Counter: ',
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      GeneralDataService
                                              .currentServiceCounterTab
                                              ?.counterString ??
                                          '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: const TextStyle(
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
                          onPressed: () async {
                            await _editServiceAndCounterTabDetails(tabsetState);
                          },
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
    TokenModel? token = selectedToken ?? GeneralDataService.lastCalledToken;
    String servedTime = GeneralDataService.lastCalledToken?.servedTime ?? '';

    if (token != null && servedTime.isEmpty) {
      ClockService.initaiateTimeDiffreneceEmitting(startedAt: token.startedAt);
    }
    if ((GeneralDataService.lastCalledToken != null &&
        GeneralDataService.lastCalledToken?.status == 'no-show')) {
      servedTime = ClockService.getTimeDifference(
        startedAt: token?.startedAt ?? '',
        nowPassed: token?.endedAt,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              GestureDetector(
                onTap: token != null
                    ? () {
                        // showTokenDetails(token, context);
                      }
                    : null,
                onLongPress: (token?.queueId != null &&
                        (token?.queue['queue_service_details'] != null ||
                            token?.queue['phone'] != null))
                    ? () {
                        showBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return CustomerTockenDetails(
                              serviceDetails:
                                  token?.queue['queue_service_details'] ?? [],
                              phone: token?.queue['phone'] != null
                                  ? '+${token?.queue['calling_code']} ${token?.queue['phone']}'
                                  : null,
                              email: token?.queue['email'] != null
                                  ? '${token?.queue['email']}'
                                  : null,
                              name: token?.queue['name'] != null
                                  ? '${token?.queue['name']}'
                                  : null,
                            );
                          },
                        );
                      }
                    : (token?.queueppointmentId != null &&
                            (token?.queueppointment['queue_service_details'] !=
                                    null ||
                                token?.queueppointment['phone'] != null))
                        ? () {
                            showBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return CustomerTockenDetails(
                                  serviceDetails: token?.queue[
                                          'queue_appointment_details'] ??
                                      [],
                                  phone: token?.queue['phone'] != null
                                      ? '+${token?.queue['calling_code']} ${token?.queue['phone']}'
                                      : null,
                                  email: token?.queue['email'] != null
                                      ? '${token?.queue['email']}'
                                      : null,
                                  name: token?.queue['name'] != null
                                      ? '${token?.queue['name']}'
                                      : null,
                                );
                              },
                            );
                          }
                        : null,
                child: Text(
                  token?.tokenNumber ?? 'NIL',
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
                  CounterSettingService.counterSettings?.showPriority == true
                      ? ((token?.queueId != null &&
                                  token?.queue['priority'] == 1) ||
                              (token?.queueppointmentId != null &&
                                  token?.queueppointment['priority'] == 1))
                          ? Text(
                              'H',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : ((token?.queueId != null &&
                                      token?.queue['priority'] == 3) ||
                                  (token?.queueppointmentId != null &&
                                      token?.queueppointment['priority'] == 3))
                              ? Text(
                                  'L',
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : ((token?.queueId != null &&
                                          token?.queue['priority'] == 2) ||
                                      (token?.queueppointmentId != null &&
                                          token?.queueppointment['priority'] ==
                                              2))
                                  ? Text(
                                      'N',
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Container()
                      : Container(),
                  SizedBox(
                    width:
                        CounterSettingService.counterSettings?.showPriority ==
                                true
                            ? 20
                            : 0,
                  ),
                  servedTime.isEmpty
                      ? StreamBuilder(
                          stream:
                              ClockService.lastStopWatchTimerController.stream,
                          builder: (context, value) {
                            return Text(
                              token != null && value.data is String
                                  ? value.data as String
                                  : '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            );
                          },
                        )
                      : Text(
                          token != null ? servedTime : '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    token != null ? token.status.toTitleCase() : '',
                    style: TextStyle(
                      color: token?.statusColor ?? Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                token != null
                    ? token.queueId != null && token.queue['customer'] != null
                        ? "${token.queue['customer']['name'] != null && token.queue['customer']['name'] != 'gqZaT' ? token.queue['customer']['name'] + ' | ' : ''} +${token.queue['calling_code']} ${token.queue['customer']['phone']}"
                        : token.queueppointmentId != null &&
                                token.queueppointment['customer'] != null
                            ? '${token.queueppointment['customer']['name'] != null && token.queueppointment['customer']['name'] != 'gqZaT' ? token.queueppointment['customer']['name'] + ' | ' : ''} +${token.queueppointment['calling_code']} ${token.queueppointment['customer']['phone']}'
                            : ''
                    : '',
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

  // Widget buildTokenPart() {
  //   // Placeholder values for UI demonstration
  //   String tokenNumber = 'Token Number';
  //   // String servedTime = '';
  //   String tokenStatus = 'Serving';
  //   Color statusColor = Colors.green;
  //   String customerDetails = 'Customer Details';

  //   TokenModel? token = selectedToken ?? GeneralDataService.lastCalledToken;
  //       String servedTime = GeneralDataService.lastCalledToken?.servedTime ?? '';

  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Column(
  //           children: [
  //             GestureDetector(
  //               onTap: () {
  //                 // Placeholder for onTap action
  //               },
  //               onLongPress: () {
  //                 // Placeholder for onLongPress action
  //               },
  //               child: Text(
  //                 tokenNumber,
  //                 style: const TextStyle(
  //                   fontSize: 45,
  //                   fontWeight: FontWeight.bold,
  //                   height: 1,
  //                 ),
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 // Placeholder for Priority Text
  //                 Text(
  //                   'H', // or 'L', 'N' based on priority
  //                   style: TextStyle(
  //                     color: Colors.green.shade600,
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 20),
  //                 // Placeholder for Served Time or Streamed Time
  //                 Text(
  //                   servedTime.isEmpty ? '00:00:00' : servedTime,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     height: 1,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 20),
  //                 // Placeholder for Token Status
  //                 Text(
  //                   tokenStatus,
  //                   style: TextStyle(
  //                     color: statusColor,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     height: 1,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 7),
  //             // Placeholder for Customer Details
  //             Text(
  //               customerDetails,
  //               style: const TextStyle(
  //                 fontSize: 17,
  //                 fontWeight: FontWeight.w400,
  //                 height: 1,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       IconButton(
  //         onPressed: () {
  //           remarkhowBottomSheet();
  //         },
  //         icon: const Icon(Icons.notes),
  //         iconSize: 25,
  //       ),
  //     ],
  //   );
  // }

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

  Future<void> _editServiceAndCounterTabDetails(
      StateSetter tabsetState) async {
    UtilityService.showLoadingAlert(_context);
    await GeneralDataService.initServiceAndCounterData();
    Navigator.pop(_context);
    showDialog(
        context: _context,
        builder: (context) {
          return SetNewServiceTab(
            editableService: GeneralDataService.currentServiceCounterTab,
            editingIndex: GeneralDataService.currentServiceCounterTabIndex,
          );
        }).then((value) => tabsetState(
          () {},
        ));
  }
  
  // void showTokenDetails(TokenModel? token, BuildContext context) {
  //   int? id = token?.queueId ?? token?.queueppointmentId;
  //   UtilityService.showLoadingAlert(context);
  //   CallService.getCustomerFlow(
  //     id: id ?? 0,
  //     isQueue: token?.queueId != null ? true : false,
  //   ).then((value) {
  //     Navigator.pop(context);
  //     if (value is bool && value == false) {
  //       UtilityService.toast(
  //         context,
  //         translate("Something went wrong, can't fetch details"),
  //       );
  //       return;
  //     }
  //     showBottomSheet(
  //         backgroundColor: Colors.transparent,
  //         context: context,
  //         builder: (context) {
  //           return CustomerFlowDetails(
  //             customerFlow: value,
  //             tokenNumber: token?.tokenNumber ?? '',
  //           );
  //         });
  //   });

  Future<void> refreshFunction(BuildContext context) async {
    UtilityService.showLoadingAlert(context);
    await GeneralDataService.reloadData();
    Navigator.pop(context);
    BlocProvider.of<SettingsBloc>(context).add(HomePageSettingsChangedEvent());
    rebuildHoldUnholdButtons();
  }
}
