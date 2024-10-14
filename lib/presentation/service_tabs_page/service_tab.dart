// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
// import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
// import 'package:oneappcounter/core/config/constants.dart';
// import 'package:oneappcounter/model/service_counter_tab_model.dart';
// import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
// import 'package:oneappcounter/services/counter_setting_service.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/socket_services.dart';
// import 'package:oneappcounter/services/utility_services.dart';

// // ignore: must_be_immutable
// class ServiceCounterTab extends StatefulWidget {
//   const ServiceCounterTab({super.key});

//   @override
//   State<ServiceCounterTab> createState() => _ServiceCounterTabState();
// }

// class _ServiceCounterTabState extends State<ServiceCounterTab> {
//   late StateSetter _listSetState;

//   static bool isAlreadyLaunched = false;

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: isDarkMode ? bottomsheetDarkcolor : appBackgrondcolor,
//         title: const Text(('Service Tabs'),
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//             )),
//       ),
//       floatingActionButton: (CounterSettingService.counterSettings?.canAddTab ==
//               true)
//           ? FloatingActionButton(
//               onPressed: () async {
//                 await _showAddTabPopup(context, _listSetState,
//                     from: 'floating button click');
//               },
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(100)),
//               backgroundColor: Theme.of(context).brightness == Brightness.dark
//                   ? materialIconButtonDark
//                   : buttonColor,
//               child: Icon(
//                 Icons.add,
//                 size: 30,
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? Colors.black
//                     : Colors.white,
//               ),
//             )
//           : null,

