// // ignore_for_file: use_build_context_synchronousl, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
// import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
// import 'package:oneappcounter/model/service_counter_tab_model.dart';
// import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/socket_services.dart';
// import 'package:oneappcounter/services/utility_services.dart';

// class ServiceCounterTab extends StatefulWidget {
//   const ServiceCounterTab({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ServiceCounterTabState createState() => _ServiceCounterTabState();
// }

// class _ServiceCounterTabState extends State<ServiceCounterTab> {
//   late StateSetter listSetState;
//   late bool isDarkMode;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     // _handleInitialData();
//   }

//   // void _handleInitialData() {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) async {
//   //     if (GeneralDataService.getTabs().isEmpty) {

//   //       await _showAddTabPopup(context);
//   //     } else if (GeneralDataService.getTabs()[
//   //             GeneralDataService.currentServiceCounterTabIndex]
//   //         .services
//   //         .isEmpty) {
//   //       // Show popup if the current tab has no services
//   //       await _showAddTabPopup(
//   //         context,
//   //         editableService: GeneralDataService.getTabs()[
//   //             GeneralDataService.currentServiceCounterTabIndex],
//   //         editingIndex: GeneralDataService.currentServiceCounterTabIndex,
//   //       );
//   //     }
//   //   });
//   // }
//   // void _handleInitialData() {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) async {
//   //     // Ensure that this method is part of a StatefulWidget's State class
//   //     if (!mounted) return;

//   //     try {
//   //       // Fetch tabs from the service (assuming getTabs is an async function)
//   //       final tabs = GeneralDataService.getTabs();

//   //       if (tabs.isEmpty) {
//   //         // Show popup if there are no tabs
//   //         await _showAddTabPopup(context);
//   //       } else {
//   //         final currentTabIndex =
//   //             GeneralDataService.currentServiceCounterTabIndex;

//   //         // Check if currentTabIndex is within the bounds of tabs
//   //         if (currentTabIndex >= 0 && currentTabIndex < tabs.length) {
//   //           final currentTab = tabs[currentTabIndex];

//   //           if (currentTab.services.isEmpty) {
//   //             // Show popup if the current tab has no services
//   //             await _showAddTabPopup(
//   //               context,
//   //               editableService: currentTab,
//   //               editingIndex: currentTabIndex,
//   //             );
//   //           }
//   //         }
//   //       }
//   //     } catch (e) {
//   //       // Error handling for network or data fetching issues
//   //       log("error ocuered in bottom sheet" as num);
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Service Tabs',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await _showAddTabPopup(context, listSetState);
//         },
//         child: const Icon(
//           Icons.add,
//           size: 30,
//         ),
//       ),

