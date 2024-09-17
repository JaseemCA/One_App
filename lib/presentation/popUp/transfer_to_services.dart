// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:oneappcounter/core/config/color/appcolors.dart';
import 'package:oneappcounter/model/service_model.dart';
import 'package:oneappcounter/model/tocken_model.dart';
import 'package:oneappcounter/services/call_service.dart';
import 'package:oneappcounter/services/counter_setting_service.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/utility_services.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class TransferToServices extends StatelessWidget {
  TransferToServices({super.key, required this.selectedToken});

  // ignore: prefer_final_fields
  List<int> _selectedServices = [];
  String _priority = "Normal";
  bool _return = false;
  final TokenModel selectedToken;

  @override
  Widget build(BuildContext context) {
    List<ServiceModel> _activeServices = GeneralDataService.activeServices
        .where((element) => element.id != selectedToken.serviceId)
        .toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(child: SizedBox()),
          Container(
            height: 78.h,
            width: 100.w,
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
                          ('Transfer Token'),
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
                  Container(
                    height: 40.h,
                    padding: const EdgeInsets.all(3),
                    child: StatefulBuilder(builder:
                        (BuildContext context, StateSetter gridViewsetState) {
                      return GridView.builder(
                          itemCount: _activeServices.isNotEmpty
                              ? _activeServices.length
                              : 0,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2.6,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                          ),
                          itemBuilder: (context, index) {
                            int id = _activeServices[index].id;
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !_selectedServices.contains(id)
                                      ? Appcolors.buttonSelectedColor
                                      : null,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  if (CounterSettingService
                                          .counterSettings?.multipleTransfer ==
                                      true) {
                                    if (_selectedServices.contains(id)) {
                                      int index = _selectedServices.indexWhere(
                                          (element) => element == id);
                                      _selectedServices.removeAt(index);
                                      setState(() {});
                                      return;
                                    }
                                    _selectedServices.add(id);
                                    setState(() {});
                                  } else {
                                    _selectedServices.clear();
                                    _selectedServices.add(id);
                                    gridViewsetState(() {});
                                  }
                                },
                                child: FittedBox(
                                  child: Text(
                                    _activeServices[index].name,
                                    style: const TextStyle(
                                      height: 1,
                                    ),
                                  ),
                                ),
                              );
                            });
                          });
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: DropdownSearch<String>(
                        items: const ["High", "Normal", "Low"],
                        popupProps: const PopupProps.menu(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: ("Priority"),
                            hintText: ("Transfer Priority"),
                          ),
                        ),
                        onChanged: (value) {
                          _priority = value!;
                        },
                        selectedItem: _priority,
                      )),
                      CounterSettingService.counterSettings?.multipleTransfer ==
                              true
                          ? Expanded(
                              child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Text(('Return')),
                                  StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return Checkbox(
                                        value: _return,
                                        onChanged: (value) {
                                          setState(() {
                                            _return = value!;
                                          });
                                        });
                                  }),
                                ],
                              ),
                            ))
                          : Container()
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      UtilityService.showLoadingAlert(context);
                      Map<String, dynamic> data = {
                        'transfer_service_ids': _selectedServices,
                        'priority': _priority == "High"
                            ? 1
                            : _priority == "Normal"
                                ? 2
                                : 3,
                        'return': _return
                      };
                      if (CounterSettingService
                              .counterSettings?.multipleTransferAtATime ==
                          true) {
                        data['multi_transfer_at_a_time'] = 1;
                      }
                      var response = await CallService.transferService(
                        data: data,
                        token: selectedToken,
                      );
                      Navigator.pop(context);
                      if (response is bool && response) {
                        UtilityService.toast(context, ('Transfered'));
                        Navigator.pop(context);
                        return;
                      }
                      UtilityService.toast(
                          context, ('Somthing went wrong'));
                    },
                    child: const Text(('TRANSFER')),
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
