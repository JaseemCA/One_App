// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/call/bloc/call_bloc.dart';
import 'package:oneappcounter/bloc/call/bloc/call_event.dart';
import 'package:oneappcounter/bloc/call/bloc/call_state.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_state.dart';
import 'package:oneappcounter/common/widgets/button/count_down_button.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/common/widgets/one_app_logo/one_app_logo.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/core/config/constants.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/extention/string_casing_extention.dart';
import 'package:oneappcounter/model/queue_model.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
import 'package:oneappcounter/presentation/popUp/customer_flow_details.dart';
import 'package:oneappcounter/presentation/popUp/customer_tocken_details.dart';
import 'package:oneappcounter/presentation/popUp/lock_service.dart';
import 'package:oneappcounter/presentation/popUp/transfer_to_services.dart';
import 'package:oneappcounter/presentation/popUp/unlockservice.dart';
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
    homePageRebuild =
        SocketService.homePageRebuildRequiredController.stream.listen((event) {
      if (event && isBuildPending == false) {
        BlocProvider.of<SettingsBloc>(context)
            .add(HomePageSettingsChangedEvent());
      }
    });
    appBarRebuild = SocketService.homePageAppBarRebuildRequiredController.stream
        .listen((event) {
      if (event) {
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
        // elevation: 2,
        leadingWidth: 180,
        backgroundColor: isDarkMode
            ? bottomsheetDarkcolor
            : appBackgrondcolor,
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
          StatefulBuilder(builder:
              (BuildContext context, StateSetter lockServiceButtonSetState) {
            lockServiceButtonState = lockServiceButtonSetState;
            return !isAllServiceOnHold()
                ? IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const LockService();
                          }).then((value) => rebuildHoldUnholdButtons());
                    },
                    icon: const Icon(Icons.lock),
                    color: Colors.white,
                  )
                : Container();
          }),
          StatefulBuilder(builder:
              (BuildContext context, StateSetter unlockButtonSetState) {
            unlockServiceButtonState = unlockButtonSetState;
            return !isAllServiceOnUnhold()
                ? IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const UnlockService();
                          }).then((value) => rebuildHoldUnholdButtons());
                    },
                    icon: const Icon(Icons.lock_open),
                    color: Colors.white,
                  )
                : Container();
          }),
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
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) {
          if (previous is SettingsStateUpdating &&
              current is HomePageSettingsState) {
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
    List<TokenModel> secondGridViewList = [];
    secondGridViewList.clear();
    secondGridViewList = GeneralDataService.todayCalledNoShow;
    String secondGridViewLabel = ('No Show ');
    if (CounterSettingService.counterSettings?.showHoldedInNoShow == true) {
      secondGridViewList = [
        ...GeneralDataService.todayCalledNoShow,
        ...GeneralDataService.todayCalledHolded,
      ];
      secondGridViewLabel += ('/  Holded ');
    }
    if (CounterSettingService.counterSettings?.showNotTransferredInNoShow ==
        true) {
      List<TokenModel> list = secondGridViewList;
      secondGridViewList = [
        ...list,
        ...GeneralDataService.todayCalledNotTransferred
      ];
      secondGridViewLabel += ('/  Not Transferred');
    }

    return Column(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            buildTokenPart(),
            const Divider(),
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  const Text(
                    ('Next to Call'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      child: GridView.builder(
                          itemCount: GeneralDataService.todaysQueue.isNotEmpty
                              ? GeneralDataService.todaysQueue.length
                              : 0,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 2.6,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                          ),
                          itemBuilder: (context, index) {
                            QueueModel queue =
                                GeneralDataService.todaysQueue[index];
                            return Tooltip(
                              message:
                                  "${queue.name != null ? '${queue.name!}|' : ''} ${queue.phone ?? ''}",
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: queue.priority == 1
                                      ? const Color(0xffA8F387)
                                      : queue.priority == 3
                                          ? const Color(0xffFEE5E0)
                                          : null,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () async {
                                  if ((GeneralDataService.lastCalledToken != null &&
                                          !GeneralDataService
                                              .lastCalledToken!.isHold &&
                                          GeneralDataService.lastCalledToken!.status !=
                                              'no-show') &&
                                      CounterSettingService.counterSettings?.alertTransfer ==
                                          true &&
                                      (((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) ||
                                          (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                              GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] !=
                                                  true)))) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                ('Alert (Not transferred!)')),
                                            content: Text(
                                                '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred, Continue Calling?')}'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(('Cancel')),
                                              ),
                                              CountDownButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await callTokenGrid(
                                                    context: context,
                                                    id: queue.id,
                                                  );
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  } else if ((GeneralDataService.lastCalledToken != null &&
                                          !GeneralDataService
                                              .lastCalledToken!.isHold &&
                                          GeneralDataService.lastCalledToken!.status !=
                                              'no-show') &&
                                      CounterSettingService.counterSettings
                                              ?.requireTransfer ==
                                          true &&
                                      ((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) ||
                                          (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                              GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] != true))) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                ('Transfer is required !')),
                                            content: Text(
                                                '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred')}'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(('Close')),
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    callTokenGrid(
                                        context: context, id: queue.id);
                                  }
                                },
                                child: FittedBox(
                                  child: Text(
                                    queue.tokenNumber,
                                    style: const TextStyle(
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: Column(
                children: [
                  Text(
                    secondGridViewLabel,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      child: GridView.builder(
                          itemCount: secondGridViewList.isNotEmpty
                              ? secondGridViewList.length
                              : 0,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 2.6,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                          ),
                          itemBuilder: (context, index) {
                            TokenModel token = secondGridViewList[index];
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: token.status == "no-show"
                                    ? UtilityService.isDarkTheme
                                        ? lowPriorityDark
                                        : lowPriorityLight
                                    : token.isHold == true
                                        ? UtilityService.isDarkTheme
                                            ? warningDark
                                            : warningLight
                                        : null,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: token.status == "no-show"
                                  ? () async {
                                      if ((GeneralDataService.lastCalledToken != null &&
                                              !GeneralDataService
                                                  .lastCalledToken!.isHold &&
                                              GeneralDataService.lastCalledToken!.status !=
                                                  'no-show') &&
                                          CounterSettingService.counterSettings?.alertTransfer ==
                                              true &&
                                          (((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) ||
                                              (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                                  GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] !=
                                                      true)))) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    ('Alert (Not transferred!)')),
                                                content: Text(
                                                    '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred, Continue Calling?')}'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text(('Cancel')),
                                                  ),
                                                  CountDownButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await callTokenNoShowGrid(
                                                          context: context,
                                                          id: token.id);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      } else if ((GeneralDataService.lastCalledToken != null &&
                                              !GeneralDataService
                                                  .lastCalledToken!.isHold &&
                                              GeneralDataService.lastCalledToken!.status !=
                                                  'no-show') &&
                                          CounterSettingService.counterSettings?.requireTransfer ==
                                              true &&
                                          ((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) ||
                                              (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                                  GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] != true))) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    ('Transfer is required !')),
                                                content: Text(
                                                    '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred')}'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text(('Close')),
                                                  ),
                                                ],
                                              );
                                            });
                                      } else {
                                        callTokenNoShowGrid(
                                            context: context, id: token.id);
                                      }
                                    }
                                  : token.status == 'holded' &&
                                          token.isHold == true
                                      ? () {
                                          if ((GeneralDataService.lastCalledToken != null &&
                                                  !GeneralDataService
                                                      .lastCalledToken!
                                                      .isHold &&
                                                  GeneralDataService.lastCalledToken!.status !=
                                                      'no-show') &&
                                              CounterSettingService
                                                      .counterSettings
                                                      ?.alertTransfer ==
                                                  true &&
                                              (((GeneralDataService.lastCalledToken!.queue != null &&
                                                      GeneralDataService.lastCalledToken!.queue['is_transferred'] !=
                                                          true) ||
                                                  (GeneralDataService.lastCalledToken!.queueppointment != null &&
                                                      GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] !=
                                                          true)))) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        ('Alert (Not transferred!)')),
                                                    content: Text(
                                                        '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred, Continue Calling?')}'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            ('Cancel')),
                                                      ),
                                                      CountDownButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          await setSelectedTokenFromGrid(
                                                              token);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          } else if ((GeneralDataService.lastCalledToken != null &&
                                                  !GeneralDataService
                                                      .lastCalledToken!
                                                      .isHold &&
                                                  GeneralDataService.lastCalledToken!.status != 'no-show') &&
                                              CounterSettingService.counterSettings?.requireTransfer == true &&
                                              ((GeneralDataService.lastCalledToken!.queue != null && GeneralDataService.lastCalledToken!.queue['is_transferred'] != true) || (GeneralDataService.lastCalledToken!.queueppointment != null && GeneralDataService.lastCalledToken!.queueppointment['is_transferred'] != true))) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        ('Transfer is required !')),
                                                    content: Text(
                                                        '${GeneralDataService.lastCalledToken!.tokenNumber} ${('Not transferred')}'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            ('Close')),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            setSelectedTokenFromGrid(token);
                                          }
                                        }
                                      : () {
                                          setSelectedTokenFromGrid(token);
                                        },
                              child: FittedBox(
                                child: Text(
                                  token.tokenNumber,
                                  style: const TextStyle(
                                    height: 1,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter tabsetState) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                ('Services: '),
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  GeneralDataService.currentServiceCounterTab
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
                                ('Counter: '),
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  GeneralDataService.currentServiceCounterTab
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
                );
              }),
            ),
          ],
        ),
      ],
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
                  ),
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
                                    : null,
                                // child: const Text("SERVE"), // Disabled button
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
                                        
                                        print(
                                            'alwaysDisableCallNextBtn: ${CounterSettingService.counterSettings?.alwaysDisableCallNextBtn}');
                                        print('Token status: ${token?.status}');
                                        print('Token isHold: ${token?.isHold}');
                                        print(
                                            'isAllServiceOnHold: ${isAllServiceOnHold()}');

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
                                          // Log to verify if this dialog gets triggered
                                          print(
                                              'Showing alert dialog for non-transferred token');
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
                                                        print(
                                                            'Cancelled call'); // Log for dialog cancel
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    CountDownButton(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        print(
                                                            'Calling next token...'); // Log before calling
                                                        await _callNextToken();
                                                        print(
                                                            'Called next token.'); // Log after calling
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
                                          // Log to verify if the require transfer dialog gets triggered
                                          print(
                                              'Showing transfer required dialog');
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
                                                        print(
                                                            'Closed transfer required dialog'); // Log for dialog close
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        } else {
                                          // Directly call next token without showing a dialog
                                          print(
                                              'Calling next token without dialog...'); // Log for default call
                                          await _callNextToken();
                                          print(
                                              'Called next token.'); // Log after calling
                                        }
                                      }
                                    : () {
                                        // Log if the button is disabled
                                        print('CALL NEXT button is disabled');
                                      },
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
                              child: CounterSettingService.counterSettings
                                          ?.neverShowServiceHoldBtn !=
                                      true
                                  ? CustomElevatedButton(
                                      text: token?.isHold == true
                                          ? 'UNHOLD TOKEN'
                                          : 'HOLD TOKEN',
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
                                                BlocProvider.of<CallBloc>(
                                                        _context)
                                                    .add(CallNextTokenEvent());
                                                UtilityService.toast(
                                                    _context, 'Holded');
                                                return;
                                              }
                                              UtilityService.toast(_context,
                                                  'Something Went wrong');
                                            }
                                          : token?.isHold == true
                                              ? () async {
                                                  ///unhold function.
                                                  UtilityService
                                                      .showLoadingAlert(
                                                          _context);
                                                  var response =
                                                      await CallService
                                                          .unholdToken(
                                                              id: token?.id ??
                                                                  0);
                                                  Navigator.pop(_context);
                                                  if (response is TokenModel) {
                                                    if (selectedToken != null) {
                                                      selectedToken = response;
                                                    }
                                                    BlocProvider.of<CallBloc>(
                                                            _context)
                                                        .add(
                                                            CallNextTokenEvent());
                                                    UtilityService.toast(
                                                        _context, 'Unholded');
                                                    return;
                                                  }
                                                  UtilityService.toast(_context,
                                                      'Something Went wrong');
                                                }
                                              : null,
                                      // child: token?.isHold == true
                                      //     ? const Text(('UNHOLD TOKEN'))
                                      //     : const Text(
                                      //         ('HOLD TOKEN')),
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 3.0,
                              ),
                              child: token?.status == 'served'
                                  ? Text(
                                      ((token?.queue != null &&
                                                  token?.queue[
                                                          'is_transferred'] ==
                                                      true) ||
                                              (token?.queueppointment != null &&
                                                  token?.queueppointment[
                                                          'is_transferred'] ==
                                                      true))
                                          ? ('Token Transferred To')
                                          : ('Select Service to transfer'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Container(),
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
                    children: token?.status == 'served'
                        ? getTransferButtons(constraints)
                        : [],
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

  List<Widget> getTransferButtons(BoxConstraints constraints) {
    List<int> selectedTransferServices = [];
    TokenModel? token = selectedToken ?? GeneralDataService.lastCalledToken;

    int possibleItems = (constraints.maxHeight / 65).floor();
    List<Widget> widget = [];
    Widget allServicesButton = ((token?.queue != null &&
                token?.queue['transfer_to'] != null &&
                token?.queue['transfer_to']['called'] == true) ||
            (token?.queueppointment != null &&
                token?.queueppointment['transfer_to'] != null &&
                token?.queueppointment['transfer_to']['called'] == true))
        ? Container()
        : OutlinedButton(
            onPressed: !isAllServiceOnHold()
                ? token?.status == 'served'
                    ? ((token?.queue != null &&
                                token?.queue['is_transferred'] == true) ||
                            (token?.queueppointment != null &&
                                token?.queueppointment['is_transferred'] ==
                                    true))
                        ? () async {
                            showDialog(
                                context: _context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(('Cancel')),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          isBuildPending = true;
                                          UtilityService.showLoadingAlert(
                                              context);
                                          var response = await CallService
                                              .undoTransferService(
                                            token: token!,
                                          );
                                          Navigator.pop(context);
                                          if (response is bool && response) {
                                            UtilityService.toast(
                                                context, ('Transfer reversed'));
                                            BlocProvider.of<CallBloc>(_context)
                                                .add((CallNextTokenEvent()));
                                            isBuildPending = false;
                                            Navigator.pop(_context);
                                            return;
                                          }
                                          isBuildPending = false;
                                          UtilityService.toast(
                                              context, ('Somthing went wrong'));
                                        },
                                        child: const Text(('Proceed')),
                                      ),
                                    ],
                                    title: const Text(('Cancelling Transfer')),
                                    content:
                                        const Text(('Undo Transfer Ticket?')),
                                  );
                                });
                          }
                        : () async {
                            UtilityService.showLoadingAlert(_context);
                            if (GeneralDataService.activeServices.isEmpty) {
                              await GeneralDataService
                                  .initServiceAndCounterData();
                            }
                            Navigator.pop(_context);
                            showDialog(
                                    context: _context,
                                    builder: (context) {
                                      return TransferToServices(
                                        selectedToken: token!,
                                      );
                                    })
                                .then((value) =>
                                    BlocProvider.of<CallBloc>(_context)
                                        .add((CallNextTokenEvent())));
                          }
                    : null
                : null,
            child: Text(
              (token?.queueId != null &&
                          token?.queue['is_transferred'] == true) ||
                      (token?.queueppointmentId != null &&
                          token?.queueppointment['is_transferred'] == true)
                  ? ('Undo Transfer')
                  : ('TRANSFER TO (Show All services)'),
              overflow: TextOverflow.ellipsis,
            ),
          );

    List transferServices =
        CounterSettingService.counterSettings?.transferServices != null
            ? (CounterSettingService.counterSettings?.transferServices as List)
                .where((element) => element != token?.serviceId)
                .toList()
            : [];
    Widget multiTrasnferButton =
        CounterSettingService.counterSettings?.multipleTransfer == true
            ? OutlinedButton(
                onPressed: () {
                  bool _return = false;
                  if (selectedTransferServices.isNotEmpty) {
                    showDialog(
                        context: _context,
                        builder: (context) {
                          String _priority = "Normal";
                          return AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(('Cancel'))),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, _priority);
                                },
                                child: const Text(('Transfer')),
                              ),
                            ],
                            content: SizedBox(
                              height: 450,
                              child: Column(
                                children: [
                                  DropdownSearch<String>(
                                    items: const ["High", "Normal", "Low"],
                                    popupProps: const PopupProps.menu(),
                                    dropdownDecoratorProps:
                                        const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: ("Priority"),
                                        hintText: ("Priority"),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      _priority = value!;
                                    },
                                    selectedItem: _priority,
                                  ),
                                  Row(
                                    children: [
                                      const Text(('Return')),
                                      StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter radioButtonState) {
                                        return Checkbox(
                                            value: _return,
                                            onChanged: (value) {
                                              radioButtonState(() {
                                                _return = value!;
                                              });
                                            });
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            title: const Text(('Select Priority')),
                          );
                        }).then((value) async {
                      if (value is String && value.isNotEmpty) {
                        UtilityService.showLoadingAlert(_context);
                        isBuildPending = true;
                        Map<String, dynamic> data = {
                          'priority': value == "High"
                              ? 1
                              : value == "Normal"
                                  ? 2
                                  : 3,
                          'transfer_service_ids': selectedTransferServices,
                          'return': _return
                        };
                        if (CounterSettingService
                                .counterSettings?.multipleTransferAtATime ==
                            true) {
                          data['multi_transfer_at_a_time'] = 1;
                        }
                        var response = await CallService.transferService(
                          data: data,
                          token: token!,
                        );
                        Navigator.pop(_context);
                        if (response is bool && response) {
                          UtilityService.toast(_context, ('Transferred'));
                          selectedToken = null;
                          BlocProvider.of<CallBloc>(_context)
                              .add((CallNextTokenEvent()));
                          isBuildPending = false;
                          return;
                        }
                        isBuildPending = false;
                        UtilityService.toast(
                            _context, ('Something went wrong'));
                      }
                    });
                  } else {
                    UtilityService.toast(_context, "select service");
                  }
                },
                child: const Text(('Transfer')))
            : Container();

    if ((token?.queueId != null && token?.queue['is_transferred'] == true) ||
        (token?.queueppointmentId != null &&
            token?.queueppointment['is_transferred'] == true)) {
      widget.add(
        Text(
          token?.queueId != null
              ? token?.queue['transfer_services_label'] ??
                  token?.queue['transfer_to']['service']['name']
              : token?.queueppointmentId != null
                  ? token?.queueppointment['transfer_services_label'] ??
                      token?.queueppointment['transfer_to']['service']['name']
                  : '',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    } else if (transferServices.isNotEmpty &&
        transferServices.length <= possibleItems &&
        GeneralDataService.activeServices.isNotEmpty) {
      for (int item in transferServices) {
        if (GeneralDataService.activeServices
            .map((e) => e.id)
            .toList()
            .contains(item)) {
          ServiceModel service = GeneralDataService.activeServices.singleWhere(
            (element) => element.id == item,
          );
          widget.add(
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                    width: double.infinity, height: 45),
                child: StatefulBuilder(builder: (context, buttonState) {
                  return ElevatedButton(
                    style: CounterSettingService
                                .counterSettings?.multipleTransfer ==
                            true
                        ? ElevatedButton.styleFrom(
                            backgroundColor:
                                !selectedTransferServices.contains(service.id)
                                    ? buttonSelectedColor
                                    : null,
                          )
                        : null,
                    onPressed: () async {
                      if (CounterSettingService
                              .counterSettings?.multipleTransfer ==
                          true) {
                        if (selectedTransferServices.contains(service.id)) {
                          try {
                            selectedTransferServices.removeAt(
                                selectedTransferServices.indexWhere(
                                    (element) => element == service.id));
                          } catch (_) {}
                        } else {
                          selectedTransferServices.add(service.id);
                        }
                        buttonState(
                          () {},
                        );
                      } else {
                        showDialog(
                            context: _context,
                            builder: (context) {
                              String _priority = "Normal";
                              return AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(('Cancel'))),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, _priority);
                                    },
                                    child: const Text(('Transfer')),
                                  ),
                                ],
                                content: DropdownSearch<String>(
                                  items: const ["High", "Normal", "Low"],
                                  popupProps: const PopupProps.menu(),
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: ("Priority"),
                                      hintText: ("Priority"),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    _priority = value!;
                                  },
                                  selectedItem: _priority,
                                ),
                                title: const Text(('Select Priority')),
                              );
                            }).then((value) async {
                          if (value is String && value.isNotEmpty) {
                            UtilityService.showLoadingAlert(_context);
                            isBuildPending = true;
                            Map<String, dynamic> data = {
                              'priority': value == "High"
                                  ? 1
                                  : value == "Normal"
                                      ? 2
                                      : 3,
                              'transfer_service_ids': [service.id]
                            };
                            var response = await CallService.transferService(
                              data: data,
                              token: token!,
                            );

                            Navigator.pop(_context);
                            if (response is bool && response) {
                              UtilityService.toast(_context, ('Transferred'));
                              selectedToken = null;
                              BlocProvider.of<CallBloc>(_context)
                                  .add((CallNextTokenEvent()));
                              isBuildPending = false;
                              return;
                            }
                            isBuildPending = false;
                            UtilityService.toast(
                                _context, ('Something went wrong'));
                          }
                        });
                      }
                    },
                    child: Text(
                      service.name,
                      maxLines: 2,
                      style: const TextStyle(
                        height: 1,
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        }
        // return widget;
      }

      if (CounterSettingService.counterSettings?.multipleTransfer == true) {
        widget.add(Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            children: [
              multiTrasnferButton,
              const SizedBox(
                width: 10,
              ),
              Expanded(child: allServicesButton),
            ],
          ),
        ));
      } else {
        widget.add(allServicesButton);
      }
      return widget;
    } else if (transferServices.isEmpty &&
        (GeneralDataService.activeServices
                    .where((element) => element.id != token?.serviceId)
                    .toList())
                .length <=
            possibleItems) {
      for (var service in GeneralDataService.activeServices
          .where((element) => element.id != token?.serviceId)
          .toList()) {
        widget.add(
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                  width: double.infinity, height: 45),
              child: StatefulBuilder(builder: (context, buttonState) {
                return ElevatedButton(
                  style:
                      CounterSettingService.counterSettings?.multipleTransfer ==
                              true
                          ? ElevatedButton.styleFrom(
                              backgroundColor:
                                  !selectedTransferServices.contains(service.id)
                                      ? buttonSelectedColor
                                      : null,
                            )
                          : null,
                  onPressed: () async {
                    if (CounterSettingService
                            .counterSettings?.multipleTransfer ==
                        true) {
                      if (selectedTransferServices.contains(service.id)) {
                        try {
                          selectedTransferServices.removeAt(
                              selectedTransferServices.indexWhere(
                                  (element) => element == service.id));
                        } catch (_) {}
                      } else {
                        selectedTransferServices.add(service.id);
                      }
                      buttonState(
                        () {},
                      );
                    } else {
                      showDialog(
                          context: _context,
                          builder: (context) {
                            String _priority = "Normal";
                            return AlertDialog(
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(('Cancel'))),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, _priority);
                                  },
                                  child: const Text(('Transfer')),
                                ),
                              ],
                              content: DropdownSearch<String>(
                                items: const ["High", "Normal", "Low"],
                                popupProps: const PopupProps.menu(),
                                dropdownDecoratorProps:
                                    const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: ("Priority"),
                                    hintText: ("Priority"),
                                  ),
                                ),
                                onChanged: (value) {
                                  _priority = value!;
                                },
                                selectedItem: _priority,
                              ),
                              title: const Text(('Select Priority')),
                            );
                          }).then((value) async {
                        if (value is String && value.isNotEmpty) {
                          UtilityService.showLoadingAlert(_context);
                          isBuildPending = true;
                          Map<String, dynamic> data = {
                            'priority': value == "High"
                                ? 1
                                : value == "Normal"
                                    ? 2
                                    : 3,
                            'transfer_service_ids': [service.id]
                          };
                          var response = await CallService.transferService(
                            data: data,
                            token: token!,
                          );
                          Navigator.pop(_context);
                          if (response is bool && response) {
                            UtilityService.toast(_context, ('Transferred'));
                            selectedToken = null;
                            BlocProvider.of<CallBloc>(_context)
                                .add((CallNextTokenEvent()));
                            isBuildPending = false;
                            return;
                          }
                          UtilityService.toast(
                              _context, ('Something went wrong'));
                        }
                      });
                    }
                  },
                  child: Text(
                    service.name,
                    maxLines: 2,
                    style: const TextStyle(
                      height: 1,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
        if (CounterSettingService.counterSettings?.multipleTransfer == true) {
          widget.add(Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: [
                multiTrasnferButton,
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: allServicesButton),
              ],
            ),
          ));
        } else {
          widget.add(allServicesButton);
        }
        return widget;
      }
    }
    widget.add(allServicesButton);
    return widget;
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
        // IconButton(
        //   onPressed: () {
        //     remarkhowBottomSheet();
        //   },
        //   icon: const Icon(Icons.notes),
        //   iconSize: 25,
        // ),
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
              color: isDarkMode ? bottomsheetDarkcolor : Colors.white,
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
                          Navigator.pop(context);
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

  Future<void> callTokenGrid(
      {required BuildContext context, required int id}) async {
    UtilityService.showLoadingAlert(context);
    var response = await CallService.callTokenFromQueue(queueId: id);
    Navigator.pop(context);
    if (response is TokenModel) {
      BlocProvider.of<CallBloc>(_context).add((CallNextTokenEvent()));
      return;
    }
    UtilityService.toast(context, ('Something went wrong'));
  }

  Future<void> callTokenNoShowGrid(
      {required BuildContext context, required int id}) async {
    UtilityService.showLoadingAlert(_context);
    var response = await CallService.recallToken(id: id);

    if (!mounted) return;

    Navigator.pop(_context);
    if (response is TokenModel) {
      BlocProvider.of<CallBloc>(_context).add((CallNextTokenEvent()));
      return;
    }
    UtilityService.toast(context, ('Something went wrong'));
  }

  Future<void> setSelectedTokenFromGrid(TokenModel token) async {
    selectedToken = token;
    BlocProvider.of<CallBloc>(_context).add((CallNextTokenEvent()));
    return;
  }
}
