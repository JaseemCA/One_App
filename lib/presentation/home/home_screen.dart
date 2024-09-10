// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oneappcounter/bloc/call/bloc/call_bloc.dart';
import 'package:oneappcounter/bloc/call/bloc/call_event.dart';
import 'package:oneappcounter/bloc/call/bloc/call_state.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_state.dart';
import 'package:oneappcounter/common/widgets/button/count_down_button.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/extention/string_casing_extention.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
import 'package:oneappcounter/presentation/popUp/customer_flow_details.dart';
import 'package:oneappcounter/presentation/popUp/customer_tocken_details.dart';
import 'package:oneappcounter/presentation/settings_page/settings_page.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/auth_service.dart';
import 'package:oneappcounter/services/call_service.dart';
import 'package:oneappcounter/services/clock_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/utility_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  StateSetter? lockServiceButtonState;

  StateSetter? unlockServiceButtonState;
  late StreamSubscription homePageRebuild;
  late StreamSubscription appBarRebuild;
  static bool isBuildPending = false;

  DateTime dateTime = DateTime.now();
  String selectedTime = '';
  TokenModel? selectedToken;
  late BuildContext _context;

  @override
  void initState() {
    super.initState();

    ClockService.updateDateTime();

    SocketService.registerEvents(isAll: true);

    homePageRebuild =
        SocketService.homePageRebuildRequiredController.stream.listen((event) {
      if (event is bool && event && isBuildPending == false) {
        BlocProvider.of<SettingsBloc>(context)
            .add(HomePageSettingsChangedEvent());
      }
    });
    appBarRebuild = SocketService.homePageAppBarRebuildRequiredController.stream
        .listen((event) {
      if (event is bool && event) {
        rebuildHoldUnholdButtons();
      }
    });
  }

  bool isAllServiceOnHold() {
    var items = GeneralDataService.getTabs()[
            GeneralDataService.currentServiceCounterTabIndex]
        .services
        .where((element) => element.isHold == true)
        .toList();
    return items.length ==
            GeneralDataService.getTabs()[
                    GeneralDataService.currentServiceCounterTabIndex]
                .services
                .length
        ? true
        : false;
  }

  bool isAllServiceOnUnhold() {
    var items = GeneralDataService.getTabs()[
            GeneralDataService.currentServiceCounterTabIndex]
        .services
        .where((element) => element.isHold == !true)
        .toList();
    return items.length ==
            GeneralDataService.getTabs()[
                    GeneralDataService.currentServiceCounterTabIndex]
                .services
                .length
        ? true
        : false;
  }

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
  void dispose() {
    try {
      SocketService.destorySocket();
    } catch (_) {}
    try {
      homePageRebuild.cancel();
    } catch (_) {}

    try {
      appBarRebuild.cancel();
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async {
                        UtilityService.showLoadingAlert(context);
                        if (await AuthService.logoutUser()) {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.loginScreen,
                            (route) => false,
                          );
                          return;
                        }
                        UtilityService.toast(context, ('Something went wrong'));
                      },
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
      body: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) {
          if (previous is SettingsStateUpdating &&
              current is HomePageSettingsState) {
            // log('inside bloc builder');
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return BlocBuilder<CallBloc, CallState>(
              buildWhen: (previous, current) {
            if (previous is CallNextTokenStartedState &&
                current is CallNextTokenCompletedState) {
              return true;
            }
            return false;
          }, builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                refreshFunction(context);
              },
              child: Stack(
                children: [
                  ListView(),
                  getScreen(),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget getScreen() {
    if (selectedToken != null) {
      return buildNonGridScreen();
    } else if ((CounterSettingService.counterSettings?.enableGridView == true &&
        ((CounterSettingService.counterSettings?.autoGridViewAfterTransfer !=
                    true &&
                GeneralDataService.lastCalledToken?.status == 'served') ||
            (GeneralDataService.lastCalledToken?.status == 'no-show' &&
                CounterSettingService
                        .counterSettings?.autoGridViewAfterNoShow ==
                    true) ||
            (CounterSettingService.counterSettings?.autoGridViewAfterHold ==
                    true &&
                GeneralDataService.lastCalledToken?.isHold == true) ||
            (CounterSettingService.counterSettings?.autoGridViewAfterTransfer ==
                        true &&
                    (GeneralDataService.lastCalledToken?.queueId != null &&
                        GeneralDataService
                            .lastCalledToken?.queue['is_transferred']) ||
                (GeneralDataService.lastCalledToken?.queueppointmentId !=
                        null &&
                    GeneralDataService
                        .lastCalledToken?.queueppointment['is_transferred'])) ||
            GeneralDataService.lastCalledToken == null))) {
      return buildGridScreen();
    } else {
      return buildNonGridScreen();
    }
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

  Widget buildGridScreen() {
    return const Center(
      child: Text("grid view"),
    );
  }

  Widget buildNonGridScreen() {
    TokenModel? token = selectedToken ?? GeneralDataService.lastCalledToken;

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
                  ),
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
                                onPressed: CounterSettingService.counterSettings
                                                ?.alwaysDisableServeBtn !=
                                            true &&
                                        token?.status == 'serving' &&
                                        !isAllServiceOnHold() &&
                                        token?.isHold != true
                                    ? () async {
                                        UtilityService.showLoadingAlert(
                                            _context);
                                        var response =
                                            await CallService.serveToken();
                                        Navigator.pop(_context);
                                        if (response is bool && !response) {
                                          UtilityService.toast(
                                            _context,
                                            ('Something went wrong'),
                                          );
                                        } else if (response is TokenModel) {
                                          selectedToken = null;
                                          UtilityService.toast(
                                            _context,
                                            ('Served'),
                                          );
                                          BlocProvider.of<CallBloc>(_context)
                                              .add((CallNextTokenEvent()));
                                        }
                                      }
                                    : null, // Disabled button
                                text: "SERVE",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                onPressed: CounterSettingService.counterSettings
                                                ?.alwaysDisableRecallBtn !=
                                            true &&
                                        token?.status == 'serving' &&
                                        token?.isHold != true
                                    ? () async {
                                        UtilityService.showLoadingAlert(
                                            _context);
                                        var response =
                                            await CallService.recallToken(
                                          id: token?.id ?? 0,
                                        );
                                        Navigator.pop(_context);
                                        if (response is TokenModel) {
                                          BlocProvider.of<CallBloc>(_context)
                                              .add((CallNextTokenEvent()));
                                          UtilityService.toast(
                                            _context,
                                            ('Recalled '),
                                          );
                                          return;
                                        }
                                        UtilityService.toast(
                                          _context,
                                          ('Something went wrong'),
                                        );
                                      }
                                    : null, // Disabled button
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
                                onPressed: CounterSettingService.counterSettings
                                                ?.alwaysDisableNoShowBtn !=
                                            true &&
                                        token?.status == 'serving' &&
                                        token?.isHold != true
                                    ? () async {
                                        UtilityService.showLoadingAlert(
                                            _context);
                                        var response =
                                            await CallService.markTokenNoShow();
                                        Navigator.pop(_context);
                                        if (response is TokenModel) {
                                          selectedToken = null;
                                          BlocProvider.of<CallBloc>(_context)
                                              .add((CallNextTokenEvent()));

                                          UtilityService.toast(
                                            _context,
                                            ('Marked as No Show '),
                                          );
                                          return;
                                        }
                                        UtilityService.toast(
                                            _context, ('Something went wrong'));
                                      }
                                    : null, // Disabled button
                                text: 'NO SHOW',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                onPressed: CounterSettingService.counterSettings
                                                ?.alwaysDisableCallNextBtn !=
                                            true &&
                                        (token?.status == 'served' ||
                                            token?.status == 'no-show' ||
                                            token?.status == 'holded' ||
                                            token == null ||
                                            token.isHold == true) &&
                                        !isAllServiceOnHold()
                                    ? () async {
                                        if ((token != null &&
                                                !token.isHold &&
                                                token.status != 'no-show') &&
                                            CounterSettingService
                                                    .counterSettings
                                                    ?.alertTransfer ==
                                                true &&
                                            (((token.queue != null &&
                                                    token.queue['is_transferred'] !=
                                                        true) ||
                                                (token.queueppointment != null &&
                                                    token.queueppointment['is_transferred'] !=
                                                        true)))) {
                                          showDialog(
                                              context: _context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Alert (Not transferred!)'),
                                                  content: Text(
                                                      '${token.tokenNumber} Not transferred, Continue Calling?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    CountDownButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        await _callNextToken();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        } else if ((token != null &&
                                                !token.isHold &&
                                                token.status != 'no-show') &&
                                            CounterSettingService
                                                    .counterSettings
                                                    ?.requireTransfer ==
                                                true &&
                                            ((token.queue != null && token.queue['is_transferred'] != true) ||
                                                (token.queueppointment != null &&
                                                    token.queueppointment['is_transferred'] !=
                                                        true))) {
                                          showDialog(
                                              context: _context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Transfer is required !'),
                                                  content: Text(
                                                      '${token.tokenNumber} Not transferred'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        } else {
                                          await _callNextToken();
                                        }
                                      }
                                    : null, // Disabled button
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
                                  onPressed: CounterSettingService
                                                  .counterSettings
                                                  ?.alwaysDisableHoldBtn !=
                                              true &&
                                          token?.status == 'serving'
                                      ? () async {
                                          ///hold token function.
                                          UtilityService.showLoadingAlert(
                                              _context);
                                          var response =
                                              await CallService.holdToken();
                                          Navigator.pop(_context);
                                          if (response is TokenModel) {
                                            BlocProvider.of<CallBloc>(_context)
                                                .add((CallNextTokenEvent()));
                                            UtilityService.toast(
                                              _context,
                                              ('Holded'),
                                            );
                                            return;
                                          }
                                          UtilityService.toast(
                                            _context,
                                            ('Something Went wrong'),
                                          );
                                        }
                                      : token?.isHold == true
                                          ? () async {
                                              ///unhold function.

                                              UtilityService.showLoadingAlert(
                                                _context,
                                              );
                                              var response =
                                                  await CallService.unholdToken(
                                                      id: token?.id ?? 0);
                                              Navigator.pop(_context);
                                              if (response is TokenModel) {
                                                if (selectedToken != null) {
                                                  selectedToken = response;
                                                }
                                                BlocProvider.of<CallBloc>(
                                                        _context)
                                                    .add(
                                                        (CallNextTokenEvent()));
                                                UtilityService.toast(
                                                  _context,
                                                  ('Unholded'),
                                                );
                                                return;
                                              }
                                              UtilityService.toast(
                                                _context,
                                                ('Something Went wrong'),
                                              );
                                            }
                                          : null, // Disabled button
                                  child: token?.isHold == true
                                      ? const Text(('UNHOLD TOKEN'))
                                      : const Text(('HOLD TOKEN')),
                                )),
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
                    ],
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
                        showTokenDetails(token, context);
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

  Future<void> _editServiceAndCounterTabDetails(StateSetter tabsetState) async {
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

  Future<void> _callNextToken() async {
    UtilityService.showLoadingAlert(_context);
    var token = await CallService.callNextToken();
    Navigator.pop(_context);
    if (token is TokenModel) {
      BlocProvider.of<CallBloc>(_context).add((CallNextTokenEvent()));
    } else if (token is String) {
      UtilityService.toast(_context, token);
    }
  }

  void showTokenDetails(TokenModel? token, BuildContext context) {
    int? id = token?.queueId ?? token?.queueppointmentId;
    UtilityService.showLoadingAlert(context);
    CallService.getCustomerFlow(
      id: id ?? 0,
      isQueue: token?.queueId != null ? true : false,
    ).then((value) {
      Navigator.pop(context);
      if (value is bool && value == false) {
        UtilityService.toast(
          context,
          ("Something went wrong, can't fetch details"),
        );
        return;
      }
      showBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return CustomerFlowDetails(
              customerFlow: value,
              tokenNumber: token?.tokenNumber ?? '',
            );
          });
    });
  }
}
