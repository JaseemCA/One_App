// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/model/service_counter_tab_model.dart';
import 'package:oneappcounter/presentation/popUp/add_service.dart.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/utility_services.dart';


// ignore: must_be_immutable
class ServiceCounterTab extends StatelessWidget {
  ServiceCounterTab({super.key});

  late StateSetter _listSetState;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Tabs'),
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
              // await SocketService().initliseSocket();
              // await SocketService.registerEvents(isAll: true);
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
                width: 17,
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
                            _listSetState(
                              () {},
                            );
                          });
                        },
                        icon: const Icon(Icons.edit_note)),
                    !currentItem.selected
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text(
                                        'Are you sure you want to do this?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Proceed'),
                                        onPressed: () async {
                                          UtilityService.showLoadingAlert(
                                              context);
                                          await GeneralDataService
                                              .deleteServiceTab(
                                            index: index,
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          UtilityService.toast(
                                              context, 'Tab deleted !');
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
              selectedColor: isDarkMode ? Appcolors.buttonColor : null,
              selectedTileColor:
                  isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
              isThreeLine: false,
              dense: false,
              contentPadding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<dynamic>(
                      stream: null,
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
                  // await SocketService.connectAfterSwitch();
                  // await LanguageService.changeLocaleFn(context);
                  Navigator.pop(context);
                  _listSetState(() {});
                  // BlocProvider.of<SettingsBloc>(context)
                  //     .add(SettingsEventUpdated());
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
  }) async {
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
      // BlocProvider.of<SettingsBloc>(context).add(SettingsEventUpdated());
    });
  }
}
