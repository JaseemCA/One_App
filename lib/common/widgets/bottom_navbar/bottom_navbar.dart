import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oneappcounter/presentation/appointments_page/appointments_page.dart';
import 'package:oneappcounter/presentation/home/home_screen.dart';
import 'package:oneappcounter/presentation/service_tabs_page/service_tab.dart';
import 'package:oneappcounter/presentation/tokens_page/tokens_page.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';

class BottomTabScreen extends StatefulWidget {
  const BottomTabScreen({super.key});

  @override
  State<BottomTabScreen> createState() => _BottomTabScreen();
}

class _BottomTabScreen extends State<BottomTabScreen> {
  int _currentIndex = 1;
  bool _iniBuild = true;
  final bool _isSetStateEventFromTabs = false;
  // static bool loadingVisibleForEvent = false;

  late StreamSubscription isSettingsChanged;
  late StreamSubscription showLoadingOnreload;

  // @override
  // void initState() {
  //   super.initState();
  //   isSettingsChanged = SocketService
  //       .settingsPageRebuildRequiredController.stream
  //       .listen((event) {
  //     if (event is bool && event) {
  //       BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
  //     }
  //   });
  //   showLoadingOnreload =
  //       GeneralDataService.reloadingDataController.stream.listen((event) {
  //     if (!loadingVisibleForEvent && event) {
  //       loadingVisibleForEvent = true;
  //       UtilityService.showLoadingAlert(context);
  //     }
  //     if (loadingVisibleForEvent && !event) {
  //       loadingVisibleForEvent = false;
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _decideSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 10,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _getTabItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _getTabItems() {
    List<BottomNavigationBarItem> navItems = [];

    if (CounterSettingService.counterSettings?.hideSideMenu != true &&
        (CounterSettingService.counterSettings?.hideTodayAppointments != true ||
            CounterSettingService.counterSettings?.hideCancelledAppointments !=
                true)) {
      navItems.add(
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_today_outlined,
            size: 25,
          ),
          activeIcon: Icon(Icons.calendar_today_rounded),
          label: 'Appointments',
        ),
      );
    }

    navItems.add(
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 25,
        ),
        activeIcon: Icon(
          Icons.home,
          size: 25,
        ),
        label: 'Home',
      ),
    );

    if (CounterSettingService.counterSettings?.hideSideMenu != true &&
        !(CounterSettingService.counterSettings?.hideCalled == true &&
            CounterSettingService.counterSettings?.hideCancelled == true &&
            CounterSettingService.counterSettings?.hideHoldedQueue == true &&
            CounterSettingService.counterSettings?.hideHoldedTokens == true &&
            CounterSettingService.counterSettings?.hideNextToCall == true)) {
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(
          Icons.assignment_outlined,
          size: 25,
        ),
        activeIcon: Icon(
          Icons.assignment,
          size: 25,
        ),
        label: 'Tokens',
      ));
    }
    navItems.add(
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.backup_table_sharp,
          size: 25,
        ),
        activeIcon: Icon(
          Icons.backup_table_sharp,
          size: 25,
        ),
        label: 'Tabs',
      ),
    );
    return navItems;
  }

  Widget _decideSelectedPage() {
    if (GeneralDataService.getTabs().isEmpty) {
      _currentIndex = 3;
    }
    updateIndexInitValue();

    switch (_currentIndex) {
      case 0:
        {
          if (CounterSettingService.counterSettings?.hideSideMenu == true ||
              (CounterSettingService.counterSettings?.hideTodayAppointments ==
                      true &&
                  CounterSettingService
                          .counterSettings?.hideCancelledAppointments ==
                      true)) {
            return const HomeScreen();
          }
          return const AppointmentsPage();
        }
      case 1:
        {
          if (CounterSettingService.counterSettings?.hideSideMenu == true ||
              ((CounterSettingService.counterSettings?.hideCalled == true &&
                      CounterSettingService.counterSettings?.hideCancelled ==
                          true &&
                      CounterSettingService.counterSettings?.hideHoldedQueue ==
                          true &&
                      CounterSettingService.counterSettings?.hideHoldedTokens ==
                          true &&
                      CounterSettingService.counterSettings?.hideNextToCall ==
                          true &&
                      CounterSettingService.counterSettings
                              ?.hideServedAndTransferredInCalled ==
                          true &&
                      CounterSettingService
                              .counterSettings?.hideServedInCalled ==
                          true) &&
                  (CounterSettingService
                              .counterSettings?.hideTodayAppointments ==
                          true &&
                      CounterSettingService
                              .counterSettings?.hideCancelledAppointments ==
                          true))) {
            return ServiceCounterTab();
          } else if (CounterSettingService.counterSettings?.hideSideMenu !=
                  true &&
              (CounterSettingService.counterSettings?.hideTodayAppointments ==
                      true &&
                  CounterSettingService
                          .counterSettings?.hideCancelledAppointments ==
                      true)) {
            return const TokensPage();
          }
          return const HomeScreen();
        }
      case 2:
        {
          if (CounterSettingService.counterSettings?.hideTodayAppointments == true &&
                  CounterSettingService
                          .counterSettings?.hideCancelledAppointments ==
                      true ||
              (CounterSettingService.counterSettings?.hideCalled == true &&
                  CounterSettingService.counterSettings?.hideCancelled ==
                      true &&
                  CounterSettingService.counterSettings?.hideHoldedQueue ==
                      true &&
                  CounterSettingService.counterSettings?.hideHoldedTokens ==
                      true &&
                  CounterSettingService.counterSettings?.hideNextToCall ==
                      true &&
                  CounterSettingService
                          .counterSettings?.hideServedAndTransferredInCalled ==
                      true &&
                  CounterSettingService.counterSettings?.hideServedInCalled ==
                      true)) {
            return ServiceCounterTab();
          }
          return const TokensPage();
        }
      case 3:
        {
          return ServiceCounterTab();
        }
      default:
        return const HomeScreen();
    }
  }

  void updateIndexInitValue() {
    if (_iniBuild) {
      _iniBuild = false;
      int tabsLength = _getTabItems().length;
      if (GeneralDataService.getTabs().isNotEmpty &&
          GeneralDataService.getTabs()
              .asMap()
              .containsKey(GeneralDataService.currentServiceCounterTabIndex) &&
          GeneralDataService.getTabs()[
                  GeneralDataService.currentServiceCounterTabIndex]
              .services
              .isNotEmpty) {
        if (_isSetStateEventFromTabs) {
          _currentIndex = tabsLength - 1;
        } else {
          if (tabsLength == 2) {
            _currentIndex = 0;
          } else if (tabsLength == 3) {
            if ((CounterSettingService.counterSettings?.hideTodayAppointments ==
                    true &&
                CounterSettingService
                        .counterSettings?.hideCancelledAppointments ==
                    true)) {
              ///hided appointmnets tab so home is.

              _currentIndex = 0;
            } else {
              ///call is hided.
              _currentIndex = 1;
            }
          } else if (tabsLength == 4) {
            _currentIndex = 1;
          }
        }
      } else {
        _currentIndex = tabsLength - 1;
      }
    }
  }
}