//       body: StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           listSetState = setState;
//           if (GeneralDataService.getTabs().isEmpty) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _showAddTabPopup(context, listSetState).then((value) async {
//                 await SocketService().initliseSocket();
//                 await SocketService.registerEvents(isAll: true);
//               });
//             });
//           } else if (GeneralDataService.getTabs().isNotEmpty &&
//               GeneralDataService.getTabs()[
//                       GeneralDataService.currentServiceCounterTabIndex]
//                   .services
//                   .isEmpty) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _showAddTabPopup(
//                 context,
//                 listSetState,
//                 editableService: GeneralDataService.getTabs()[
//                     GeneralDataService.currentServiceCounterTabIndex],
//                 editingIndex: GeneralDataService.currentServiceCounterTabIndex,
//               );
//             });
//           }
//           return ListView.separated(
//             itemBuilder: (context, index) {
//               ServiceCounterTabModel currentItem =
//                   GeneralDataService.getTabs()[index];
//               String titleServiceString = currentItem.serviceString;
//               return ListTile(
//                 trailing: SizedBox(
//                   width: 100,
//                   child: Row(
//                     children: [
//                       IconButton(
//                           onPressed: () async {
//                             UtilityService.showLoadingAlert(context);
//                             await GeneralDataService
//                                 .initServiceAndCounterData();
//                             Navigator.pop(context);
//                             showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return SetNewServiceTab(
//                                     editableService: currentItem,
//                                     editingIndex: index,
//                                   );
//                                 }).then((value) {
//                               listSetState(
//                                 () {},
//                               );
//                             });
//                           },
//                           icon: const Icon(Icons.edit_note)),
//                       !currentItem.selected
//                           ? IconButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: const Text(('Delete')),
//                                       content: const Text(
//                                         ('Are you sure you want to do this?'),
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           child: const Text(('Cancel')),
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                         ),
//                                         TextButton(
//                                           child: const Text(('Proceed')),
//                                           onPressed: () async {
//                                             UtilityService.showLoadingAlert(
//                                                 context);
//                                             await GeneralDataService
//                                                 .deleteServiceTab(
//                                               index: index,
//                                             );
//                                             Navigator.pop(context);
//                                             Navigator.pop(context);
//                                             UtilityService.toast(
//                                                 context, ('Tab deleted !'));
//                                             listSetState(() {});
//                                           },
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                               icon: const Icon(Icons.delete))
//                           : Container(),
//                     ],
//                   ),
//                 ),
//                 selected: currentItem.selected,
//                 selectedColor:
//                     !UtilityService.isDarkTheme ? Appcolors.buttonColor : null,
//                 selectedTileColor: !UtilityService.isDarkTheme
//                     ? Colors.grey.shade300
//                     : Colors.grey.shade800,
//                 isThreeLine: false,
//                 dense: false,
//                 contentPadding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     StreamBuilder<dynamic>(
//                         stream: SocketService.eventReceivedController.stream,
//                         builder: (context, snapshot) {
//                           if (!currentItem.selected &&
//                               snapshot.data is int &&
//                               currentItem.services
//                                   .map((e) => e.id)
//                                   .toList()
//                                   .contains(snapshot.data)) {
//                             titleServiceString =
//                                 '* ${currentItem.serviceString}';
//                           }
//                           return Text(
//                             titleServiceString,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           );
//                         }),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       currentItem.counterString,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 onTap: () async {
//                   if (!currentItem.selected) {
//                     UtilityService.showLoadingAlert(context);
//                     await GeneralDataService.selectThisTab(
//                       index: index,
//                       thisTab: currentItem,
//                     );
//                     await SocketService.connectAfterSwitch();
//                     // await LanguageService.changeLocaleFn(context);
//                     Navigator.pop(context);
//                     listSetState(() {});
//                     BlocProvider.of<SettingsBloc>(context)
//                         .add(SettingsEventUpdated());
//                     return;
//                   }
//                 },
//               );
//             },
//             separatorBuilder: (context, index) {
//               return const Divider(
//                 height: 1,
//               );
//             },
//             itemCount: GeneralDataService.getTabs().isNotEmpty
//                 ? GeneralDataService.getTabs().length
//                 : 0,
//           );
//         },
//       ),

//       // body: ListView.separated(
//       //   itemBuilder: (context, index) {
//       //     ServiceCounterTabModel currentItem =
//       //         GeneralDataService.getTabs()[index];
//       //     String titleServiceString = currentItem.serviceString;
//       //     return ListTile(
//       //       trailing: _buildTrailingIcons(currentItem, index),
//       //       selected: currentItem.selected,
//       //       selectedColor: isDarkMode ? Appcolors.buttonColor : null,
//       //       selectedTileColor: isDarkMode
//       //           ? Colors.grey.shade300
//       //           : const Color.fromARGB(255, 113, 112, 112),
//       //       contentPadding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
//       //       title: Column(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         children: [
//       //           _buildTitleStream(currentItem, titleServiceString),
//       //           const SizedBox(height: 5),
//       //           Text(
//       //             currentItem.counterString,
//       //             style: const TextStyle(
//       //               fontWeight: FontWeight.bold,
//       //               overflow: TextOverflow.ellipsis,
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //       onTap: () => _handleTabSelection(currentItem, index),
//       //     );
//       //   },
//       //   separatorBuilder: (context, index) => const Divider(height: 1),
//       //   itemCount: GeneralDataService.getTabs().isNotEmpty
//       //       ? GeneralDataService.getTabs().length
//       //       : 0,
//       // ),
//     );
//   }

//   // Widget _buildTrailingIcons(ServiceCounterTabModel currentItem, int index) {
//   //   return Row(
//   //     mainAxisSize: MainAxisSize.min,
//   //     children: [
//   //       IconButton(
//   //         onPressed: () async {
//   //           await _editServiceTab(currentItem, index);
//   //         },
//   //         icon: const Icon(Icons.edit_note),
//   //       ),
//   //       if (!currentItem.selected)
//   //         IconButton(
//   //           onPressed: () => _confirmDeleteTab(index),
//   //           icon: const Icon(Icons.delete),
//   //         ),
//   //     ],
//   //   );
//   // }

