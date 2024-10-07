// // ignore_for_file: use_build_context_synchronously
// import 'dart:async';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// // import 'package:oneappcounter/common/widgets/button/custom_button.dart';
// import 'package:oneappcounter/core/config/constants.dart';
// import 'package:oneappcounter/functions/general_functions.dart';
// import 'package:oneappcounter/model/counter_settings_model.dart';
// import 'package:oneappcounter/model/service_model.dart';
// import 'package:oneappcounter/services/counter_setting_service.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/set_device_service.dart';
// import 'package:oneappcounter/services/socket_services.dart';
// import 'package:oneappcounter/services/splash_services.dart';
// import 'package:oneappcounter/services/utility_services.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   Map<String, dynamic>? _currentSettings =
//       CounterSettingService.counterSettings?.toJson();
//   static bool _isTabRebuildNeededAfterPop = false;
//   static bool _isHomeRebuildNeededAfterPop = false;
//   static bool _isSettingsUpdating = false;

//   final alertTimeController = TextEditingController();

//   final uidController = TextEditingController();

//   ///setstate functions
//   StateSetter? _alertTransferSetState;

//   StateSetter? _requiredTransferSetState;

//   ///side menu

//   StateSetter? _hideCalledSetState;

//   StateSetter? _hideServedSetState;

//   StateSetter? _hideServedTransferSetState;

//   StateSetter? _autoGridViewAfterServeSetState;

//   StateSetter? _autoGridViewAfterTransferSetState;

//   StateSetter? multipleTransferAtATimeSetState;

//   StateSetter? rebuildAllSetState;

//   List<ServiceModel> selectedServices =
//       GeneralDataService.activeServices.where((element) {
//     List transferServices =
//         CounterSettingService.counterSettings?.transferServices ?? [];
//     if (transferServices.contains(element.id)) {
//       return true;
//     }
//     return false;
//   }).toList();

//   late BuildContext _context;

//   late StreamSubscription rebuildRequired;

//   Future<void> updateSettings(BuildContext context, String message) async {
//     _isSettingsUpdating = true;
//     UtilityService.showLoadingAlert(context);
//     if (_currentSettings != null) {
//       await CounterSettingService.updateSettingsLocaly(
//         _currentSettings!,
//         callAPi: false,
//       );
//     }
//     Navigator.pop(context);
//     // await LanguageService.changeLocaleFn(context);
//     UtilityService.toast(context, '$message ${('Settings Updated')}');
//     _isHomeRebuildNeededAfterPop = true;
//     _isSettingsUpdating = false;
//   }

//   @override
//   void initState() {
//     super.initState();
//     rebuildRequired = SocketService.settingsPageRebuildRequiredController.stream
//         .listen((event) async {
//       if (event) {
//         updateMainVaribale();
//         rebuildAllSetState != null ? rebuildAllSetState!(() {}) : null;

//         /// as build context need to be passed to change locale function, so all switching tab should call same function
//         // await LanguageService.changeLocaleFn(context);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     try {
//       rebuildRequired.cancel();
//     } catch (_) {}
//     super.dispose();
//   }

