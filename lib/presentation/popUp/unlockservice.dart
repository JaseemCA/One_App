// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/utility_services.dart';


class UnlockService extends StatefulWidget {
  const UnlockService({super.key});

  @override
  State<UnlockService> createState() => _UnlockServiceState();
}

class _UnlockServiceState extends State<UnlockService> {
  bool _checkBoxChecked = true;

  List<ServiceModel> allServices = GeneralDataService.getTabs()[
          GeneralDataService.currentServiceCounterTabIndex]
      .services
      .where(
        (element) => element.isHold == true,
      )
      .toList();

  int service = 0;

  @override
  Widget build(BuildContext context) {
    if (allServices.length == 1) {
      service = allServices[0].id;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(child: SizedBox()),
          Container(
            height: 450,
            width: double.infinity,
            decoration: BoxDecoration(
              color: UtilityService.isDarkTheme
                  ? Colors.grey.shade800
                  : Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
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
                      const Expanded(
                        child: Text(
                          ('Unhold Service'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close_outlined),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<ServiceModel>(
                    compareFn: (item1, current) {
                      if (item1.id == current.id) {
                        return true;
                      }
                      return false;
                    },
                    popupProps: const PopupProps.dialog(showSearchBox: true),
                    items: GeneralDataService.getTabs()[
                            GeneralDataService.currentServiceCounterTabIndex]
                        .services
                        .where(
                          (element) => element.isHold == true,
                        )
                        .toList(),
                    itemAsString: (value) {
                      return value.displayName;
                    },
                    onChanged: (value) {
                      service = value!.id;
                    },
                    selectedItem: service != 0 &&
                            GeneralDataService.getTabs()[GeneralDataService
                                    .currentServiceCounterTabIndex]
                                .services
                                .contains(GeneralDataService.getTabs()[
                                        GeneralDataService
                                            .currentServiceCounterTabIndex]
                                    .services
                                    .firstWhere(
                                        (element) => element.id == service))
                        ? GeneralDataService.getTabs()[GeneralDataService
                                .currentServiceCounterTabIndex]
                            .services
                            .firstWhere((element) => element.id == service)
                        : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    StatefulBuilder(builder:
                        (BuildContext context, StateSetter checkBoxsetState) {
                      return Checkbox(
                        value: _checkBoxChecked,
                        onChanged: (value) {
                          _checkBoxChecked = value ?? false;
                          checkBoxsetState(() {});
                        },
                      );
                    }),
                    const Text(('Sent Unholding Message to Customers')),
                  ]),
                  ElevatedButton(
                    onPressed: () async {
                      if (service != 0) {
                        Map<String, dynamic> data = {
                          "sent_message": _checkBoxChecked,
                          "service": service,
                        };
                        UtilityService.showLoadingAlert(context);
                        if (await GeneralDataService.unlockService(data)) {
                          Navigator.pop(context);
                          BlocProvider.of<SettingsBloc>(context)
                              .add(HomePageSettingsChangedEvent());
                          Navigator.pop(context);
                          return;
                        }
                        UtilityService.toast(context, ('Something went wrong'));
                      } else {
                        UtilityService.toast(
                            context, ('please select a service'));
                      }
                    },
                    child: const Text(('UNHOLD')),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
