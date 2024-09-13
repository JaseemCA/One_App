// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/functions/general_functions.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/set_device_service.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/utility_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final alertTimeController = TextEditingController();
  final uidController = TextEditingController();
  static bool _isSettingsUpdating = false;
  static bool _isTabRebuildNeededAfterPop = false;
  static bool _isHomeRebuildNeededAfterPop = false;
  Map<String, dynamic>? _currentSettings =
      CounterSettingService.counterSettings?.toJson();

  ///setstate functions
  StateSetter? _alertTransferSetState;

  StateSetter? _requiredTransferSetState;

  ///side menu

  StateSetter? _hideCalledSetState;

  StateSetter? _hideServedSetState;

  StateSetter? _hideServedTransferSetState;

  // StateSetter? _autoGridViewAfterServeSetState;

  // StateSetter? _autoGridViewAfterTransferSetState;

  StateSetter? multipleTransferAtATimeSetState;

  StateSetter? rebuildAllSetState;

  List<ServiceModel> selectedServices =
      GeneralDataService.activeServices.where((element) {
    List transferServices =
        CounterSettingService.counterSettings?.transferServices ?? [];
    if (transferServices.contains(element.id)) {
      return true;
    }
    return false;
  }).toList();

  late BuildContext _context;

  late StreamSubscription rebuildRequired;
  Future<void> updateSettings(BuildContext context, String message) async {
    _isSettingsUpdating = true;
    UtilityService.showLoadingAlert(context);
    if (_currentSettings != null) {
      await CounterSettingService.updateSettingsLocaly(
        _currentSettings!,
        callAPi: false,
      );
    }
    Navigator.pop(context);
    // await LanguageService.changeLocaleFn(context);
    UtilityService.toast(context, '$message ${('Settings Updated')}');
    _isHomeRebuildNeededAfterPop = true;
    _isSettingsUpdating = false;
  }

  @override
  void initState() {
    super.initState();
    rebuildRequired = SocketService.settingsPageRebuildRequiredController.stream
        .listen((event) async {
      if (event is bool && event) {
        updateMainVaribale();
        rebuildAllSetState != null ? rebuildAllSetState!(() {}) : null;

        /// as build context need to be passed to change locale function, so all switching tab should call same function
        // await LanguageService.changeLocaleFn(context);
      }
    });
  }

  @override
  void dispose() {
    try {
      rebuildRequired.cancel();
    } catch (_) {}
    super.dispose();
  }

  void updateMainVaribale() {
    _currentSettings = CounterSettingService.counterSettings?.toJson();
    selectedServices = GeneralDataService.activeServices.where((element) {
      List transferServices =
          CounterSettingService.counterSettings?.transferServices;
      if (transferServices.contains(element.id)) {
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        UtilityService.showLoadingAlert(context);
        await waitWhile(() => _isSettingsUpdating);
        await SetDeviceService.addCounterAppDetails();
        await GeneralDataService.getTodayTokenDetails();
        Navigator.pop(context);
        Navigator.pop(
          context,
          {
            'tab': _isTabRebuildNeededAfterPop,
            'home': _isHomeRebuildNeededAfterPop
          },
        );
        return false;
      },
      child: Scaffold(
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
              onPressed: () async {
                UtilityService.showLoadingAlert(context);
                await waitWhile(() => _isSettingsUpdating);
                await SetDeviceService.addCounterAppDetails();
                await GeneralDataService.getTodayTokenDetails();
                Navigator.pop(context);
                Navigator.pop(
                  context,
                  {
                    'tab': _isTabRebuildNeededAfterPop,
                    'home': _isHomeRebuildNeededAfterPop
                  },
                );
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
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter allPageSetState) {
            rebuildAllSetState = allPageSetState;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<ServiceModel>.multiSelection(
                          compareFn: (item1, current) {
                            if (item1.id == current.id) {
                              return true;
                            }
                            return false;
                          },
                          selectedItems: selectedServices,
                          items: GeneralDataService.activeServices,
                          popupProps: const PopupPropsMultiSelection.dialog(
                            showSearchBox: true,
                          ),
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: ("Transfer Service"),
                              hintText: ("Transfer Service"),
                            ),
                          ),
                          itemAsString: (value) {
                            return value.displayName;
                          },
                          onChanged: (value) {
                            _currentSettings?['transferServices'] != null
                                ? _currentSettings!['transferServices'].clear()
                                : _currentSettings?['transferServices'] = [];
                            for (var item in value) {
                              _currentSettings?['transferServices']
                                  .add(item.id);
                            }
                            updateSettings(
                              context,
                              ('Transfer Service'),
                            );
                          },
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
                          decoration:
                              const InputDecoration(hintText: 'Enter UID'),
                        ),
                      ),
                      Expanded(
                          child: CustomElevatedButton(
                        text: "APPLY",
                        onPressed: () {},
                        fontSize: 12,
                      ))
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
            );
          }),
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
                    ('General'),
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    ('Recall Unhold Token?'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                      value: _currentSettings?['recallUnholdToken'] ?? false,
                      onChanged: (value) {
                        _currentSettings?['recallUnholdToken'] = value;

                        updateSettings(
                          context,
                          ('General'),
                        );
                        setState(() {});
                      },
                    );
                  }),
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                    flex: 4,
                    child: Text(
                      ('Alert Transfer'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    _alertTransferSetState = setState;
                    return Switch(
                        value: _currentSettings?['alertTransfer'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['alertTransfer'] = value;
                          if (value &&
                              _currentSettings?['requireTransfer'] == true) {
                            _currentSettings?['requireTransfer'] = false;
                          }
                          if (_requiredTransferSetState != null &&
                              _alertTransferSetState != null) {
                            _requiredTransferSetState!(() {});
                            _alertTransferSetState!(() {});
                          }
                          updateSettings(
                            context,
                            ('General'),
                          );
                        });
                  }),
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    ('Alert Time (in seconds)'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: alertTimeController,
                    onChanged: (value) {
                      _currentSettings?['alertTime'] = alertTimeController.text;
                      updateSettings(
                        _context,
                        ('General'),
                      );
                    },
                  ),
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    ('Require Transfer Service?'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    _requiredTransferSetState = setState;
                    return Switch(
                        value: _currentSettings?['requireTransfer'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['requireTransfer'] = value;
                          if (value &&
                              _currentSettings?['alertTransfer'] == true) {
                            _currentSettings?['alertTransfer'] = false;
                          }

                          if (_requiredTransferSetState != null &&
                              _alertTransferSetState != null) {
                            _requiredTransferSetState!(() {});
                            _alertTransferSetState!(() {});
                          }
                          updateSettings(
                            _context,
                            ('General'),
                          );
                        });
                  }),
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    ('Notification?'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['notification'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['notification'] = value;
                          updateSettings(
                            _context,
                            ('General'),
                          );
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    ('Notification Sound?'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['notificationSound'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['notificationSound'] = value;

                          updateSettings(
                            _context,
                            ('General'),
                          );
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    ('Show Token Priority?'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['showPriority'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['showPriority'] = value;
                          updateSettings(
                            _context,
                            ('General'),
                          );
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSideMenuCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter hideSideMenusetState) {
          return Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      ('Navigation Menu'),
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Text(
                      ('Hide Navigation Menu (Token and Appointment)?'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Switch(
                      value: _currentSettings?['hideSideMenu'] ?? false,
                      onChanged: (value) {
                        _isTabRebuildNeededAfterPop = true;
                        _currentSettings?['hideSideMenu'] = value;
                        _currentSettings?['hideNextToCall'] = value;
                        _currentSettings?['hideTodayAppointments'] = value;
                        _currentSettings?['hideCalled'] = value;
                        _currentSettings?['hideServedInCalled'] = value;
                        _currentSettings?['hideServedAndTransferredInCalled'] =
                            value;
                        _currentSettings?['hideHoldedTokens'] = value;
                        _currentSettings?['hideHoldedQueue'] = value;
                        _currentSettings?['hideCancelled'] = value;
                        _currentSettings?['hideCancelledAppointments'] = value;
                        updateSettings(
                          _context,
                          ('Navigation Menu'),
                        );
                        hideSideMenusetState(() {});
                      },
                    ),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 4,
                      child: Text(
                        ('Hide Next to Call'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Switch(
                          value: _currentSettings?['hideNextToCall'] ?? false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideNextToCall'] = value;
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                              setState(() {});
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 4,
                      child: Text(
                        ('Hide Today Appointments'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Switch(
                          value: _currentSettings?['hideTodayAppointments'] ??
                              false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideTodayAppointments'] =
                                  value;
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                              setState(() {});
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 4,
                      child: Text(
                        ('Hide Called'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _hideCalledSetState = setState;
                      return Switch(
                          value: _currentSettings?['hideCalled'] ?? false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideCalled'] = value;

                              _currentSettings?['hideServedInCalled'] = value;

                              _currentSettings?[
                                  'hideServedAndTransferredInCalled'] = value;

                              if (_hideCalledSetState != null &&
                                  _hideServedSetState != null &&
                                  _hideServedTransferSetState != null) {
                                _hideCalledSetState!(() {});
                                _hideServedSetState!(() {});
                                _hideServedTransferSetState!(() {});
                              }
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Text(
                      ('Hide Served'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _hideServedSetState = setState;
                      return Switch(
                          value:
                              _currentSettings?['hideServedInCalled'] ?? false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideCalled'] &&
                                !_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideServedInCalled'] = value;

                              _currentSettings?[
                                  'hideServedAndTransferredInCalled'] = value;
                              if (_hideCalledSetState != null &&
                                  _hideServedSetState != null &&
                                  _hideServedTransferSetState != null) {
                                _hideCalledSetState!(() {});
                                _hideServedSetState!(() {});
                                _hideServedTransferSetState!(() {});
                              }
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Text(
                      ('Hide Served & Transferred'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _hideServedTransferSetState = setState;
                      return Switch(
                          value: _currentSettings?[
                                  'hideServedAndTransferredInCalled'] ??
                              false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu'] &&
                                !_currentSettings?['hideCalled'] &&
                                !_currentSettings?['hideServedInCalled']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?[
                                  'hideServedAndTransferredInCalled'] = value;

                              if (_hideCalledSetState != null &&
                                  _hideServedSetState != null &&
                                  _hideServedTransferSetState != null) {
                                _hideCalledSetState!(() {});
                                _hideServedSetState!(() {});
                                _hideServedTransferSetState!(() {});
                              }
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Text(
                      ('Hide Holded Tokens'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Switch(
                          value: _currentSettings?['hideHoldedTokens'] ?? false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideHoldedTokens'] = value;
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                              setState(() {});
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Text(
                      ('Hide Holded Queue'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Switch(
                          value: _currentSettings?['hideHoldedQueue'] ?? false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideHoldedQueue'] = value;
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                              setState(() {});
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Text(
                      ('Hide Cancelled'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Switch(
                          value: _currentSettings?['hideCancelled'] ?? false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideCancelled'] = value;
                              updateSettings(
                                _context,
                                'Navigation Menu',
                              );
                              setState(() {});
                            }
                          });
                    }),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 4,
                    child: Text(
                      ('Hide Cancelled Appointments'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Switch(
                          value:
                              _currentSettings?['hideCancelledAppointments'] ??
                                  false,
                          onChanged: (value) {
                            if (!_currentSettings?['hideSideMenu']) {
                              _isTabRebuildNeededAfterPop = true;
                              _currentSettings?['hideCancelledAppointments'] =
                                  value;
                              updateSettings(
                                _context,
                                ('Navigation Menu'),
                              );
                              setState(() {});
                            }
                          });
                    }),
                  )
                ],
              ),
            ],
          );
        }),
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