//   // Widget _buildTitleStream(
//   //     ServiceCounterTabModel currentItem, String titleServiceString) {
//   //   return StreamBuilder<dynamic>(
//   //     stream: null,
//   //     builder: (context, snapshot) {
//   //       if (!currentItem.selected &&
//   //           snapshot.data is int &&
//   //           currentItem.services.map((e) => e.id).contains(snapshot.data)) {
//   //         titleServiceString = '* ${currentItem.serviceString}';
//   //       }
//   //       return Text(
//   //         titleServiceString,
//   //         style: const TextStyle(
//   //           fontWeight: FontWeight.bold,
//   //           overflow: TextOverflow.ellipsis,
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   // Future<void> _handleTabSelection(
//   //     ServiceCounterTabModel currentItem, int index) async {
//   //   if (!currentItem.selected) {
//   //     UtilityService.showLoadingAlert(context);
//   //     await GeneralDataService.selectThisTab(
//   //         index: index, thisTab: currentItem);
//   //     Navigator.pop(context);
//   //     setState(() {});
//   //     BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
//   //     return;
//   //   }
//   // }

//   // Future<void> _editServiceTab(
//   //     ServiceCounterTabModel currentItem, int index) async {
//   //   UtilityService.showLoadingAlert(context);
//   //   await GeneralDataService.initServiceAndCounterData();
//   //   Navigator.pop(context);
//   //   await showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return SetNewServiceTab(
//   //         editableService: currentItem,
//   //         editingIndex: index,
//   //       );
//   //     },
//   //   );
//   //   setState(() {});
//   // }

//   // Future<void> _confirmDeleteTab(int index) async {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: const Text('Delete'),
//   //         content: const Text('Are you sure you want to do this?'),
//   //         actions: [
//   //           TextButton(
//   //             child: const Text('Cancel'),
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //           ),
//   //           TextButton(
//   //             child: const Text('Proceed'),
//   //             onPressed: () async {
//   //               UtilityService.showLoadingAlert(context);
//   //               await GeneralDataService.deleteServiceTab(index: index);
//   //               Navigator.pop(context);
//   //               Navigator.pop(context);
//   //               UtilityService.toast(context, 'Tab deleted !');
//   //               setState(() {});
//   //             },
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

// ignore_for_file: use_build_context_synchronously

//   Future<void> _showAddTabPopup(
//     BuildContext context,
//     StateSetter listSetState, {
//     ServiceCounterTabModel? editableService,
//     int? editingIndex,
//   }) async {
//     UtilityService.showLoadingAlert(context);
//     await GeneralDataService.initServiceAndCounterData();
//     Navigator.pop(context);
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return SetNewServiceTab(
//           editableService: editableService,
//           editingIndex: editingIndex,
//         );
//       },
//     ).then((value) {
//       BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/core/config/constants.dart';
import 'package:oneappcounter/model/service_counter_tab_model.dart';
import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/utility_services.dart';

// ignore: must_be_immutable
class ServiceCounterTab extends StatefulWidget {
  const ServiceCounterTab({super.key});

  @override
  State<ServiceCounterTab> createState() => _ServiceCounterTabState();
}

class _ServiceCounterTabState extends State<ServiceCounterTab> {
  late StateSetter _listSetState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(('Service Tabs'),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
      ),
      floatingActionButton: FloatingActionButton(
      
        onPressed: () async {
          await _showAddTabPopup(context, _listSetState);
        },
        
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        _listSetState = setState;

        if (GeneralDataService.getTabs().isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAddTabPopup(context, _listSetState).then((value) async {
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
            _showAddTabPopup(
              context,
              _listSetState,
              editableService: GeneralDataService.getTabs()[
                  GeneralDataService.currentServiceCounterTabIndex],
              editingIndex: GeneralDataService.currentServiceCounterTabIndex,
            );
          });
        }
        return ListView.separated(
          itemBuilder: (context, index) {
            ServiceCounterTabModel currentItem =
                GeneralDataService.getTabs()[index];
            String titleServiceString = currentItem.serviceString;
            return ListTile(
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        UtilityService.showLoadingAlert(context);
                        await GeneralDataService.initServiceAndCounterData();
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SetNewServiceTab(
                                editableService: currentItem,
                                editingIndex: index,
                              );
                            }).then((value) {
                          _listSetState(() {});
                        });
                      },
                      icon: const Icon(Icons.edit_note),
                    ),
                    !currentItem.selected
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(('Delete')),
                                    content: const Text(
                                      ('Are you sure you want to do this?'),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(('Cancel')),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(('Proceed')),
                                        onPressed: () async {
                                          UtilityService.showLoadingAlert(
                                              context);
                                          await GeneralDataService
                                              .deleteServiceTab(index: index);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          UtilityService.toast(
                                              context, ('Tab deleted!'));
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
              selectedColor:
                  !UtilityService.isDarkTheme ? buttonColor : null,
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
                    },
                  ),
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

  Future<void> _showAddTabPopup(BuildContext context, StateSetter listSetState,
      {ServiceCounterTabModel? editableService, int? editingIndex}) async {
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
      BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
    });
  }
}