//   void updateMainVaribale() {
//     _currentSettings = CounterSettingService.counterSettings?.toJson();
//     selectedServices = GeneralDataService.activeServices.where((element) {
//       List transferServices =
//           CounterSettingService.counterSettings?.transferServices;
//       if (transferServices.contains(element.id)) {
//         return true;
//       }
//       return false;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     _context = context;
//     alertTimeController.text = _currentSettings?['alertTime'].toString() ?? '';
//     // ignore: deprecated_member_use
//     return WillPopScope(
//       onWillPop: () async {
//         UtilityService.showLoadingAlert(context);
//         await waitWhile(() => _isSettingsUpdating);
//         await SetDeviceService.addCounterAppDetails();
//         await GeneralDataService.getTodayTokenDetails();
//         Navigator.pop(context);
//         Navigator.pop(
//           context,
//           {
//             'tab': _isTabRebuildNeededAfterPop,
//             'home': _isHomeRebuildNeededAfterPop
//           },
//         );
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor:
//               isDarkMode ? bottomsheetDarkcolor : appBackgrondcolor,
//           automaticallyImplyLeading: false,
//           title: const Text(
//             'Settings',
//             style: TextStyle(
//                 color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 UtilityService.showLoadingAlert(context);
//                 await waitWhile(() => _isSettingsUpdating);
//                 await SetDeviceService.addCounterAppDetails();
//                 await GeneralDataService.getTodayTokenDetails();
//                 Navigator.pop(context);
//                 Navigator.pop(
//                   context,
//                   {
//                     'tab': _isTabRebuildNeededAfterPop,
//                     'home': _isHomeRebuildNeededAfterPop
//                   },
//                 );
//               },
//               icon: const Icon(
//                 Icons.keyboard_arrow_down_outlined,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//           ],
//         ),
//         body: Container(
//           padding: const EdgeInsets.all(10),
//           child: StatefulBuilder(
//               builder: (BuildContext context, StateSetter allPageSetState) {
//             rebuildAllSetState = allPageSetState;
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: DropdownSearch<ServiceModel>.multiSelection(
//                           compareFn: (item1, current) {
//                             if (item1.id == current.id) {
//                               return true;
//                             }
//                             return false;
//                           },
//                           selectedItems: selectedServices,
//                           items: GeneralDataService.activeServices,
//                           popupProps: const PopupPropsMultiSelection.dialog(
//                             showSearchBox: true,
//                           ),
//                           dropdownDecoratorProps: const DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                               labelText: ("Transfer Service"),
//                               hintText: ("Transfer Service"),
//                             ),
//                           ),
//                           itemAsString: (value) {
//                             return value.displayName;
//                           },
//                           onChanged: (value) {
//                             _currentSettings?['transferServices'] != null
//                                 ? _currentSettings!['transferServices'].clear()
//                                 : _currentSettings?['transferServices'] = [];
//                             for (var item in value) {
//                               _currentSettings?['transferServices']
//                                   .add(item.id);
//                             }
//                             updateSettings(
//                               context,
//                               ('Transfer Service'),
//                             );
//                           },
//                         ),
//                       )
//                     ],
//                   ),
//                   const Divider(),
//                   // Row(
//                   //   children: [
//                   //     Expanded(
//                   //       child: DropdownSearch<LanguageModel>(
//                   //         compareFn: (item1, current) {
//                   //           if (item1.code == current.code) {
//                   //             return true;
//                   //           }
//                   //           return false;
//                   //         },
//                   //         selectedItem: LanguageService.getCurrentLanguage(),
//                   //         items: LanguageService.languageList,
//                   //         popupProps: const PopupProps.dialog(),
//                   //         dropdownDecoratorProps: DropDownDecoratorProps(
//                   //           dropdownSearchDecoration: InputDecoration(
//                   //             labelText: translate("Language"),
//                   //             hintText: translate("Language"),
//                   //           ),
//                   //         ),
//                   //         itemAsString: (value) {
//                   //           return value.nativeName;
//                   //         },
//                   //         onChanged: (value) {
//                   //           ///make sure convert to entity so when server based languge is applying won't affect deeply\
//                   //           ///can simply eleminate many code changes.
//                   //           _currentSettings?['language'] != null
//                   //               ? _currentSettings!['language'].clear()
//                   //               : _currentSettings?['language'] = [];
//                   //           Map<String, dynamic> val = value!.toJsonEntity();
//                   //           _currentSettings?['language'].add(val);
//                   //           updateSettings(
//                   //             context,
//                   //             ('Language'),
//                   //           );
//                   //         },
//                   //       ),
//                   //     )
//                   //   ],
//                   // ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   buildGeneralCard(),
//                   buildSideMenuCard(),
//                   buildButtonsCard(),
//                   buildGridViewCard(),
//                   buildMiscellaneousCard(),

//                   const SizedBox(
//                     height: 20,
//                   ),

//                   ///apply uid button.
//                   ///
//                   const Divider(),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: TextFormField(
//                           controller: uidController,
//                           keyboardType: TextInputType.number,
//                           decoration:
//                               const InputDecoration(hintText: 'Enter UID'),
//                         ),
//                       ),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             if (uidController.text.isNotEmpty) {
//                               UtilityService.showLoadingAlert(context);
//                               var response = await CounterSettingService
//                                   .updateCounterWithUid(
//                                 uid: int.parse(uidController.text),
//                               );
//                               Navigator.pop(context);
//                               if (response is CounterSettingsModel) {
//                                 updateMainVaribale();
//                                 allPageSetState(() {});
//                                 return;
//                               }
//                               UtilityService.toast(
//                                   context, 'Something went wrong');
//                               return;
//                             }
//                             UtilityService.toast(context, 'Please enter uid');
//                           },
//                           child: const Text('APPLY'),
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Version ${SplashScreenService.appVersion}')
//                     ],
//                   )
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget buildGeneralCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             const Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     ('General'),
//                     style: TextStyle(
//                       fontSize: 22,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const Divider(),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Recall Unhold Token?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                       value: _currentSettings?['recallUnholdToken'] ?? false,
//                       onChanged: (value) {
//                         _currentSettings?['recallUnholdToken'] = value;

//                         updateSettings(
//                           context,
//                           ('General'),
//                         );
//                         setState(() {});
//                       },
//                     );
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Alert Transfer'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     )),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     _alertTransferSetState = setState;
//                     return Switch(
//                         value: _currentSettings?['alertTransfer'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['alertTransfer'] = value;
//                           if (value &&
//                               _currentSettings?['requireTransfer'] == true) {
//                             _currentSettings?['requireTransfer'] = false;
//                           }
//                           if (_requiredTransferSetState != null &&
//                               _alertTransferSetState != null) {
//                             _requiredTransferSetState!(() {});
//                             _alertTransferSetState!(() {});
//                           }
//                           updateSettings(
//                             context,
//                             ('General'),
//                           );
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Alert Time (in seconds)'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: TextFormField(
//                     controller: alertTimeController,
//                     onChanged: (value) {
//                       _currentSettings?['alertTime'] = alertTimeController.text;
//                       updateSettings(
//                         _context,
//                         ('General'),
//                       );
//                     },
//                   ),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Require Transfer Service?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     _requiredTransferSetState = setState;
//                     return Switch(
//                         value: _currentSettings?['requireTransfer'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['requireTransfer'] = value;
//                           if (value &&
//                               _currentSettings?['alertTransfer'] == true) {
//                             _currentSettings?['alertTransfer'] = false;
//                           }

//                           if (_requiredTransferSetState != null &&
//                               _alertTransferSetState != null) {
//                             _requiredTransferSetState!(() {});
//                             _alertTransferSetState!(() {});
//                           }
//                           updateSettings(
//                             _context,
//                             ('General'),
//                           );
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Notification?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['notification'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['notification'] = value;
//                           updateSettings(
//                             _context,
//                             ('General'),
//                           );
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Notification Sound?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['notificationSound'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['notificationSound'] = value;

//                           updateSettings(
//                             _context,
//                             ('General'),
//                           );
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Show Token Priority?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['showPriority'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['showPriority'] = value;
//                           updateSettings(
//                             _context,
//                             ('General'),
//                           );
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildSideMenuCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter hideSideMenusetState) {
//           return Column(
//             children: [
//               const Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       ('Navigation Menu'),
//                       style: TextStyle(
//                         fontSize: 22,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const Divider(),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Hide Navigation Menu (Token and Appointment)?'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Switch(
//                       value: _currentSettings?['hideSideMenu'] ?? false,
//                       onChanged: (value) {
//                         _isTabRebuildNeededAfterPop = true;
//                         _currentSettings?['hideSideMenu'] = value;
//                         _currentSettings?['hideNextToCall'] = value;
//                         _currentSettings?['hideTodayAppointments'] = value;
//                         _currentSettings?['hideCalled'] = value;
//                         _currentSettings?['hideServedInCalled'] = value;
//                         _currentSettings?['hideServedAndTransferredInCalled'] =
//                             value;
//                         _currentSettings?['hideHoldedTokens'] = value;
//                         _currentSettings?['hideHoldedQueue'] = value;
//                         _currentSettings?['hideCancelled'] = value;
//                         _currentSettings?['hideCancelledAppointments'] = value;
//                         updateSettings(
//                           _context,
//                           ('Navigation Menu'),
//                         );
//                         hideSideMenusetState(() {});
//                       },
//                     ),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                       flex: 4,
//                       child: Text(
//                         ('Hide Next to Call'),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value: _currentSettings?['hideNextToCall'] ?? false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideNextToCall'] = value;
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                       flex: 4,
//                       child: Text(
//                         ('Hide Today Appointments'),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value: _currentSettings?['hideTodayAppointments'] ??
//                               false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideTodayAppointments'] =
//                                   value;
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                       flex: 4,
//                       child: Text(
//                         ('Hide Called'),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       _hideCalledSetState = setState;
//                       return Switch(
//                           value: _currentSettings?['hideCalled'] ?? false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideCalled'] = value;

//                               _currentSettings?['hideServedInCalled'] = value;

//                               _currentSettings?[
//                                   'hideServedAndTransferredInCalled'] = value;

//                               if (_hideCalledSetState != null &&
//                                   _hideServedSetState != null &&
//                                   _hideServedTransferSetState != null) {
//                                 _hideCalledSetState!(() {});
//                                 _hideServedSetState!(() {});
//                                 _hideServedTransferSetState!(() {});
//                               }
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Hide Served'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       _hideServedSetState = setState;
//                       return Switch(
//                           value:
//                               _currentSettings?['hideServedInCalled'] ?? false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideCalled'] &&
//                                 !_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideServedInCalled'] = value;

//                               _currentSettings?[
//                                   'hideServedAndTransferredInCalled'] = value;
//                               if (_hideCalledSetState != null &&
//                                   _hideServedSetState != null &&
//                                   _hideServedTransferSetState != null) {
//                                 _hideCalledSetState!(() {});
//                                 _hideServedSetState!(() {});
//                                 _hideServedTransferSetState!(() {});
//                               }
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Hide Served & Transferred'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       _hideServedTransferSetState = setState;
//                       return Switch(
//                           value: _currentSettings?[
//                                   'hideServedAndTransferredInCalled'] ??
//                               false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu'] &&
//                                 !_currentSettings?['hideCalled'] &&
//                                 !_currentSettings?['hideServedInCalled']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?[
//                                   'hideServedAndTransferredInCalled'] = value;

//                               if (_hideCalledSetState != null &&
//                                   _hideServedSetState != null &&
//                                   _hideServedTransferSetState != null) {
//                                 _hideCalledSetState!(() {});
//                                 _hideServedSetState!(() {});
//                                 _hideServedTransferSetState!(() {});
//                               }
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Hide Holded Tokens'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value: _currentSettings?['hideHoldedTokens'] ?? false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideHoldedTokens'] = value;
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Hide Holded Queue'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value: _currentSettings?['hideHoldedQueue'] ?? false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideHoldedQueue'] = value;
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Hide Cancelled'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value: _currentSettings?['hideCancelled'] ?? false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideCancelled'] = value;
//                               updateSettings(
//                                 _context,
//                                 'Navigation Menu',
//                               );
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Hide Cancelled Appointments'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value:
//                               _currentSettings?['hideCancelledAppointments'] ??
//                                   false,
//                           onChanged: (value) {
//                             if (!_currentSettings?['hideSideMenu']) {
//                               _isTabRebuildNeededAfterPop = true;
//                               _currentSettings?['hideCancelledAppointments'] =
//                                   value;
//                               updateSettings(
//                                 _context,
//                                 ('Navigation Menu'),
//                               );
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Widget buildButtonsCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             const Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     ('Buttons'),
//                     style: TextStyle(
//                       fontSize: 22,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const Divider(),
//             Row(
//               children: [
//                 const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Always disable Serve'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     )),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value:
//                             _currentSettings?['alwaysDisableServeBtn'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['alwaysDisableServeBtn'] = value;
//                           updateSettings(_context, ('Buttons'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Always disable Recall'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     )),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['alwaysDisableRecallBtn'] ??
//                             false,
//                         onChanged: (value) {
//                           _currentSettings?['alwaysDisableRecallBtn'] = value;

//                           updateSettings(_context, ('Buttons'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Always disable No Show'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     )),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['alwaysDisableNoShowBtn'] ??
//                             false,
//                         onChanged: (value) {
//                           _currentSettings?['alwaysDisableNoShowBtn'] = value;
//                           updateSettings(_context, ('Buttons'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Always disable Call Next'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['alwaysDisableCallNextBtn'] ??
//                             false,
//                         onChanged: (value) {
//                           _currentSettings?['alwaysDisableCallNextBtn'] = value;
//                           updateSettings(_context, ('Buttons'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Always disable Hold'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value:
//                             _currentSettings?['alwaysDisableHoldBtn'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['alwaysDisableHoldBtn'] = value;
//                           updateSettings(_context, ('Buttons'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Never show Service Hold'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['neverShowServiceHoldBtn'] ??
//                             false,
//                         onChanged: (value) {
//                           _currentSettings?['neverShowServiceHoldBtn'] = value;
//                           updateSettings(_context, ('Buttons'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildGridViewCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: StatefulBuilder(builder:
//             (BuildContext context, StateSetter enableGridViewSetState) {
//           return Column(
//             children: [
//               const Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       ('Grid View'),
//                       style: TextStyle(
//                         fontSize: 22,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const Divider(),
//               Row(
//                 children: [
//                   const Expanded(
//                       flex: 4,
//                       child: Text(
//                         ('Enable Grid View'),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                   Expanded(
//                     child: Switch(
//                         value: _currentSettings?['enableGridView'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['enableGridView'] = value;

//                           if (!value) {
//                             _currentSettings?['showNotTransferredInNoShow'] =
//                                 value;
//                             _currentSettings?['autoGridViewAfterServe'] = value;
//                             _currentSettings?['autoGridViewAfterTransfer'] =
//                                 value;
//                             _currentSettings?['autoGridViewAfterNoShow'] =
//                                 value;
//                             _currentSettings?['autoGridViewAfterHold'] = value;
//                           }
//                           updateSettings(_context, ('Grid View'));
//                           enableGridViewSetState(() {});
//                         }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                       flex: 4,
//                       child: Text(
//                         ('Show NOT Transferred in No Show Section'),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value:
//                               _currentSettings?['showNotTransferredInNoShow'] ??
//                                   false,
//                           onChanged: (value) {
//                             if (_currentSettings?['enableGridView']) {
//                               _currentSettings?['showNotTransferredInNoShow'] =
//                                   value;
//                               updateSettings(_context, ('Grid View'));
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               Row(
//                 children: [
//                   const Expanded(
//                       flex: 4,
//                       child: Text(
//                         ('Show Holded in No Show Section'),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value:
//                               _currentSettings?['showHoldedInNoShow'] ?? false,
//                           onChanged: (value) {
//                             if (_currentSettings?['enableGridView']) {
//                               _currentSettings?['showHoldedInNoShow'] = value;
//                               updateSettings(_context, ('Grid View'));
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                       flex: 4,
//                       child: Text(
//                         ('Goto Grid View after Serving'),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       _autoGridViewAfterServeSetState = setState;

//                       return Switch(
//                           value: _currentSettings?['autoGridViewAfterServe'] ??
//                               false,
//                           onChanged: (value) {
//                             if (_currentSettings?['enableGridView']) {
//                               _currentSettings?['autoGridViewAfterServe'] =
//                                   value;
//                               if (value) {
//                                 _currentSettings?['autoGridViewAfterTransfer'] =
//                                     false;
//                               }
//                             }
//                             updateSettings(_context, ('Grid View'));
//                             _autoGridViewAfterTransferSetState!(() {});
//                             _autoGridViewAfterServeSetState!(() {});
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Goto Grid View after Transferring'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       _autoGridViewAfterTransferSetState = setState;
//                       return Switch(
//                           value:
//                               _currentSettings?['autoGridViewAfterTransfer'] ??
//                                   false,
//                           onChanged: (value) {
//                             if (_currentSettings?['enableGridView']) {
//                               _currentSettings?['autoGridViewAfterTransfer'] =
//                                   value;
//                               if (value) {
//                                 _currentSettings?['autoGridViewAfterServe'] =
//                                     false;
//                               }
//                               updateSettings(_context, ('Grid View'));
//                               _autoGridViewAfterTransferSetState!(() {});
//                               _autoGridViewAfterServeSetState!(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Goto Grid View after No Show'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['autoGridViewAfterNoShow'] ??
//                             false,
//                         onChanged: (value) {
//                           if (_currentSettings?['enableGridView']) {
//                             _currentSettings?['autoGridViewAfterNoShow'] =
//                                 value;
//                             updateSettings(_context, ('Grid View'));
//                             setState(() {});
//                           }
//                         });
//                   }))
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Goto Grid View after Hold'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, StateSetter setState) {
//                       return Switch(
//                           value: _currentSettings?['autoGridViewAfterHold'] ??
//                               false,
//                           onChanged: (value) {
//                             if (_currentSettings?['enableGridView']) {
//                               _currentSettings?['autoGridViewAfterHold'] =
//                                   value;
//                               updateSettings(_context, ('Grid View'));
//                               setState(() {});
//                             }
//                           });
//                     }),
//                   )
//                 ],
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

//   Widget buildMiscellaneousCard() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             const Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     ('Miscellaneous'),
//                     style: TextStyle(
//                       fontSize: 22,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Pinned Application ?'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     )),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['alwaysOnTop'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['alwaysOnTop'] = value;
//                           updateSettings(_context, ('Miscellaneous'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                     flex: 4,
//                     child: Text(
//                       ('Prevent Screenlock ?'),
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     )),
//                 Expanded(child: StatefulBuilder(
//                     builder: (BuildContext context, StateSetter setState) {
//                   return Switch(
//                       value: _currentSettings?['wakeLockEnabled'] ?? false,
//                       onChanged: (value) {
//                         _currentSettings?['wakeLockEnabled'] = value;
//                         updateSettings(_context, ('Miscellaneous'));
//                         setState(() {});
//                       });
//                 }))
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Full screen ?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['enableFullScreen'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['enableFullScreen'] = value;
//                           updateSettings(_context, ('Miscellaneous'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Multiple Transfer?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['multipleTransfer'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['multipleTransfer'] = value;
//                           if (!value) {
//                             _currentSettings?['multipleTransferAtATime'] =
//                                 false;
//                           }
//                           updateSettings(_context, ('Miscellaneous'));
//                           setState(() {});
//                           multipleTransferAtATimeSetState!(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             const Divider(),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Concurrent transfer?'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     multipleTransferAtATimeSetState = setState;
//                     return Switch(
//                         value: _currentSettings?['multipleTransferAtATime'] ??
//                             false,
//                         onChanged: (value) {
//                           if (_currentSettings?['multipleTransfer']) {
//                             _currentSettings?['multipleTransferAtATime'] =
//                                 value;
//                             updateSettings(_context, ('Miscellaneous'));
//                             setState(() {});
//                           }
//                         });
//                   }),
//                 )
//               ],
//             ),
//             kDivider,
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Can Add Tab'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['canAddTab'] ?? true,
//                         onChanged: (value) {
//                           _currentSettings?['canAddTab'] = value;
//                           updateSettings(_context, ('Miscellaneous'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             kDivider,
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Can Remove This Tab'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['canRemoveTab'] ?? true,
//                         onChanged: (value) {
//                           _currentSettings?['canRemoveTab'] = value;
//                           updateSettings(_context, ('Miscellaneous'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             kDivider,
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Hide Settings Button'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['hideSettingsBtn'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['hideSettingsBtn'] = value;
//                           updateSettings(_context, ('Miscellaneous'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             kDivider,
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   flex: 4,
//                   child: Text(
//                     ('Hide Service Edit Button'),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Switch(
//                         value: _currentSettings?['hideServiceEditBtn'] ?? false,
//                         onChanged: (value) {
//                           _currentSettings?['hideServiceEditBtn'] = value;
//                           updateSettings(_context, ('Miscellaneous'));
//                           setState(() {});
//                         });
//                   }),
//                 )
//               ],
//             ),
//             kDivider,
//             const SizedBox(
//               height: 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:oneappcounter/core/config/constants.dart';
import 'package:oneappcounter/functions/general_functions.dart';
import 'package:oneappcounter/model/counter_settings_model.dart';
import 'package:oneappcounter/model/language_model.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/language_service.dart';
import 'package:oneappcounter/services/set_device_service.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/splash_services.dart';
import 'package:oneappcounter/services/utility_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? _currentSettings =
      CounterSettingService.counterSettings?.toJson();
  static bool _isTabRebuildNeededAfterPop = false;
  static bool _isHomeRebuildNeededAfterPop = false;
  static bool _isSettingsUpdating = false;

  final alertTimeController = TextEditingController();

  final uidController = TextEditingController();

  ///setstate functions
  StateSetter? _alertTransferSetState;

  StateSetter? _requiredTransferSetState;

  ///side menu

  StateSetter? _hideCalledSetState;

  StateSetter? _hideServedSetState;

  StateSetter? _hideServedTransferSetState;

  StateSetter? _autoGridViewAfterServeSetState;

  StateSetter? _autoGridViewAfterTransferSetState;

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
    await LanguageService.changeLocaleFn(context);
    final String langText = translate(message);
    UtilityService.toast(context, '$langText ${translate('Settings Updated')}');
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
        await LanguageService.changeLocaleFn(context);
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
    _context = context;
    alertTimeController.text = _currentSettings?['alertTime'].toString() ?? '';
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
          automaticallyImplyLeading: false,
          backgroundColor:
              isDarkMode ? bottomsheetDarkcolor : appBackgrondcolor,
          title: Text(
            translate('Settings'),
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                UtilityService.showLoadingAlert(context);
                await waitWhile(() => _isSettingsUpdating);
                await SetDeviceService.addCounterAppDetails();
                await GeneralDataService.getTodayTokenDetails();
                await GeneralDataService.selectThisTab(
                  index: GeneralDataService.currentServiceCounterTabIndex,
                  thisTab: GeneralDataService.getTabs()[
                      GeneralDataService.currentServiceCounterTabIndex],
                );

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
                size: 35,
                color: Colors.white,
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
                          items: GeneralDataService.activeServices
                              .where((element) => !GeneralDataService.getTabs()[
                                      GeneralDataService
                                          .currentServiceCounterTabIndex]
                                  .services
                                  .map((e) => e.id)
                                  .toList()
                                  .contains(element.id))
                              .toList(),
                          popupProps: const PopupPropsMultiSelection.dialog(
                            showSearchBox: true,
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: translate("Transfer Service"),
                              hintText: translate("Transfer Service"),
                            ),
                          ),
                          itemAsString: (value) {
                            return value.displayName;
                          },
                          onChanged: (value) {
                            _currentSettings?['transferServices'] != null
                                ? _currentSettings!['transferServices'].clear()
                                : _currentSettings?['transferServices'] = [];
                            for (var _item in value) {
                              _currentSettings?['transferServices']
                                  .add(_item.id);
                            }
                            updateSettings(
                              context,
                              translate('Transfer Service'),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  // kDivider,
                  Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<LanguageModel>(
                          compareFn: (item1, current) {
                            if (item1.code == current.code) {
                              return true;
                            }
                            return false;
                          },
                          selectedItem: LanguageService.getCurrentLanguage(),
                          items: LanguageService.languageList,
                          popupProps: const PopupProps.dialog(),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: translate("Language"),
                              hintText: translate("Language"),
                            ),
                          ),
                          itemAsString: (value) {
                            return value.nativeName;
                          },
                          onChanged: (value) async {
                            ///make sure convert to entity so when server based languge is applying won't affect deeply\
                            ///can simply eleminate many code changes.
                            _currentSettings?['language'] != null
                                ? _currentSettings!['language'].clear()
                                : _currentSettings?['language'] = [];
                            Map<String, dynamic> val = value!.toJsonEntity();
                            _currentSettings?['language'].add(val);

                            UtilityService.showLoadingAlert(context);
                            updateSettings(
                              context,
                              'Language',
                            );

                            await GeneralDataService
                                .initServiceAndCounterData();
                            await GeneralDataService.selectThisTab(
                              index: GeneralDataService
                                  .currentServiceCounterTabIndex,
                              thisTab: GeneralDataService.getTabs()[
                                  GeneralDataService
                                      .currentServiceCounterTabIndex],
                            );
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildGeneralCard(),
                  _buildSideMenuCard(),
                  _buildButtonsCard(),
                  _buildGridViewCard(),
                  _buildMiscellaneousCard(),

                  const SizedBox(
                    height: 20,
                  ),

                  ///apply uid button.
                  ///
                  kDivider,
                  const SizedBox(
                    height: 25,
                  ),
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
                        child: ElevatedButton(
                          onPressed: () async {
                            if (uidController.text.isNotEmpty) {
                              UtilityService.showLoadingAlert(context);
                              var response = await CounterSettingService
                                  .updateCounterWithUid(
                                uid: int.parse(uidController.text),
                              );
                              Navigator.pop(context);
                              if (response is CounterSettingsModel) {
                                updateMainVaribale();
                                allPageSetState(() {});
                                return;
                              }
                              UtilityService.toast(
                                  context, 'Something went wrong');
                              return;
                            }
                            UtilityService.toast(context, 'Please enter uid');
                          },
                          child: const Text('APPLY'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Version ${SplashScreenService.appVersion}')
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

  Widget _buildGeneralCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    translate('General'),
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                )
              ],
            ),
            kDivider,
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Recall Unhold Token?'),
                    style: const TextStyle(
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
                          translate('General'),
                        );
                        setState(() {});
                      },
                    );
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      translate('Alert Transfer'),
                      style: const TextStyle(
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
                            translate('General'),
                          );
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Alert Time (in seconds)'),
                    style: const TextStyle(
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
                        translate('General'),
                      );
                    },
                  ),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Require Transfer Service?'),
                    style: const TextStyle(
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
                            translate('General'),
                          );
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Notification?'),
                    style: const TextStyle(
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
                            translate('General'),
                          );
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Notification Sound?'),
                    style: const TextStyle(
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
                            translate('General'),
                          );
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Show Token Priority?'),
                    style: const TextStyle(
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
                            translate('General'),
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

  Widget _buildSideMenuCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter _hideSideMenusetState) {
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      translate('Navigation Menu'),
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  )
                ],
              ),
              kDivider,
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate(
                          'Hide Navigation Menu (Token and Appointment)?'),
                      style: const TextStyle(
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
                        _currentSettings?['hideCancelBtnInNextToCall'] = value;
                        _currentSettings?['hideHoldBtnInNextToCall'] = value;
                        _currentSettings?['hideTodayAppointments'] = value;
                        _currentSettings?['hideCancelBtnInTodayAppointments'] =
                            value;
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
                          translate('Navigation Menu'),
                        );
                        _hideSideMenusetState(() {});
                      },
                    ),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Hide Next to Call'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideSideMenu'] ? 0.5 : 1,
                        child: Switch(
                            value: _currentSettings?['hideNextToCall'] ?? false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideSideMenu']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?['hideNextToCall'] = value;
                                _currentSettings?['hideCancelBtnInNextToCall'] =
                                    value;
                                _currentSettings?['hideHoldBtnInNextToCall'] =
                                    value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Hide Cancel Button In Next to Call'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideNextToCall'] ? 0.5 : 1,
                        child: Switch(
                            value: _currentSettings?[
                                    'hideCancelBtnInNextToCall'] ??
                                false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideNextToCall']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?['hideCancelBtnInNextToCall'] =
                                    value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Hide Hold Button In Next to Call'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideNextToCall'] ? 0.5 : 1,
                        child: Switch(
                            value:
                                _currentSettings?['hideHoldBtnInNextToCall'] ??
                                    false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideNextToCall']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?['hideHoldBtnInNextToCall'] =
                                    value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Hide Today Appointments'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideSideMenu'] ? 0.5 : 1,
                        child: Switch(
                            value: _currentSettings?['hideTodayAppointments'] ??
                                false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideSideMenu']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?['hideTodayAppointments'] =
                                    value;
                                _currentSettings?[
                                    'hideCancelBtnInTodayAppointments'] = value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Hide Cancel Button In Today Appointments'),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideTodayAppointments']
                            ? 0.5
                            : 1,
                        child: Switch(
                            value: _currentSettings?[
                                    'hideCancelBtnInTodayAppointments'] ??
                                false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideTodayAppointments']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?[
                                    'hideCancelBtnInTodayAppointments'] = value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Hide Called'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _hideCalledSetState = setState;
                      return Opacity(
                        opacity: _currentSettings?['hideSideMenu'] ? 0.5 : 1,
                        child: Switch(
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
                                  translate('Navigation Menu'),
                                );
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Hide Served'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _hideServedSetState = setState;
                      return Opacity(
                        opacity: _currentSettings?['hideCalled'] ? 0.5 : 1,
                        child: Switch(
                            value: _currentSettings?['hideServedInCalled'] ??
                                false,
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
                                  translate('Navigation Menu'),
                                );
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Hide Served & Transferred'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _hideServedTransferSetState = setState;
                      return Opacity(
                        opacity:
                            _currentSettings?['hideServedInCalled'] ? 0.5 : 1,
                        child: Switch(
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
                                  translate('Navigation Menu'),
                                );
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Hide Holded Tokens'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideSideMenu'] ? 0.5 : 1,
                        child: Switch(
                            value:
                                _currentSettings?['hideHoldedTokens'] ?? false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideSideMenu']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?['hideHoldedTokens'] = value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Hide Holded Queue'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideSideMenu'] ? 0.5 : 1,
                        child: Switch(
                            value:
                                _currentSettings?['hideHoldedQueue'] ?? false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideSideMenu']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?['hideHoldedQueue'] = value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Hide Cancelled'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideSideMenu'] ? 0.5 : 1,
                        child: Switch(
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
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Hide Cancelled Appointments'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['hideSideMenu'] ? 0.5 : 1,
                        child: Switch(
                            value: _currentSettings?[
                                    'hideCancelledAppointments'] ??
                                false,
                            onChanged: (value) {
                              if (!_currentSettings?['hideSideMenu']) {
                                _isTabRebuildNeededAfterPop = true;
                                _currentSettings?['hideCancelledAppointments'] =
                                    value;
                                updateSettings(
                                  _context,
                                  translate('Navigation Menu'),
                                );
                                setState(() {});
                              }
                            }),
                      );
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

  Widget _buildButtonsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    translate('Buttons'),
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                )
              ],
            ),
            kDivider,
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      translate('Always disable Serve'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value:
                            _currentSettings?['alwaysDisableServeBtn'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['alwaysDisableServeBtn'] = value;
                          updateSettings(_context, translate('Buttons'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      translate('Always disable Recall'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['alwaysDisableRecallBtn'] ??
                            false,
                        onChanged: (value) {
                          _currentSettings?['alwaysDisableRecallBtn'] = value;

                          updateSettings(_context, translate('Buttons'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      translate('Always disable No Show'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['alwaysDisableNoShowBtn'] ??
                            false,
                        onChanged: (value) {
                          _currentSettings?['alwaysDisableNoShowBtn'] = value;
                          updateSettings(_context, translate('Buttons'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Always disable Call Next'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['alwaysDisableCallNextBtn'] ??
                            false,
                        onChanged: (value) {
                          _currentSettings?['alwaysDisableCallNextBtn'] = value;
                          updateSettings(_context, translate('Buttons'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Always disable Hold'),
                    style: const TextStyle(
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
                            _currentSettings?['alwaysDisableHoldBtn'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['alwaysDisableHoldBtn'] = value;
                          updateSettings(_context, translate('Buttons'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Never show Service Hold'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['neverShowServiceHoldBtn'] ??
                            false,
                        onChanged: (value) {
                          _currentSettings?['neverShowServiceHoldBtn'] = value;
                          updateSettings(_context, translate('Buttons'));
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

  Widget _buildGridViewCard() {
    ///any changes in grid view message also apply to update function.cheking-
    /// rebuild varible for block is updating from update settings funtion.

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(builder:
            (BuildContext context, StateSetter _enableGridViewSetState) {
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      translate('Grid View'),
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  )
                ],
              ),
              kDivider,
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Enable Grid View'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: Switch(
                        value: _currentSettings?['enableGridView'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['enableGridView'] = value;

                          if (!value) {
                            _currentSettings?['showNotTransferredInNoShow'] =
                                value;
                            _currentSettings?['autoGridViewAfterServe'] = value;
                            _currentSettings?['autoGridViewAfterTransfer'] =
                                value;
                            _currentSettings?['autoGridViewAfterNoShow'] =
                                value;
                            _currentSettings?['autoGridViewAfterHold'] = value;
                          }
                          updateSettings(_context, translate('Grid View'));
                          _enableGridViewSetState(() {});
                        }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Show NOT Transferred in No Show Section'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['enableGridView'] ? 1 : 0.5,
                        child: Switch(
                            value: _currentSettings?[
                                    'showNotTransferredInNoShow'] ??
                                false,
                            onChanged: (value) {
                              if (_currentSettings?['enableGridView']) {
                                _currentSettings?[
                                    'showNotTransferredInNoShow'] = value;
                                updateSettings(
                                    _context, translate('Grid View'));
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,

              ///holded neeed to be implemented remainig...!
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Show Holded in No Show Section'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['enableGridView'] ? 1 : 0.5,
                        child: Switch(
                            value: _currentSettings?['showHoldedInNoShow'] ??
                                false,
                            onChanged: (value) {
                              if (_currentSettings?['enableGridView']) {
                                _currentSettings?['showHoldedInNoShow'] = value;
                                updateSettings(
                                    _context, translate('Grid View'));
                                setState(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        translate('Goto Grid View after Serving'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _autoGridViewAfterServeSetState = setState;

                      return Opacity(
                        opacity: _currentSettings?['enableGridView'] ? 1 : 0.5,
                        child: Switch(
                            value:
                                _currentSettings?['autoGridViewAfterServe'] ??
                                    false,
                            onChanged: (value) {
                              if (_currentSettings?['enableGridView']) {
                                _currentSettings?['autoGridViewAfterServe'] =
                                    value;
                                if (value) {
                                  _currentSettings?[
                                      'autoGridViewAfterTransfer'] = false;
                                }
                              }
                              updateSettings(_context, translate('Grid View'));
                              _autoGridViewAfterTransferSetState!(() {});
                              _autoGridViewAfterServeSetState!(() {});
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Goto Grid View after Transferring'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      _autoGridViewAfterTransferSetState = setState;
                      return Opacity(
                        opacity: _currentSettings?['enableGridView'] ? 1 : 0.5,
                        child: Switch(
                            value: _currentSettings?[
                                    'autoGridViewAfterTransfer'] ??
                                false,
                            onChanged: (value) {
                              if (_currentSettings?['enableGridView']) {
                                _currentSettings?['autoGridViewAfterTransfer'] =
                                    value;
                                if (value) {
                                  _currentSettings?['autoGridViewAfterServe'] =
                                      false;
                                }
                                updateSettings(
                                    _context, translate('Grid View'));
                                _autoGridViewAfterTransferSetState!(() {});
                                _autoGridViewAfterServeSetState!(() {});
                              }
                            }),
                      );
                    }),
                  )
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Goto Grid View after No Show'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Opacity(
                      opacity: _currentSettings?['enableGridView'] ? 1 : 0.5,
                      child: Switch(
                          value: _currentSettings?['autoGridViewAfterNoShow'] ??
                              false,
                          onChanged: (value) {
                            if (_currentSettings?['enableGridView']) {
                              _currentSettings?['autoGridViewAfterNoShow'] =
                                  value;
                              updateSettings(_context, translate('Grid View'));
                              setState(() {});
                            }
                          }),
                    );
                  }))
                ],
              ),
              kDivider,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      translate('Goto Grid View after Hold'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Opacity(
                        opacity: _currentSettings?['enableGridView'] ? 1 : 0.5,
                        child: Switch(
                            value: _currentSettings?['autoGridViewAfterHold'] ??
                                false,
                            onChanged: (value) {
                              if (_currentSettings?['enableGridView']) {
                                _currentSettings?['autoGridViewAfterHold'] =
                                    value;
                                updateSettings(
                                    _context, translate('Grid View'));
                                setState(() {});
                              }
                            }),
                      );
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

  Widget _buildMiscellaneousCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    translate('Miscellaneous'),
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      translate('Pinned Application ?'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['alwaysOnTop'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['alwaysOnTop'] = value;
                          updateSettings(_context, translate('Miscellaneous'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      translate('Prevent Screenlock ?'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                Expanded(child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Switch(
                      value: _currentSettings?['wakeLockEnabled'] ?? false,
                      onChanged: (value) {
                        _currentSettings?['wakeLockEnabled'] = value;
                        updateSettings(_context, translate('Miscellaneous'));
                        setState(() {});
                      });
                }))
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Full screen ?'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['enableFullScreen'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['enableFullScreen'] = value;
                          updateSettings(_context, translate('Miscellaneous'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Multiple Transfer?'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['multipleTransfer'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['multipleTransfer'] = value;
                          if (!value) {
                            _currentSettings?['multipleTransferAtATime'] =
                                false;
                          }
                          updateSettings(_context, translate('Miscellaneous'));
                          setState(() {});
                          multipleTransferAtATimeSetState!(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Concurrent transfer?'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    multipleTransferAtATimeSetState = setState;
                    return Switch(
                        value: _currentSettings?['multipleTransferAtATime'] ??
                            false,
                        onChanged: (value) {
                          if (_currentSettings?['multipleTransfer']) {
                            _currentSettings?['multipleTransferAtATime'] =
                                value;
                            updateSettings(
                                _context, translate('Miscellaneous'));
                            setState(() {});
                          }
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Can Add Tab'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['canAddTab'] ?? true,
                        onChanged: (value) {
                          _currentSettings?['canAddTab'] = value;
                          updateSettings(_context, translate('Miscellaneous'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Can Remove This Tab'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['canRemoveTab'] ?? true,
                        onChanged: (value) {
                          _currentSettings?['canRemoveTab'] = value;
                          updateSettings(_context, translate('Miscellaneous'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Hide Settings Button'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['hideSettingsBtn'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['hideSettingsBtn'] = value;
                          updateSettings(_context, translate('Miscellaneous'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Hide Service Edit Button'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['hideServiceEditBtn'] ?? false,
                        onChanged: (value) {
                          _currentSettings?['hideServiceEditBtn'] = value;
                          updateSettings(_context, translate('Miscellaneous'));
                          setState(() {});
                        });
                  }),
                )
              ],
            ),
            kDivider,
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    translate('Show Remarks Badge'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Switch(
                        value: _currentSettings?['showRemarksNotification'] ??
                            false,
                        onChanged: (value) {
                          _currentSettings?['showRemarksNotification'] = value;
                          updateSettings(_context, translate('Miscellaneous'));
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
}