//       // floatingActionButton: FloatingActionButton(
//       //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       //   onPressed: () async {
//       //     await _showAddTabPopup(context, _listSetState);
//       //   },
//       //   backgroundColor: Theme.of(context).brightness == Brightness.dark
//       //       ? materialIconButtonDark
//       //       : buttonColor,
//       //   child: Icon(Icons.add,
//       //       size: 30,
//       //       color: Theme.of(context).brightness == Brightness.dark
//       //           ? Colors.black
//       //           : Colors.white),
//       // ),
//       body: StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//         _listSetState = setState;
//         if (GeneralDataService.getTabs().isEmpty) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _showAddTabPopup(context, _listSetState, from: 'tabs empty')
//                 .then((value) async {
//               await SocketService().initialiseSocket();
//               await SocketService.registerEvents(isAll: true);
//             });
//           });
//         } else if (GeneralDataService.getTabs().isNotEmpty &&
//             GeneralDataService.getTabs()[
//                     GeneralDataService.currentServiceCounterTabIndex]
//                 .services
//                 .isEmpty) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _showAddTabPopup(context, _listSetState,
//                 editableService: GeneralDataService.getTabs()[
//                     GeneralDataService.currentServiceCounterTabIndex],
//                 editingIndex: GeneralDataService.currentServiceCounterTabIndex,
//                 from: 'service empty');
//           });
//         }
//         return ListView.separated(
//           itemBuilder: (context, index) {
//             ServiceCounterTabModel currentItem =
//                 GeneralDataService.getTabs()[index];
//             String titleServiceString = currentItem.serviceString;
//             return ListTile(
//               trailing: SizedBox(
//                 width: 100,
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () async {
//                         UtilityService.showLoadingAlert(context);
//                         await GeneralDataService.initServiceAndCounterData();
//                         Navigator.pop(context);
//                         showDialog(
//                             context: context,
//                             builder: (context) {
//                               return SetNewServiceTab(
//                                 editableService: currentItem,
//                                 editingIndex: index,
//                               );
//                             }).then((value) {
//                           _listSetState(() {});
//                         });
//                       },
//                       icon: const Icon(Icons.edit_note),
//                     ),
//                     !currentItem.selected
//                         ? IconButton(
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return AlertDialog(
//                                     title: const Text(('Delete')),
//                                     content: const Text(
//                                       ('Are you sure you want to do this?'),
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         child: const Text(('Cancel')),
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                       TextButton(
//                                         child: const Text(('Proceed')),
//                                         onPressed: () async {
//                                           UtilityService.showLoadingAlert(
//                                               context);
//                                           await GeneralDataService
//                                               .deleteServiceTab(index: index);
//                                           Navigator.pop(context);
//                                           Navigator.pop(context);
//                                           UtilityService.toast(
//                                               context, ('Tab deleted!'));
//                                           _listSetState(() {});
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                             icon: const Icon(Icons.delete))
//                         : Container(),
//                   ],
//                 ),
//               ),
//               selected: currentItem.selected,
//               selectedColor: !UtilityService.isDarkTheme ? buttonColor : null,
//               selectedTileColor: !UtilityService.isDarkTheme
//                   ? Colors.grey.shade300
//                   : Colors.grey.shade800,
//               isThreeLine: false,
//               dense: false,
//               contentPadding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   StreamBuilder<dynamic>(
//                     stream: SocketService.eventReceivedController.stream,
//                     builder: (context, snapshot) {
//                       if (!currentItem.selected &&
//                           snapshot.data is int &&
//                           currentItem.services
//                               .map((e) => e.id)
//                               .toList()
//                               .contains(snapshot.data)) {
//                         titleServiceString = '* ${currentItem.serviceString}';
//                       }
//                       return Text(
//                         titleServiceString,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     currentItem.counterString,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               onTap: () async {
//                 if (!currentItem.selected) {
//                   UtilityService.showLoadingAlert(context);
//                   await GeneralDataService.selectThisTab(
//                     index: index,
//                     thisTab: currentItem,
//                   );
//                   await SocketService.connectAfterSwitch();
//                   Navigator.pop(context);
//                   _listSetState(() {});
//                   BlocProvider.of<SettingsBloc>(context)
//                       .add(SettingsEventUpdated());
//                   return;
//                 }
//               },
//             );
//           },
//           separatorBuilder: (context, index) {
//             return const Divider(
//               height: 1,
//             );
//           },
//           itemCount: GeneralDataService.getTabs().isNotEmpty
//               ? GeneralDataService.getTabs().length
//               : 0,
//         );
//       }),
//     );
//   }

//   Future<void> _showAddTabPopup(
//     BuildContext context,
//     // ignore: no_leading_underscores_for_local_identifiers
//     StateSetter _listSetState, {
//     ServiceCounterTabModel? editableService,
//     int? editingIndex,
//     required String from,
//   }) async {
//     if (!isAlreadyLaunched) {
//       isAlreadyLaunched = true;
//       UtilityService.showLoadingAlert(context);
//       await GeneralDataService.initServiceAndCounterData();
//       Navigator.pop(context);
//       showDialog(
//           context: context,
//           builder: (context) {
//             return SetNewServiceTab(
//               editableService: editableService,
//               editingIndex: editingIndex,
//             );
//           }).then((value) {
//         isAlreadyLaunched = false;
//         BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
//       });
//     }
//   }

//   // Future<void> _showAddTabPopup(BuildContext context, StateSetter listSetState,
//   //     {ServiceCounterTabModel? editableService, int? editingIndex}) async {
//   //   UtilityService.showLoadingAlert(context);
//   //   await GeneralDataService.initServiceAndCounterData();
//   //   Navigator.pop(context);
//   //   showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return SetNewServiceTab(
//   //           editableService: editableService,
//   //           editingIndex: editingIndex,
//   //         );
//   //       }).then((value) {
//   //     BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
//   //   });
//   // }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/core/config/constants.dart';
import 'package:oneappcounter/model/service_counter_tab_model.dart';
import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/language_service.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/utility_services.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ServiceCounterTab extends StatelessWidget {
  // ignore: use_super_parameters
  ServiceCounterTab({Key? key}) : super(key: key);

  late StateSetter _listSetState;
  static bool isAlreadyLaunched = false;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? bottomsheetDarkcolor : appBackgrondcolor,
        title: Text(translate('Service Tabs'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
      ),

      // appBar: AppBar(
      //   title: Text(translate('Service Tabs')),
      // ),

      floatingActionButton: (CounterSettingService.counterSettings?.canAddTab ==
              true)
          ? FloatingActionButton(
              onPressed: () async {
                await _showAddTabPopup(context, _listSetState,
                    from: 'floating button click');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? materialIconButtonDark
                  : buttonColor,
              child: Icon(
                Icons.add,
                size: 30,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
              ),
            )
          : null,

      // floatingActionButton:
      //     (CounterSettingService.counterSettings?.canAddTab == true)
      //         ? FloatingActionButton(
      //             onPressed: () async {
      //               await _showAddTabPopup(context, _listSetState,
      //                   from: 'floating button click');
      //             },
      //             child: const Icon(
      //               Icons.add,
      //               size: 30,
      //             ),
      //           )
      //         : null,

      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        _listSetState = setState;
        if (GeneralDataService.getTabs().isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAddTabPopup(context, _listSetState, from: 'tabs empty')
                .then((value) async {
              await SocketService().initialiseSocket();
              await SocketService.registerEvents(isAll: true);
            });
          });
        } else if (GeneralDataService.getTabs().isNotEmpty &&
            GeneralDataService.getTabs()[
                    GeneralDataService.currentServiceCounterTabIndex]
                .services
                .isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAddTabPopup(context, _listSetState,
                editableService: GeneralDataService.getTabs()[
                    GeneralDataService.currentServiceCounterTabIndex],
                editingIndex: GeneralDataService.currentServiceCounterTabIndex,
                from: 'service empty');
          });
        }
        return ListView.separated(
          itemBuilder: (context, index) {
            ServiceCounterTabModel currentItem =
                GeneralDataService.getTabs()[index];
            String titleServiceString = currentItem.serviceString;
            return ListTile(
              trailing: SizedBox(
                width: ((!currentItem.selected &&
                            currentItem.counterSettings.hideServiceEditBtn ==
                                true &&
                            currentItem.counterSettings.canRemoveTab == true) ||
                        (!currentItem.selected &&
                            currentItem.counterSettings.hideServiceEditBtn ==
                                false &&
                            currentItem.counterSettings.canRemoveTab ==
                                false) ||
                        (currentItem.selected &&
                            currentItem.counterSettings.hideServiceEditBtn ==
                                false))
                    ? 14.w
                    : ((currentItem.counterSettings.hideServiceEditBtn ==
                                false &&
                            currentItem.counterSettings.canRemoveTab == true)
                        ? 27.w
                        : 1),
                child: Row(
                  children: [
                    (currentItem.counterSettings.hideServiceEditBtn == true)
                        ? Container()
                        : IconButton(
                            onPressed: () async {
                              UtilityService.showLoadingAlert(context);
                              await GeneralDataService
                                  .initServiceAndCounterData();
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SetNewServiceTab(
                                      editableService: currentItem,
                                      editingIndex: index,
                                    );
                                  }).then((value) {
                                _listSetState(
                                  () {},
                                );
                              });
                            },
                            icon: const Icon(Icons.edit_note),
                          ),
                    (currentItem.counterSettings.canRemoveTab == true) &&
                            !currentItem.selected
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(translate('Delete')),
                                    content: Text(
                                      translate(
                                          'Are you sure you want to do this?'),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(translate('Cancel')),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(translate('Proceed')),
                                        onPressed: () async {
                                          UtilityService.showLoadingAlert(
                                              context);
                                          await GeneralDataService
                                              .deleteServiceTab(
                                            index: index,
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          UtilityService.toast(context,
                                              translate('Tab deleted !'));
                                          _listSetState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete))
                        : Container(),
                  ],
                ),
              ),
              selected: currentItem.selected,
              selectedColor: !UtilityService.isDarkTheme ? buttonColor : null,
              selectedTileColor: !UtilityService.isDarkTheme
                  ? Colors.grey.shade300
                  : Colors.grey.shade800,
              isThreeLine: false,
              dense: false,
              contentPadding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<dynamic>(
                      stream: SocketService.eventReceivedController.stream,
                      builder: (context, snapshot) {
                        if (!currentItem.selected &&
                            snapshot.data is int &&
                            currentItem.services
                                .map((e) => e.id)
                                .toList()
                                .contains(snapshot.data)) {
                          titleServiceString = '* ${currentItem.serviceString}';
                        }
                        return Text(
                          titleServiceString,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    currentItem.counterString,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                if (!currentItem.selected) {
                  UtilityService.showLoadingAlert(context);
                  await GeneralDataService.selectThisTab(
                    index: index,
                    thisTab: currentItem,
                  );
                  await SocketService.connectAfterSwitch();
                  await LanguageService.changeLocaleFn(context);
                  Navigator.pop(context);
                  _listSetState(() {});
                  BlocProvider.of<SettingsBloc>(context)
                      .add(SettingsEventUpdated());
                  return;
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
            );
          },
          itemCount: GeneralDataService.getTabs().isNotEmpty
              ? GeneralDataService.getTabs().length
              : 0,
        );
      }),
    );
  }

  Future<void> _showAddTabPopup(
    BuildContext context,
    StateSetter listSetState, {
    ServiceCounterTabModel? editableService,
    int? editingIndex,
    required String from,
  }) async {
    if (!isAlreadyLaunched) {
      isAlreadyLaunched = true;
      UtilityService.showLoadingAlert(context);
      await GeneralDataService.initServiceAndCounterData();
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return SetNewServiceTab(
              editableService: editableService,
              editingIndex: editingIndex,
            );
          }).then((value) {
        isAlreadyLaunched = false;
        BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
      });
    }
  }
}
