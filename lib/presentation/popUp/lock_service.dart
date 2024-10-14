// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/common/widgets/button/custom_button.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/utility_services.dart';

class LockService extends StatefulWidget {
  const LockService({super.key});

  @override
  State<LockService> createState() => _LockServiceState();
}

class _LockServiceState extends State<LockService> {
  String selectedTime = '';

  final DateFormat _dateFormat = DateFormat.jm();

  int service = 0;
  final _messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                       Expanded(
                        child: Text(translate
                          ('Hold Service'),
                          textAlign: TextAlign.center,
                          style:const TextStyle(
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
                    popupProps: const PopupProps.dialog(
                      showSearchBox: true,
                      showSelectedItems: true,
                    ),
                    items: GeneralDataService.getTabs()[
                            GeneralDataService.currentServiceCounterTabIndex]
                        .services
                        .where(
                          (element) => element.isHold == false,
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
                  TextFormField(
                    controller: _messageTextController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: ('Message')),
                    minLines: 2,
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                    builder:
                        (BuildContext context, StateSetter buttonSetState) {
                      return OutlinedButton(
                      
                        onPressed: () {
                          DatePicker.showTime12hPicker(
                            context,
                            showTitleActions: true,
                            onChanged: (date) {
                              selectedTime = _dateFormat.format(date);
                              buttonSetState(() {});
                            },
                            onConfirm: (date) {
                              selectedTime = _dateFormat.format(date);
                              buttonSetState(() {});
                            },
                            onCancel: () {
                              selectedTime = '';
                            },
                            currentTime: selectedTime.isEmpty
                                ? DateTime.now()
                                : _dateFormat.parse(selectedTime),
                            // theme: DatePickerTheme(
                            //   headerColor: Colors.white70,
                            //   backgroundColor: !UtilityService.isDarkTheme
                            //       ? Colors.white
                            //       : Colors.black54,
                            //   itemStyle: TextStyle(
                            //     color: !UtilityService.isDarkTheme
                            //         ? Colors.black54
                            //         : Colors.white,
                            //   ),
                            // ),
                          );
                        },
                        child: selectedTime.isEmpty
                            ?  Text(translate('Expected Ending Time'))
                            : Text(
                                '${translate('Expected Ending Time')}: $selectedTime'),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    onPressed: () async {
                      if (_messageTextController.text.isNotEmpty &&
                          service != 0 &&
                          selectedTime.isNotEmpty) {
                        Map<String, dynamic> data = {
                          "expected_ending_time": selectedTime,
                          "message": _messageTextController.text,
                          "service": service,
                        };
                        UtilityService.showLoadingAlert(context);
                        if (await GeneralDataService.lockService(data)) {
                          Navigator.pop(context);
                          BlocProvider.of<SettingsBloc>(context)
                              .add(HomePageSettingsChangedEvent());
                          Navigator.pop(context);
                          return;
                        }
                        UtilityService.toast(context, translate('Something went wrong'));
                      } else {
                        UtilityService.toast(
                            context,translate ('Fill all required fields'));
                      }
                    },
                    child:  Text(translate('HOLD')),
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
