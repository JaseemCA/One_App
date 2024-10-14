// // ignore_for_file: use_build_context_synchronously

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:oneappcounter/core/config/color/appcolors.dart';
// import 'package:oneappcounter/model/counter_model.dart';
// import 'package:oneappcounter/model/service_counter_tab_model.dart';
// import 'package:oneappcounter/model/service_model.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/utility_services.dart';
// // import 'package:sizer/sizer.dart';

// class SetNewServiceTab extends StatelessWidget {
//   const SetNewServiceTab({
//     super.key,
//     this.editableService,
//     this.editingIndex,
//   });

//   final ServiceCounterTabModel? editableService;
//   final int? editingIndex;
//   static List<ServiceModel> _selectedServices = [];
//   static CounterModel? _counter;
//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     _selectedServices = editableService?.services ?? [];
//     _counter = editableService?.counter;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           const Expanded(child: SizedBox()),
//           Container(
//             height: 420,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: isDarkMode ? Colors.grey.shade800 : Colors.white,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.zero,
//                 bottomRight: Radius.zero,
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Expanded(
//                         child: Text(
//                           'Select Services And Counter',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         alignment: Alignment.centerRight,
//                         onPressed: () async {
//                           if (GeneralDataService.getTabs().isNotEmpty) {
//                             if (editableService != null &&
//                                 editableService!.serviceString.isEmpty) {
//                               List<ServiceModel> services =
//                                   editableService?.services ?? [];
//                               if (services.isEmpty) {
//                                 UtilityService.showLoadingAlert(context);
//                                 await GeneralDataService.deleteServiceTab(
//                                   index: GeneralDataService
//                                       .currentServiceCounterTabIndex,
//                                 );
//                                 await GeneralDataService.resetIndex();
//                                 Navigator.pop(context);
//                                 if (GeneralDataService.getTabs().isNotEmpty) {
//                                   Navigator.pop(context);
//                                   return;
//                                 }
//                                 UtilityService.toast(
//                                     context, 'Atleast one tab required!');
//                               } else {
//                                 Navigator.pop(context);
//                               }
//                             } else {
//                               Navigator.pop(context);
//                             }
//                           } else {
//                             UtilityService.toast(
//                                 context, 'Atleast one tab required!');
//                           }
//                         },
//                         icon: const Icon(Icons.close_outlined),
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   DropdownSearch<ServiceModel>.multiSelection(
//                     compareFn: (item1, current) {
//                       if (item1.id == current.id) {
//                         return true;
//                       }
//                       return false;
//                     },
//                     popupProps: const PopupPropsMultiSelection.dialog(
//                       showSearchBox: true,
//                     ),
//                     dropdownDecoratorProps: const DropDownDecoratorProps(
//                       dropdownSearchDecoration: InputDecoration(
//                         labelText: "Services",
//                       ),
//                     ),
//                     items: GeneralDataService.getActiveServices(),
//                     selectedItems: _selectedServices,
//                     itemAsString: (value) {
//                       return value.displayName;
//                     },
//                     onChanged: (value) {
//                       _selectedServices.clear();
//                       _selectedServices = value;
//                       UtilityService.showLoadingAlert(context);
//                       GeneralDataService.updateValsFromStorage()
//                           .then((value) => Navigator.pop(context));
//                     },
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   DropdownSearch<CounterModel>(
//                     compareFn: (item1, current) {
//                       if (item1.id == current.id) {
//                         return true;
//                       }
//                       return false;
//                     },
//                     popupProps: const PopupProps.dialog(
//                       showSearchBox: true,
//                       showSelectedItems: true,
//                     ),
//                     dropdownDecoratorProps: const DropDownDecoratorProps(
//                       dropdownSearchDecoration: InputDecoration(
//                         labelText: "Counter",
//                       ),
//                     ),
//                     items: GeneralDataService.getActiveCounters(),
//                     selectedItem: _counter,
//                     itemAsString: (value) {
//                       return value.name;
//                     },
//                     onChanged: (value) {
//                       _counter = value;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: WidgetStateProperty.all<Color>(
//                         isDarkMode
//                             ? Appcolors.materialIconButtonDark
//                             : Appcolors.buttonColor,
//                       ),
//                       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     onPressed: () async {
//                       if (_counter != null && _selectedServices.isNotEmpty) {
//                         UtilityService.showLoadingAlert(context);
//                         var check =
//                             await GeneralDataService.checkTabAlreadyFound(
//                           counter: _counter!,
//                           services: _selectedServices,
//                         );
//                         Navigator.pop(context);
//                         if (check['status'] == true) {
//                           UtilityService.showLoadingAlert(context);
//                           showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: const Text('Duplicate Tab'),
//                                   content: const Text(
//                                       'Would you like to switch tab?'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text('Close'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () async {
//                                         UtilityService.showLoadingAlert(
//                                             context);
//                                         await GeneralDataService.selectThisTab(
//                                           index: check['index'],
//                                           thisTab: GeneralDataService.getTabs()[
//                                               check['index']],
//                                         );

//                                         ///close loading alert
//                                         Navigator.pop(context);

//                                         ///close loading
//                                         Navigator.pop(context);

//                                         ///close show dilaogue
//                                         Navigator.pop(context);

//                                         ///close popup of set service widget.
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text('Switch Tab'),
//                                     )
//                                   ],
//                                 );
//                               });
//                           // await SocketService.connectAfterSwitch();
//                         } else {
//                           if (_selectedServices.isNotEmpty) {
//                             UtilityService.showLoadingAlert(context);
//                             if (editableService != null) {
//                               await GeneralDataService.updateTab(
//                                 services: _selectedServices,
//                                 counter: _counter!,
//                                 index: editingIndex,
//                               );
//                               // BlocProvider.of<SettingsBloc>(context)
//                               //     .add(HomePageSettingsChangedEvent());
//                             } else {
//                               await GeneralDataService
//                                   .createNewServiceAndCounterTab(
//                                 services: _selectedServices,
//                                 counter: _counter!,
//                               );
//                             }
//                           } else {
//                             UtilityService.toast(
//                                 context, 'All fileds required');
//                           }
//                           // await SocketService.connectAfterSwitch();

//                           ///close loading alert
//                           Navigator.pop(context);

//                           ///close popup of set service widget.
//                           Navigator.pop(context);
//                         }
//                       } else {
//                         UtilityService.toast(context, 'All fileds required');
//                       }
//                     },
//                     child: const Text('Save'),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
// import 'package:oneappcounter/core/config/constants.dart';
import 'package:oneappcounter/model/counter_model.dart';
import 'package:oneappcounter/model/service_counter_tab_model.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:oneappcounter/services/utility_services.dart';

class SetNewServiceTab extends StatefulWidget {
  const SetNewServiceTab({
    super.key,
    this.editableService,
    this.editingIndex,
  });

  final ServiceCounterTabModel? editableService;
  final int? editingIndex;

  @override
  _SetNewServiceTabState createState() => _SetNewServiceTabState();
}

class _SetNewServiceTabState extends State<SetNewServiceTab> {
  List<ServiceModel> _selectedServices = [];
  CounterModel? _counter;

  @override
  void initState() {
    super.initState();
    _selectedServices = widget.editableService?.services ?? [];
    _counter = widget.editableService?.counter;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(child: SizedBox()),
          Container(
            height: 420,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          translate('Select Services And Counter'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () async {
                          if (!mounted) return;
                          if (GeneralDataService.getTabs().isNotEmpty) {
                            if (widget.editableService != null &&
                                widget.editableService!.serviceString.isEmpty) {
                              List<ServiceModel> services =
                                  widget.editableService?.services ?? [];
                              if (services.isEmpty) {
                                UtilityService.showLoadingAlert(context);
                                await GeneralDataService.deleteServiceTab(
                                  index: GeneralDataService
                                      .currentServiceCounterTabIndex,
                                );
                                await GeneralDataService.resetIndex();
                                if (!mounted) return;
                                Navigator.pop(context); // Close loading
                                if (GeneralDataService.getTabs().isNotEmpty) {
                                  Navigator.pop(context); // Close dialog
                                  return;
                                }
                                UtilityService.toast(context,
                                    translate('Atleast one tab required!'));
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          } else {
                            UtilityService.toast(context,
                                translate('Atleast one tab required!'));
                          }
                        },
                        icon: const Icon(Icons.close_outlined),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<ServiceModel>.multiSelection(
                    compareFn: (item1, current) => item1.id == current.id,
                    popupProps: const PopupPropsMultiSelection.dialog(
                      showSearchBox: true,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: translate("Services"),
                      ),
                    ),
                    items: GeneralDataService.getActiveServices(),
                    selectedItems: _selectedServices,
                    itemAsString: (value) => value.displayName,
                    onChanged: (value) async {
                      _selectedServices = value;
                      UtilityService.showLoadingAlert(context);
                      await GeneralDataService.updateValsFromStorage();
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<CounterModel>(
                    compareFn: (item1, current) => item1.id == current.id,
                    popupProps: const PopupProps.dialog(
                      showSearchBox: true,
                      showSelectedItems: true,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: translate("Counter"),
                      ),
                    ),
                    items: GeneralDataService.getActiveCounters(),
                    selectedItem: _counter,
                    itemAsString: (value) => value.name,
                    onChanged: (value) {
                      setState(() {
                        _counter = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    // style: ButtonStyle(
                    //   backgroundColor: WidgetStateProperty.all<Color>(
                    //     isDarkMode
                    //         ? materialIconButtonDark
                    //         : buttonColor,
                    //   ),
                    //   shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    //     RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                    onPressed: () async {
                      if (_counter != null && _selectedServices.isNotEmpty) {
                        UtilityService.showLoadingAlert(context);
                        var check =
                            await GeneralDataService.checkTabAlreadyFound(
                          counter: _counter!,
                          services: _selectedServices,
                        );
                        if (!mounted) return;
                        Navigator.pop(context); // Close loading
                        if (check['status'] == true) {
                          UtilityService.showLoadingAlert(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(translate('Duplicate Tab')),
                                  content: Text(translate(
                                      'Would you like to switch tab?')),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(translate('Close')),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        UtilityService.showLoadingAlert(
                                            context);
                                        await GeneralDataService.selectThisTab(
                                          index: check['index'],
                                          thisTab: GeneralDataService.getTabs()[
                                              check['index']],
                                        );
                                        // if (mounted) return;
                                        Navigator.pop(context); // Close loading
                                        Navigator.pop(context); // Close dialog
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(translate('Switch Tab')),
                                    )
                                  ],
                                );
                              });
                          await SocketService.connectAfterSwitch();
                        } else {
                          if (_selectedServices.isNotEmpty) {
                            UtilityService.showLoadingAlert(context);
                            if (widget.editableService != null) {
                              await GeneralDataService.updateTab(
                                services: _selectedServices,
                                counter: _counter!,
                                index: widget.editingIndex,
                              );
                              BlocProvider.of<SettingsBloc>(context)
                                  .add(HomePageSettingsChangedEvent());
                            } else {
                              await GeneralDataService
                                  .createNewServiceAndCounterTab(
                                services: _selectedServices,
                                counter: _counter!,
                              );
                            }
                            await SocketService.connectAfterSwitch();
                            if (!mounted) return;
                            Navigator.pop(context); // Close loading
                            Navigator.pop(context); // Close popup
                          } else {
                            UtilityService.toast(
                                context, translate('All fileds required'));
                          }
                        }
                      } else {
                        UtilityService.toast(
                            context, translate('All fileds required'));
                      }
                    },
                    child: Text(translate('Save')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
